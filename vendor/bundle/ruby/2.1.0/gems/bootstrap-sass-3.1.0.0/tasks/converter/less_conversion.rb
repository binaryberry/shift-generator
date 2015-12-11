require_relative 'char_string_scanner'

# This module transforms LESS into SCSS.
# It is implemented via lots of string manipulation: scanning back and forwards for regexps and doing substitions.
# Since it does not parse the LESS into an AST, bits of it may assume LESS to be formatted a certain way, and only limited,
# static analysis can be performed. This approach has so far been mostly enough to automatically convert most all of twbs/bootstrap.
# There is some bootstrap-specific to make up for lack of certain features in Sass 3.2 (recursion, mixin namespacing)
# and vice versa in LESS (vararg mixins).
class Converter
  module LessConversion
    # Some regexps for matching bits of SCSS:
    SELECTOR_CHAR               = '\[\]$\w\-{}#,.:&>@'
    # 1 selector (the part before the {)
    SELECTOR_RE                 = /[#{SELECTOR_CHAR}]+[#{SELECTOR_CHAR}\s]*/
    # 1 // comment
    COMMENT_RE                  = %r((?:^[ \t]*//[^\n]*\n))
    # 1 {, except when part of @{ and #{
    RULE_OPEN_BRACE_RE          = /(?<![@#\$])\{/
    # same as the one above, but in reverse (on a reversed string)
    RULE_OPEN_BRACE_RE_REVERSE  = /\{(?![@#\$])/
    # match closed brace, except when \w precedes }, or when }[.'"]. a heurestic to exclude } that are not selector body close }
    RULE_CLOSE_BRACE_RE         = /(?<!\w)\}(?![.'"])/
    RULE_CLOSE_BRACE_RE_REVERSE = /(?<![.'"])\}(?!\w)/
    # match any brace that opens or closes a properties body
    BRACE_RE                    = /#{RULE_OPEN_BRACE_RE}|#{RULE_CLOSE_BRACE_RE}/m
    BRACE_RE_REVERSE            = /#{RULE_OPEN_BRACE_RE_REVERSE}|#{RULE_CLOSE_BRACE_RE_REVERSE}/m
    # valid
    SCSS_MIXIN_DEF_ARGS_RE      = /[\w\-,\s$:#%()]*/
    LESS_MIXIN_DEF_ARGS_RE      = /[\w\-,;.\s@:#%()]*/

    # These mixins are nested (not supported by SCSS), and need to flattened:
    NESTED_MIXINS               = {'#gradient' => 'gradient'}

    # These mixins will get vararg definitions in SCSS (not supported by LESS):
    VARARG_MIXINS               = %w(
    transition transition-duration transition-property transition-transform box-shadow
  )

    # Convert a snippet of bootstrap LESS to Scss
    def convert_less(less)
      load_shared
      less = convert_to_scss(less)
      less = yield(less) if block_given?
      less
    end

    def load_shared
      @shared_mixins ||= begin
        log_status '  Reading shared mixins from mixins.less'
        read_mixins read_files('less', ['mixins.less'])['mixins.less'], nested: NESTED_MIXINS
      end
    end

    def process_stylesheet_assets
      log_status 'Processing stylesheets...'
      files = read_files('less', bootstrap_less_files)

      log_status '  Converting LESS files to Scss:'
      files.each do |name, file|
        log_processing name
        # apply common conversions
        file = convert_less(file)
        case name
          when 'mixins.less'
            NESTED_MIXINS.each do |selector, prefix|
              file = flatten_mixins(file, selector, prefix)
            end
            file = varargify_mixin_definitions(file, *VARARG_MIXINS)
            file = deinterpolate_vararg_mixins(file)
            %w(responsive-(in)?visibility input-size).each do |mixin|
              file = parameterize_mixin_parent_selector file, mixin
            end
            file = replace_ms_filters(file)
            file = replace_all file, /(?<=[.-])\$state/, '#{$state}'
            file = replace_rules(file, '  .list-group-item-') { |rule| extract_nested_rule rule, 'a&' }
            file = replace_all file, /,\s*\.open \.dropdown-toggle& \{(.*?)\}/m,
                               " {\\1}\n  .open & { &.dropdown-toggle {\\1} }"
            file = convert_grid_mixins file
          when 'responsive-utilities.less'
            file = apply_mixin_parent_selector(file, '&\.(visible|hidden)')
            file = apply_mixin_parent_selector(file, '(?<!&)\.(visible|hidden)')
            file = replace_rules(file, '  @media') { |r| unindent(r, 2) }
          when 'variables.less'
            file = insert_default_vars(file)
            file = unindent <<-SCSS + file, 14
              // a flag to toggle asset pipeline / compass integration
              // defaults to true if twbs-font-path function is present (no function => twbs-font-path('') parsed as string == right side)
              // in Sass 3.3 this can be improved with: function-exists(twbs-font-path)
              $bootstrap-sass-asset-helper: (twbs-font-path("") != unquote('twbs-font-path("")')) !default;
            SCSS
            file = replace_all file, /(\$icon-font-path:).*(!default)/, '\1 "bootstrap/" \2'
          when 'close.less'
            # extract .close { button& {...} } rule
            file = extract_nested_rule file, 'button&'
          when 'dropdowns.less'
            file = replace_all file, /@extend \.dropdown-menu-right;/, 'right: 0; left: auto;'
            file = replace_all file, /@extend \.dropdown-menu-left;/, 'left: 0; right: auto;'
          when 'forms.less'
            file = extract_nested_rule file, 'textarea&'
            file = apply_mixin_parent_selector(file, '\.input-(?:sm|lg)')
          when 'navbar.less'
            file = replace_all file, /(\s*)\.navbar-(right|left)\s*\{\s*@extend\s*\.pull-(right|left);\s*/, "\\1.navbar-\\2 {\\1  float: \\2 !important;\\1"
          when 'tables.less'
            file = replace_all file, /(@include\s*table-row-variant\()(\w+)/, "\\1'\\2'"
          when 'thumbnails.less'
            file = extract_nested_rule file, 'a&'
          when 'glyphicons.less'
            file = replace_all file, /\#\{(url\(.*?\))}/, '\1'
            file = replace_rules(file, '@font-face') { |rule|
              rule = replace_all rule, /(\$icon-font(?:-\w+)+)/, '#{\1}'
              replace_asset_url rule, :font
            }
        end

        name    = name.sub(/\.less$/, '.scss')
        save_to = @save_to[:scss]
        path    = "#{save_to}/#{'_' unless name == 'bootstrap.scss'}#{name}"
        save_file(path, file)
        log_processed File.basename(path)
      end
    end

    def bootstrap_less_files
      @bootstrap_less_files ||= get_paths_by_type('less', /\.less$/)
    end

    # apply general less to scss conversion
    def convert_to_scss(file)
      # get local mixin names before converting the definitions
      mixins = @shared_mixins + read_mixins(file)
      file   = replace_vars(file)
      file   = replace_file_imports(file)
      file   = replace_mixin_definitions(file)
      file   = replace_mixins(file, mixins)
      file   = replace_spin(file)
      file   = replace_image_urls(file)
      file   = replace_escaping(file)
      file   = convert_less_ampersand(file)
      file   = deinterpolate_vararg_mixins(file)
      file   = replace_calculation_semantics(file)
      file   = replace_redundant_ampersands(file)
      file
    end

    # a&:hover => a:hover
    def replace_redundant_ampersands(file)
      file.gsub /([\w+])&([:\w]+)/, '\1\2'
    end

    def replace_asset_url(rule, type)
      replace_all rule, /url\((.*?)\)/, "url(if($bootstrap-sass-asset-helper, twbs-#{type}-path(\\1), \\1))"
    end

    # convert grid mixins LESS when => SASS @if
    def convert_grid_mixins(file)
      file = replace_rules file, /@mixin make-grid-columns/, comments: false do |css, pos|
        mxn_def = css.each_line.first
        classes = if css =~ /-columns-float/
                    '.col-#{$class}-#{$i}'
                  else
                    '.col-xs-#{$i}, .col-sm-#{$i}, .col-md-#{$i}, .col-lg-#{$i}'
                  end
        body = (css =~ /\$list \{\n(.*?)\n[ ]*\}/m) && $1
        unindent <<-SASS, 8
        // [converter] Grid converted to use SASS cycles (LESS uses recursive nested mixin defs not supported by SASS)
        #{mxn_def.strip}
          $list: '';
          $i: 1;
          $list: "#{classes}";
          @for $i from 2 through $grid-columns {
            $list: "#{classes}, \#{$list}";
          }
          \#{$list} {
        #{unindent body}
          }
        }
        SASS
      end
      file = replace_rules file, /@mixin calc-grid/ do |css|
        css = indent css.gsub(/.*when (.*?) {/, '@if \1 {').gsub(/(?<=\$type) = (\w+)/, ' == \1').gsub(/(?<=-)(\$[a-z]+)/, '#{\1}')
        if css =~ /== width/
          css = "@mixin calc-grid($index, $class, $type) {\n#{css}"
        elsif css =~ /== offset/
          css += "\n}"
        end
        css
      end
      file = replace_rules file, /@mixin make-grid\(/ do |css|
        unindent <<-SASS, 8
        // [converter] This is defined recursively in LESS, but SASS supports real loops
        @mixin make-grid($columns, $class, $type) {
          @for $i from 0 through $columns {
            @include calc-grid($i, $class, $type);
          }
        }
        SASS
      end
      file
    end


    # We need to keep a list of shared mixin names in order to convert the includes correctly
    # Before doing any processing we read shared mixins from a file
    # If a mixin is nested, it gets prefixed in the list (e.g. #gradient > .horizontal to 'gradient-horizontal')
    def read_mixins(mixins_file, nested: {})
      mixins = get_mixin_names(mixins_file, silent: true)
      nested.each do |selector, prefix|
        # we use replace_rules without replacing anything just to use the parsing algorithm
        replace_rules(mixins_file, selector) { |rule|
          mixins += get_mixin_names(unindent(unwrap_rule_block(rule)), silent: true).map { |name| "#{prefix}-#{name}" }
          rule
        }
      end
      mixins.uniq!
      mixins.sort!
      log_file_info "mixins: #{mixins * ', '}" unless mixins.empty?
      mixins
    end

    def get_mixin_names(file, opts = {})
      names = get_css_selectors(file).join("\n" * 2).scan(/^\.([\w-]+)\(#{LESS_MIXIN_DEF_ARGS_RE}\)(?: when.*?)?[ ]*\{/).map(&:first).uniq.sort
      log_file_info "mixin defs: #{names * ', '}" unless opts[:silent] || names.empty?
      names
    end

    # margin: a -b
    # LESS: sets 2 values
    # SASS: sets 1 value (a-b)
    # This wraps a and -b so they evaluates to 2 values in SASS
    def replace_calculation_semantics(file)
      # split_prop_val.call('(@navbar-padding-vertical / 2) -@navbar-padding-horizontal')
      # #=> ["(navbar-padding-vertical / 2)", "-navbar-padding-horizontal"]
      split_prop_val = proc { |val|
        s         = CharStringScanner.new(val)
        r         = []
        buff      = ''
        d         = 0
        prop_char = %r([\$\w\-/\*\+%!])
        while (token = s.scan_next(/([\)\(]|\s+|#{prop_char}+)/))
          buff << token
          case token
            when '('
              d += 1
            when ')'
              d -= 1
              if d == 0
                r << buff
                buff = ''
              end
            when /\s/
              if d == 0 && !buff.strip.empty?
                r << buff
                buff = ''
              end
          end
        end
        r << buff unless buff.empty?
        r.map(&:strip)
      }

      replace_rules file do |rule|
        replace_properties rule do |props|
          props.gsub /(?<!\w)([\w-]+):(.*?);/ do |m|
            prop, vals = $1, split_prop_val.call($2)
            next m unless vals.length >= 2 && vals.any? { |v| v =~ /^[\+\-]\$/ }
            transformed = vals.map { |v| v.strip =~ %r(^\(.*\)$) ? v : "(#{v})" }
            log_transform "property #{prop}: #{transformed * ' '}", from: 'wrap_calculation'
            "#{prop}: #{transformed * ' '};"
          end
        end
      end
    end

    # @import "file.less" to "#{target_path}file;"
    def replace_file_imports(less, target_path = '')
      less.gsub %r([@\$]import ["|']([\w-]+).less["|'];),
                %Q(@import "#{target_path}\\1";)
    end

    def replace_all(file, regex, replacement = nil, &block)
      log_transform regex, replacement
      new_file = file.gsub(regex, replacement, &block)
      raise "replace_all #{regex}, #{replacement} NO MATCH" if file == new_file
      new_file
    end

    # @mixin a() { tr& { color:white } }
    # to:
    # @mixin a($parent) { tr#{$parent} { color: white } }
    def parameterize_mixin_parent_selector(file, rule_sel)
      log_transform rule_sel
      param = '$parent'
      replace_rules(file, '^\s*@mixin\s*' + rule_sel) do |mxn_css|
        mxn_css.sub! /(?=@mixin)/, "// [converter] $parent hack\n"
        # insert param into mixin def
        mxn_css.sub!(/(@mixin [\w-]+)\(([\$\w\-,\s]*)\)/) { "#{$1}(#{param}#{', ' if $2 && !$2.empty?}#{$2})" }
        # wrap properties in #{$parent} { ... }
        replace_properties(mxn_css) { |props| props.strip.empty? ? props : "  \#{#{param}} { #{props.strip} }\n  " }
        # change nested& rules to nested#{$parent}
        replace_rules(mxn_css, /.*&[ ,]/) { |rule| replace_in_selector rule, /&/, "\#{#{param}}" }
      end
    end

    # extracts rule immediately after it's parent, and adjust the selector
    # .x { textarea& { ... }}
    # to:
    # .x { ... }
    # textarea.x { ... }
    def extract_nested_rule(file, selector, new_selector = nil)
      matches = []
      # first find the rules, and remove them
      file    = replace_rules(file, "\s*#{selector}", comments: true) { |rule, pos, css|
        matches << [rule, pos]
        new_selector ||= "#{get_selector(rule).gsub(/&/, selector_for_pos(css, pos.begin))}"
        indent "// [converter] extracted #{get_selector(rule)} to #{new_selector}".tr("\n", ' ').squeeze(' '), indent_width(rule)
      }
      raise "extract_nested_rule: no such selector: #{selector}" if matches.empty?
      log_transform selector, new_selector
      # replace rule selector with new_selector
      matches.each do |m|
        m[0].sub! /(#{COMMENT_RE}*)^(\s*).*?(\s*){/m, "\\1\\2#{new_selector}\\3{"
      end
      replace_substrings_at file,
                            matches.map { |_, pos| close_brace_pos(file, pos.begin, 1) + 1 },
                            matches.map { |rule, _| "\n\n" + unindent(rule) }
    end

    # .visible-sm { @include responsive-visibility() }
    # to:
    # @include responsive-visibility('.visible-sm')
    def apply_mixin_parent_selector(file, rule_sel)
      log_transform rule_sel
      replace_rules file, '\s*' + rule_sel, comments: false do |rule, rule_pos, css|
        body = unwrap_rule_block(rule.dup).strip
        next rule unless body =~ /^@include \w+/m || body =~ /^@media/ && body =~ /\{\s*@include/
        rule =~ /(#{COMMENT_RE}*)([#{SELECTOR_CHAR}]+?)\s*#{RULE_OPEN_BRACE_RE}/
        cmt, sel = $1, $2.strip
        # take one up selector chain if this is an &. selector
        if sel.start_with?('&')
          parent_sel = selector_for_pos(css, rule_pos.begin)
          sel        = parent_sel + sel[1..-1]
        end
        # unwrap, and replace @include
        unindent unwrap_rule_block(rule).gsub(/(@include [\w-]+)\(([\$\w\-,\s]*)\)/) {
          "#{cmt}#{$1}('#{sel}'#{', ' if $2 && !$2.empty?}#{$2})"
        }
      end
    end

    # #gradient > { @mixin horizontal ... }
    # to:
    # @mixin gradient-horizontal
    def flatten_mixins(file, container, prefix)
      log_transform container, prefix
      replace_rules file, Regexp.escape(container) do |mixins_css|
        unindent unwrap_rule_block(mixins_css).gsub(/@mixin\s*([\w-]+)/, "@mixin #{prefix}-\\1")
      end
    end

    # @include and @extend from LESS:
    #  .mixin()             -> @include mixin()
    #  #scope > .mixin()    -> @include scope-mixin()
    #  &:extend(.mixin all) -> @include mixin()
    def replace_mixins(less, mixin_names)
      mixin_pattern = /(\s+)(([#|\.][\w-]+\s*>\s*)*)\.([\w-]+\(.*\))(?!\s\{)/

      less = less.gsub(mixin_pattern) do |match|
        matches = match.scan(mixin_pattern).flatten
        scope   = matches[1] || ''
        if scope != ''
          scope = scope.scan(/[\w-]+/).join('-') + '-'
        end
        mixin_name = match.scan(/\.([\w-]+)\(.*\)\s?\{?/).first
        if mixin_name && mixin_names.include?("#{scope}#{mixin_name.first}")
          "#{matches.first}@include #{scope}#{matches.last}".gsub(/; \$/, ", $").sub(/;\)$/, ')')
        else
          "#{matches.first}@extend .#{scope}#{matches.last.gsub(/\(\)/, '')}"
        end
      end

      less.gsub /&:extend\((#{SELECTOR_RE}) all\)/ do
        selector = $1
        selector =~ /\.([\w-]+)/
        mixin    = $1
        if mixin && mixin_names.include?(mixin)
          "@include #{mixin}()"
        else
          "@extend #{selector}"
        end
      end
    end

    # change Microsoft filters to SASS calling convention
    def replace_ms_filters(file)
      log_transform
      file.gsub(
          /filter: e\(%\("progid:DXImageTransform.Microsoft.gradient\(startColorstr='%d', endColorstr='%d', GradientType=(\d)\)",argb\(([\-$\w]+)\),argb\(([\-$\w]+)\)\)\);/,
          %Q(filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='\#{ie-hex-str(\\2)}', endColorstr='\#{ie-hex-str(\\3)}', GradientType=\\1);)
      )
    end

    # unwraps topmost rule block
    # #sel { a: b; }
    # to:
    # a: b;
    def unwrap_rule_block(css)
      css[(css =~ RULE_OPEN_BRACE_RE) + 1..-1].sub(/\n?}\s*\z/m, '')
    end

    def replace_mixin_definitions(less)
      less.gsub(/^(\s*)\.([\w-]+\(.*\))(\s*\{)/) { |match|
        "#{$1}@mixin #{$2.tr(';', ',')}#{$3}".sub(/,\)/, ')')
      }
    end

    def replace_vars(less)
      less = less.dup
      # skip header comment
      less =~ %r(\A/\*(.*?)\*/)m
      from           = $~ ? $~.to_s.length : 0
      less[from..-1] = less[from..-1].
          gsub(/(?!@mixin|@media|@page|@keyframes|@font-face|@-\w)@/, '$').
          # variables that would be ignored by gsub above: e.g. @page-header-border-color
          gsub(/@(page[\w-]+)/, '$\1')
      less
    end

    def replace_spin(less)
      less.gsub(/(?![\-$@.])spin(?!-)/, 'adjust-hue')
    end

    def replace_image_urls(less)
      less.gsub(/background-image: url\("?(.*?)"?\);/) { |s| replace_asset_url s, :image }
    end

    def replace_escaping(less)
      less = less.gsub(/~"([^"]+)"/, '#{\1}') # Get rid of ~"" escape
      less.gsub!(/\$\{([^}]+)\}/, '$\1') # Get rid of @{} escape
      less.gsub!(/"([^"\n]*)(\$[\w\-]+)([^"\n]*)"/, '"\1#{\2}\3"') # interpolate variable in string, e.g. url("$file-1x") => url("#{$file-1x}")
      less.gsub(/(\W)e\(%\("?([^"]*)"?\)\)/, '\1\2') # Get rid of e(%("")) escape
    end

    def insert_default_vars(scss)
      log_transform
      scss.gsub(/^(\$.+);/, '\1 !default;')
    end

    # Converts &-
    def convert_less_ampersand(less)
      regx = /^\.badge\s*\{[\s\/\w\(\)]+(&{1}-{1})\w.*?^}$/m

      tmp = ''
      less.scan(/^(\s*&)(-[\w\[\]]+\s*\{.+})$/) do |ampersand, css|
        tmp << ".badge#{css}\n"
      end

      less.gsub(regx, tmp)
    end

    # unindent by n spaces
    def unindent(txt, n = 2)
      txt.gsub /^[ ]{#{n}}/, ''
    end

    # indent by n spaces
    def indent(txt, n = 2)
      spaces = ' ' * n
      txt.gsub /^/, spaces
    end

    # get indent length from the first line of txt
    def indent_width(txt)
      txt.match(/\A\s*/).to_s.length
    end

    # @mixin transition($transition) {
    # to:
    # @mixin transition($transition...) {
    def varargify_mixin_definitions(scss, *mixins)
      log_transform *mixins
      scss = scss.dup
      mixins.each do |mixin|
        scss.gsub! /(@mixin\s*#{Regexp.quote(mixin)})\((#{SCSS_MIXIN_DEF_ARGS_RE})\)/, '\1(\2...)'
      end
      scss
    end

    # @include transition(#{border-color ease-in-out .15s, box-shadow ease-in-out .15s})
    # to
    # @include transition(border-color ease-in-out .15s, box-shadow ease-in-out .15s)
    def deinterpolate_vararg_mixins(scss)
      scss = scss.dup
      VARARG_MIXINS.each do |mixin|
        if scss.gsub! /(@include\s*#{Regexp.quote(mixin)})\(\s*\#\{([^}]+)\}\s*\)/, '\1(\2)'
          log_transform mixin
        end
      end
      scss
    end

    # get full selector for rule_block
    def get_selector(rule_block)
      /^\s*(#{SELECTOR_RE}?)\s*\{/.match(rule_block) && $1 && $1.strip
    end

    # replace CSS rule blocks matching rule_prefix with yield(rule_block, rule_pos)
    # will also include immediately preceding comments in rule_block
    #
    # option :comments -- include immediately preceding comments in rule_block
    #
    # replace_rules(".a{ \n .b{} }", '.b') { |rule, pos| ">#{rule}<"  } #=> ".a{ \n >.b{}< }"
    def replace_rules(less, rule_prefix = SELECTOR_RE, options = {}, &block)
      options = {comments: true}.merge(options || {})
      less    = less.dup
      s       = CharStringScanner.new(less)
      rule_re = /(?:#{rule_prefix}[#{SELECTOR_CHAR})=(\s]*?#{RULE_OPEN_BRACE_RE})/
      if options[:comments]
        rule_start_re = /(?:#{COMMENT_RE}*)^#{rule_re}/
      else
        rule_start_re = /^#{rule_re}/
      end

      positions = []
      while (rule_start = s.scan_next(rule_start_re))
        pos = s.pos
        positions << (pos - rule_start.length..close_brace_pos(less, pos - 1))
      end
      replace_substrings_at(less, positions, &block)
      less
    end

    # Get a all top-level selectors (with {)
    def get_css_selectors(css, opts = {})
      s         = CharStringScanner.new(css)
      selectors = []
      while s.scan_next(RULE_OPEN_BRACE_RE)
        brace_pos = s.pos
        def_pos   = css_def_pos(css, brace_pos+1, -1)
        sel       = css[def_pos.begin..brace_pos - 1].dup
        sel.strip! if opts[:strip]
        selectors << sel
        sel.dup.strip
        s.pos = close_brace_pos(css, brace_pos, 1) + 1
      end
      selectors
    end

    # replace in the top-level selector
    # replace_in_selector('a {a: {a: a} } a {}', /a/, 'b') => 'b {a: {a: a} } b {}'
    def replace_in_selector(css, pattern, sub)
      # scan for selector positions in css
      s        = CharStringScanner.new(css)
      prev_pos = 0
      sel_pos  = []
      while (brace = s.scan_next(RULE_OPEN_BRACE_RE))
        pos = s.pos
        sel_pos << (prev_pos .. pos - 1)
        s.pos    = close_brace_pos(css, s.pos - 1) + 1
        prev_pos = pos
      end
      replace_substrings_at(css, sel_pos) { |s| s.gsub(pattern, sub) }
    end


    # replace first level properties in the css with yields
    # replace_properties("a { color: white }") { |props| props.gsub 'white', 'red' }
    def replace_properties(css, &block)
      s = CharStringScanner.new(css)
      s.skip_until /#{RULE_OPEN_BRACE_RE}\n?/
      prev_pos = s.pos
      depth    = 0
      pos      = []
      while (b = s.scan_next(/#{SELECTOR_RE}#{RULE_OPEN_BRACE_RE}|#{RULE_CLOSE_BRACE_RE}/m))
        s_pos = s.pos
        depth += (b == '}' ? -1 : +1)
        if depth == 1
          if b == '}'
            prev_pos = s_pos
          else
            pos << (prev_pos .. s_pos - b.length - 1)
          end
        end
      end
      replace_substrings_at css, pos, &block
    end


    # immediate selector of css at pos
    def selector_for_pos(css, pos, depth = -1)
      css[css_def_pos(css, pos, depth)].dup.strip
    end

    # get the pos of css def at pos (search backwards)
    def css_def_pos(css, pos, depth = -1)
      to       = open_brace_pos(css, pos, depth)
      prev_def = to - (css[0..to].reverse.index(RULE_CLOSE_BRACE_RE_REVERSE) || to) + 1
      from     = prev_def + 1 + (css[prev_def + 1..-1] =~ %r(^\s*[^\s/]))
      (from..to - 1)
    end

    # next matching brace for brace at from
    def close_brace_pos(css, from, depth = 0)
      s = CharStringScanner.new(css[from..-1])
      while (b = s.scan_next(BRACE_RE))
        depth += (b == '}' ? -1 : +1)
        break if depth.zero?
      end
      raise "match not found for {" unless depth.zero?
      from + s.pos - 1
    end

    # opening brace position from +from+ (search backwards)
    def open_brace_pos(css, from, depth = 0)
      s = CharStringScanner.new(css[0..from].reverse)
      while (b = s.scan_next(BRACE_RE_REVERSE))
        depth += (b == '{' ? +1 : -1)
        break if depth.zero?
      end
      raise "matching { brace not found" unless depth.zero?
      from - s.pos + 1
    end

    # insert substitutions into text at positions (Range or Fixnum)
    # substitutions can be passed as array or as yields from the &block called with |substring, position, text|
    # position is a range (begin..end)
    def replace_substrings_at(text, positions, replacements = nil, &block)
      offset = 0
      positions.each_with_index do |p, i|
        p       = (p...p) if p.is_a?(Fixnum)
        from    = p.begin + offset
        to      = p.end + offset
        p       = p.exclude_end? ? (from...to) : (from..to)
        # block returns the substitution, e.g.: { |text, pos| text[pos].upcase }
        r       = replacements ? replacements[i] : block.call(text[p], p, text)
        text[p] = r
        # add the change in length to offset
        offset  += r.size - (p.end - p.begin + (p.exclude_end? ? 0 : 1))
      end
      text
    end
  end
end
