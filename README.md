# ey_aws

ey_aws will connect to and retrieve environment and instance data from both EngineYard and AWS to be munged together, this allows us to view which environments we have and metadata for each instance which makes it up. It can be useful to find out instance sizes, IP addresses, attached storage and an estimated cost per hour for each running instance.

## Installation
## Usage

In its simplest form, this gem will collect information from EY and AWS, then munge the results together - resulting in a hash describing all of our environments, this hash can then be queried and manipulated in a programmatic way in your scripts. Before execution you must ensure the environment variables ACCESS_KEY_ID/SECRET_ACCESS_KEY are defined for AWS authentication, and EY_CLOUD_TOKEN for EngineYard. 

  export ACCESS_KEY_ID='...'
  export SECRET_ACCESS_KEY='...'
  export EY_CLOUD_TOKEN='...'

Retrieving the EY/AWS info each time adds a considerable amount of time to the script execution (generally up to 90 secs), so a crude form of caching is enabled by default - any time the refresh method is run it will dump the environments hash to '' in the current working directory. The class will then load the results from this file next time it is initialized unless the 'refresh' method is explicitly called.

Command line:

A simple command line client is provided to allow you to spit out the environments hash.

$ 

Library:

require ''

 = .new
pp .environments

## Output

    {:id=>12345,
      :name=>"environment_name",
      :ssh_username=>"deploy",
      :app_server_stack_name=>"nginx_unicorn",
      :framework_env=>"production",
      :instance_status=>"running",
      :instances_count=>2,
      :load_balancer_ip_address=>"12.34.45.67",
      :account=>{:id=>1234, :name=>"account"},
      :stack_name=>"nginx_unicorn",
      :instances=>
       [{:id=>"i-di12d90b",
         :status=>:running,
         :role=>"app_master",
         :name=>nil,
         :amazon_id=>"i-di12d90b",

## Testing

bundle exec rake spec
