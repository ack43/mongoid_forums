$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mongoid_forums/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ack-mongoid-forums"
  s.version     = MongoidForums::VERSION
  s.authors     = ["ack43", "skipperguy12"]
  s.email       = ["i43ack@gmail.com", "skipperguy12@users.noreply.github.com"]
  s.homepage    = "https://github.com/ack43/mongoid_forums"
  s.summary     = "Forum engine for Rails 4 and mongoid. Forked from https://github.com/NJayDevelopment/mongoid_forums"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.require_paths = ['lib']
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency 'mongoid', "4.0.0"
  s.add_dependency 'simple_form'
  s.add_dependency 'kaminari', '0.15.1'
  s.add_dependency 'sanitize', '2.0.6'
  s.add_dependency 'cancancan', '~> 1.10'
  s.add_dependency 'decorators', '1.0.2'
  s.add_dependency "haml"

  s.add_dependency 'ack_rocket_cms'

  s.add_development_dependency 'devise', '~> 3.4.0'
  s.add_development_dependency "jquery-rails"
  s.add_development_dependency "pry-rails"
end
