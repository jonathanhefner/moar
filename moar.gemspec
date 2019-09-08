$:.push File.expand_path("lib", __dir__)

require "moar/version"

Gem::Specification.new do |s|
  s.name        = "moar"
  s.version     = Moar::VERSION
  s.authors     = ["Jonathan Hefner"]
  s.email       = ["jonathan@hefner.pro"]
  s.homepage    = "https://github.com/jonathanhefner/moar"
  s.summary     = %q{More-style pagination for Rails}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "puma"
  s.add_development_dependency "capybara", ">= 2.15", "< 4.0"
  s.add_development_dependency "webdrivers"
  s.add_development_dependency "turbolinks", "~> 5.1"
  s.add_development_dependency "yard", "~> 0.9"
end
