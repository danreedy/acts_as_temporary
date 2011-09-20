$:.push File.expand_path("../lib", __FILE__)

require "acts_as_temporary/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_temporary"
  s.version     = ActsAsTemporary::VERSION
  s.authors     = ["Daniel Reedy"]
  s.email       = ["danreedy@gmail.com"]
  s.homepage    = "http://about.me/reedy"
  s.summary     = "Adds the abililty to temporarily store an object through ActiveRecord"
  s.description = "In the event that you do not want to clutter your production databases with what could be temporary data you can use this plugin to temporarily store and later retreive data with your database."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.1.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "steak", "~> 2.0.0"
end
