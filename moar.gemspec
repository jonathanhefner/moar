$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "moar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "moar"
  s.version     = Moar::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Moar."
  s.description = "TODO: Description of Moar."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "yard", "~> 0.9"
end
