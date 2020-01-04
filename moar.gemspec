require_relative "lib/moar/version"

Gem::Specification.new do |spec|
  spec.name        = "moar"
  spec.version     = Moar::VERSION
  spec.authors     = ["Jonathan Hefner"]
  spec.email       = ["jonathan@hefner.pro"]
  spec.homepage    = "https://github.com/jonathanhefner/moar"
  spec.summary     = %q{More-style pagination for Rails}
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.metadata["source_code_uri"] + "/blob/master/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.1"
end
