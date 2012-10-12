require File.expand_path('../lib/ey_aws/version', __FILE__)

Gem::Specification.new do |gem|
 gem.name        = "ey_aws"
 gem.version     = EYAWS::VERSION
 gem.authors     = [ "James Martelletti" ]
 gem.email       = [ "james@hooroo.com" ]

 gem.summary     = "EngineYard & AWS environment/host information"
 gem.description = "Retrieve your EngineYard & AWS environment/host info via APIs"
 gem.homepage    = "http://github.com/hooroo/ey_aws"

 gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
 gem.files       = `git ls-files`.split("\n")
 gem.test_files  = `git ls-files -- spec/*`.split("\n")

 gem.add_development_dependency "rspec", "~>2.7"
end
