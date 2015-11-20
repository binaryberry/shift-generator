# -*- encoding: utf-8 -*-
# stub: govuk_admin_template 1.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "govuk_admin_template"
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["GOV.UK Dev"]
  s.date = "2014-07-04"
  s.description = "Styles, scripts and templates for GOV.UK admin applications"
  s.email = ["govuk-dev@digital.cabinet-office.gov.uk"]
  s.homepage = "https://github.com/alphagov/govuk_admin_template"
  s.rubygems_version = "2.2.2"
  s.summary = "Styles, scripts and templates for GOV.UK admin applications"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.2.0"])
      s.add_runtime_dependency(%q<bootstrap-sass>, ["= 3.1.0"])
      s.add_runtime_dependency(%q<jquery-rails>, ["= 3.0.4"])
      s.add_development_dependency(%q<rails>, ["= 3.2.18"])
      s.add_development_dependency(%q<sass-rails>, ["= 3.2.6"])
      s.add_development_dependency(%q<rspec-rails>, ["= 2.14.2"])
      s.add_development_dependency(%q<capybara>, ["= 2.2.1"])
      s.add_development_dependency(%q<gem_publisher>, ["= 1.3.1"])
    else
      s.add_dependency(%q<rails>, [">= 3.2.0"])
      s.add_dependency(%q<bootstrap-sass>, ["= 3.1.0"])
      s.add_dependency(%q<jquery-rails>, ["= 3.0.4"])
      s.add_dependency(%q<rails>, ["= 3.2.18"])
      s.add_dependency(%q<sass-rails>, ["= 3.2.6"])
      s.add_dependency(%q<rspec-rails>, ["= 2.14.2"])
      s.add_dependency(%q<capybara>, ["= 2.2.1"])
      s.add_dependency(%q<gem_publisher>, ["= 1.3.1"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.2.0"])
    s.add_dependency(%q<bootstrap-sass>, ["= 3.1.0"])
    s.add_dependency(%q<jquery-rails>, ["= 3.0.4"])
    s.add_dependency(%q<rails>, ["= 3.2.18"])
    s.add_dependency(%q<sass-rails>, ["= 3.2.6"])
    s.add_dependency(%q<rspec-rails>, ["= 2.14.2"])
    s.add_dependency(%q<capybara>, ["= 2.2.1"])
    s.add_dependency(%q<gem_publisher>, ["= 1.3.1"])
  end
end
