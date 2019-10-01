# -*- encoding: utf-8 -*-
# stub: dry-initializer 3.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "dry-initializer".freeze
  s.version = "3.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vladimir Kochnev (marshall-lee)".freeze, "Andrew Kozin (nepalez)".freeze]
  s.date = "2019-04-15"
  s.email = "andrew.kozin@gmail.com".freeze
  s.extra_rdoc_files = ["README.md".freeze, "CHANGELOG.md".freeze]
  s.files = ["CHANGELOG.md".freeze, "README.md".freeze]
  s.homepage = "https://github.com/dry-rb/dry-initializer".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "DSL for declaring params and options of the initializer".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<rake>.freeze, ["> 10"])
      s.add_development_dependency(%q<dry-types>.freeze, ["> 0.5.1"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.49.0"])
    else
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<rake>.freeze, ["> 10"])
      s.add_dependency(%q<dry-types>.freeze, ["> 0.5.1"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.49.0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rake>.freeze, ["> 10"])
    s.add_dependency(%q<dry-types>.freeze, ["> 0.5.1"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.49.0"])
  end
end
