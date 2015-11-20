# -*- encoding: utf-8 -*-
# stub: govuk_admin_template 3.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "govuk_admin_template"
  s.version = "3.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["GOV.UK Dev"]
  s.date = "2015-11-03"
  s.description = "Styles, scripts and templates for GOV.UK admin applications"
  s.email = ["govuk-dev@digital.cabinet-office.gov.uk"]
  s.homepage = "https://github.com/alphagov/govuk_admin_template"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.2"
  s.summary = "Styles, scripts and templates for GOV.UK admin applications"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.2.0"])
      s.add_runtime_dependency(%q<bootstrap-sass>, ["~> 3.3.3"])
      s.add_runtime_dependency(%q<jquery-rails>, ["~> 3.1.3"])
      s.add_development_dependency(%q<sass-rails>, ["= 3.2.6"])
      s.add_development_dependency(%q<rspec-rails>, ["= 2.14.2"])
      s.add_development_dependency(%q<capybara>, ["= 2.4.4"])
      s.add_development_dependency(%q<gem_publisher>, ["= 1.3.1"])
      s.add_development_dependency(%q<jasmine>, ["= 2.1.0"])
    else
      s.add_dependency(%q<rails>, [">= 3.2.0"])
      s.add_dependency(%q<bootstrap-sass>, ["~> 3.3.3"])
      s.add_dependency(%q<jquery-rails>, ["~> 3.1.3"])
      s.add_dependency(%q<sass-rails>, ["= 3.2.6"])
      s.add_dependency(%q<rspec-rails>, ["= 2.14.2"])
      s.add_dependency(%q<capybara>, ["= 2.4.4"])
      s.add_dependency(%q<gem_publisher>, ["= 1.3.1"])
      s.add_dependency(%q<jasmine>, ["= 2.1.0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.2.0"])
    s.add_dependency(%q<bootstrap-sass>, ["~> 3.3.3"])
    s.add_dependency(%q<jquery-rails>, ["~> 3.1.3"])
    s.add_dependency(%q<sass-rails>, ["= 3.2.6"])
    s.add_dependency(%q<rspec-rails>, ["= 2.14.2"])
    s.add_dependency(%q<capybara>, ["= 2.4.4"])
    s.add_dependency(%q<gem_publisher>, ["= 1.3.1"])
    s.add_dependency(%q<jasmine>, ["= 2.1.0"])
  end
end
