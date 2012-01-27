# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sproutcore/version"

Gem::Specification.new do |s|
  s.name        = "sproutcore"
  s.version     = SproutCore::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Yehuda Katz", "Tom Dale"]
  s.email       = ["wycats@tilde.io", "tom@tilde.io"]
  s.homepage    = "http://rubygems.org/gems/sproutcore"
  s.summary     = "Simple build tools for SproutCore 2.0 and similar projects"
  s.description = "A set of simple build tools for SproutCore 2.0, now Ember.js. Re-orders files based on inline require statements."

  s.rubyforge_project = "sproutcore"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
