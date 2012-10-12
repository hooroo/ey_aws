# EYAWS

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

ACCESS_KEY_ID/SECRET_ACCESS_KEY are required for AWS authentication, and
EY_CLOUD_TOKEN (which can be found in ~/.eyrc) for EngineYard.

From the command line

    export ACCESS_KEY_ID='...'
    export SECRET_ACCESS_KEY='...'
    export EY_CLOUD_TOKEN='...'
    ey_aws

Or from your application

    require 'ey_aws'

    data = EYAWS.new({
      :access_key_id     => 'AWS_ACCESS_KEY',
      :secret_access_key => 'AWS_SECRET_KEY',
      :ey_cloud_token    => 'EY_CLOUD_TOKEN' })

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
       [{:id=>"i-sd9d123d2",
         :status=>:running,
         :role=>"app_master",
         :name=>nil,
         :amazon_id=>"i-3d932j233",
         :public_hostname=> "ec2-xx-xx-xx-xx.ap-northeast-1.compute.amazonaws.com",
         :bridge=>true,
         :ami_launch_index=>0,
         :architecture=>:i386,
         :client_token=>nil,
         :dns_name=>"ec2-xx-xx-xx-xx.ap-northeast-1.compute.amazonaws.com",
         :hypervisor=>:xen,
         :image_id=>"ami-12dj883",
         :instance_type=>"c1.medium",
         :ip_address=>"12.23.23.34",
         :kernel_id=>"aki-dc09a2dd",
         :key_name=>nil,
         :launch_time=>2012-06-13 23:14:52 UTC,
         :monitoring=>:disabled,
         :owner_id=>"259285985555",
         :platform=>nil,
         :private_dns_name=>"ip-10-0-0-127.ap-northeast-1.compute.internal",
         :private_ip_address=>"10.0.0.127",
         :ramdisk_id=>nil,
         :requester_id=>nil,
         :reservation_id=>"r-72313355",
         :root_device_name=>nil,
         :root_device_type=>:instance_store,
         :state_transition_reason=>nil,
         :status_code=>16,
         :subnet_id=>nil,
         :virtualization_type=>:paravirtual,
         :vpc_id=>nil,
         :availability_zone=>"ap-northeast-1a",
         :dedicated_tenancy?=>false,
         :exists?=>true,
         :has_elastic_ip?=>true,
         :monitoring_enabled?=>false,
         :spot_instance?=>false,
         :key_pair=>nil,
         :block_device_mappings=>
          [{:device=>"/dev/sdz1",
            :attach_time=>2012-06-13 23:15:59 UTC,
            :delete_on_termination?=>false,
            :exists?=>true,
            :status=>:attached,
            :volume=>
             {:id=>"vol-dbafs2eba",
              :availability_zone_name=>"ap-northeast-1a",
              :create_time=>2012-06-13 23:15:55 UTC,
              :size=>5,
              :status=>:in_use,
              :exists?=>true}}]}],
      :app_master=>
       {:id=>153125,
        :status=>"running",
        :role=>"app_master",
        :name=>nil,
        :amazon_id=>"i-hf923h9f",
        :public_hostname=>"ec2-xx-xx-xx-xx.ap-northeast-1.compute.amazonaws.com",
        :bridge=>true},
      :apps=>
       [{:id=>15085,
         :name=>"appname",
         :repository_uri=>"git@github.com:org/repo.git",
         :app_type_id=>"rails3",
         :account=>{:id=>1234, :name=>"account"}}],
      :deployment_configurations=>
       {:appname=>
         {:id=>46952,
          :domain_name=>"environment.net",
          :uri=>"http://environment.net",
          :migrate=>{:perform=>false, :command=>""},
          :name=>"appname",
          :repository_uri=>"git@github.com:org/repo.git"}}}

## Testing

    bundle exec rake spec

## Alternatives

An alternative to this gem is the [engineyard-metadata](https://github.com/seamusabshere/engineyard-metadata)
gem which also provides similar functionality, engineyard-metadata also supports
returning local data from the chef dna.json file when executed from an EC2 instance.

## Known Issues

Y U SO SLOW? It couldn't hurt to help speed this library up, it will generally take about 60 seconds
for a reasonably sized environment. This may be able to be helped by memoising the additional AWS calls.

## Copyright

Copyright (c) 2012 Hooroo. See LICENSE for details.
