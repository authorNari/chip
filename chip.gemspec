# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chip/version"

Gem::Specification.new do |s|
  s.name        = "chip"
  s.version     = Chip::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["nari"]
  s.email       = ["authornari@gmail.com"]
  s.homepage    = "http://github.com/authorNari/chip"
  s.summary     = %q{For easy access to micro Ruby library on a Web page}
  s.description = %q{Chip is a micro program manager for Ruby.}

  s.rubyforge_project = "chip"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
