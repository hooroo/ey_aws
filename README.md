# ey_aws

ey_aws will connect EngineYard and AWS to and retrieve environment and instance
data from both, this allows us to view which environments we have and metadata
for each instance which makes up each enironment. It can be useful to find out
instance sizes, IP addresses and attached storage for each running instance.

## Installation

    gem install ey_aws

## Usage

This gem may be used from the command line to display a formatted Hash
describing all your environments and instances. If running from the command
line you must set some environment variables before executing ey_aws.

ACCESS_KEY_ID/SECRET_ACCESS_KEY are required for AWS authentication, and EY_CLOUD_TOKEN for EngineYard.

You can find EY_CLOUD_TOKEN in your ~/.eyrc

    export ACCESS_KEY_ID='...'
    export SECRET_ACCESS_KEY='...'
    export EY_CLOUD_TOKEN='...'
    ey_aws

Or from your application

    require 'ey_aws'

    data = EYAWS.new({
      :access_key_id => 'AWS_ACCESS_KEY',
      :secret_access_key => 'AWS_SECRET_KEY',
      :ey_cloud_token => 'EY_CLOUD_TOKEN' })

    pp data[:environments]

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
