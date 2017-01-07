$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "camaleon_spree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "camaleon_spree"
  s.version     = CamaleonSpree::VERSION
  s.authors     = ["Owen Peredo"]
  s.email       = ["owenperedo@gmail.com"]
  s.homepage    = ""
  s.summary     = "Permit to integrate Camaleon CMS + Spree Commerce"
  s.description = "Permit to integrate Camaleon CMS + Spree Commerce"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  # s.add_dependency "camaleon_cms", '>=2.4.3'
  s.add_development_dependency "sqlite3"
end
