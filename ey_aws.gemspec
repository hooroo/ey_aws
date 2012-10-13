require File.expand_path('../lib/ey_aws/version', __FILE__)

Gem::Specification.new do |gem|
 gem.name        = "ey_aws"
 gem.version     = EYAWS::VERSION
 gem.authors     = [ "James Martelletti" ]
 gem.email       = [ "james@hooroo.com" ]

 gem.summary     = "Engine Yard and AWS environment/host information"
 gem.description = "Retrieve environment and host information from your Engine Yard account, providing detailed information for each EC2 instance."
 gem.homepage    = "http://github.com/hooroo/ey_aws"

 gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
 gem.files       = `git ls-files`.split("\n")
 gem.test_files  = `git ls-files -- spec/*`.split("\n")

 gem.add_dependency             'aws-sdk',     '~>1.6'
 gem.add_dependency             'rest-client', '~>1.6'
 gem.add_development_dependency 'rake',        '~>0.9'
 gem.add_development_dependency 'rspec',       '~>2.11'
 gem.add_development_dependency 'webmock',     '~>1.8'
end
