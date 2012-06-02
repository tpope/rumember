Gem::Specification.new do |s|
  s.name          = "rumember"
  s.version       = "1.0.0"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Tim Pope"]
  s.email         = ["code@tpope.n"+'et']
  s.homepage      = "http://github.com/tpope/rumember"
  s.summary       = "Remember The Milk Ruby API and command line client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("json", ["~> 1.7.0"])
  s.add_runtime_dependency("launchy", ["~> 0.3.0"])
  s.add_development_dependency("rspec", ["~> 2.5"])
end
