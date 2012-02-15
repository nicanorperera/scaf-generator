# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scaf-generator/version"

Gem::Specification.new do |s|
  s.name        = "scaf-generator"
  s.version     = Scaf::Generator::VERSION
  s.authors     = ["Nicanor Perera"]
  s.email       = ["nicanorperera@gmail.com"]
  s.homepage    = "http://github.com/nicanorperera/scaf-generator"
  s.summary     = %q{Un Scaffold Generator con Controller en namespace::Admin}
  s.description = %q{Scaffold adaptado a las necesidades de Xaver}

  s.rubyforge_project = "scaf-generator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
