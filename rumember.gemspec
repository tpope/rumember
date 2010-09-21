Gem::Specification.new do |s|
  s.name                = "rumember"
  s.version             = "0.0.0"

  s.summary             = "Remember The Milk Ruby API and command line client"
  s.authors             = ["Tim Pope"]
  s.email               = "code@tpope.n"+'et'
  s.homepage            = "http://github.com/tpope/rumember"
  s.default_executable  = "ru"
  s.executables         = ["ru"]
  s.files               = [
    "README.markdown",
    "MIT-LICENSE",
    "rumember.gemspec",
    "bin/ru",
    "lib/rumember.rb",
    "lib/rumember/abstract.rb",
    "lib/rumember/account.rb",
    "lib/rumember/list.rb",
    "lib/rumember/location.rb",
    "lib/rumember/task.rb",
    "lib/rumember/timeline.rb",
    "lib/rumember/transaction.rb",
  ]
  s.add_runtime_dependency("json", ["~> 1.4.0"])
  s.add_runtime_dependency("launchy", ["~> 0.3.0"])
  s.add_development_dependency("rspec", ["~> 1.3.0"])
end
