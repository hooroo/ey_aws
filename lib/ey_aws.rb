require 'rest_client'
require 'json'
require 'aws-sdk'

class EYAWS < Hash
  attr_reader :environments

  EY_URL         = 'https://cloud.engineyard.com/api/v2/environments'
  AWS_ATTRIBUTES = [
    :ami_launch_index,:architecture, :client_token, :dns_name, :hypervisor,
    :id, :image_id, :instance_type, :ip_address, :kernel_id,
    :key_name, :launch_time, :monitoring, :owner_id, :platform,
    :private_dns_name, :private_ip_address, :ramdisk_id, :requester_id, :reservation_id,
    :root_device_name, :root_device_type, :state_transition_reason, :status, :status_code,
    :subnet_id, :virtualization_type, :vpc_id, :availability_zone, :dedicated_tenancy?,
    :exists?, :has_elastic_ip?, :monitoring_enabled?, :spot_instance?, :key_pair ]
  AWS_DEVICE_ATTRIBUTES = [ :device, :attach_time, :delete_on_termination?, :exists?, :status ]
  AWS_VOLUME_ATTRIBUTES = [ :id, :availability_zone_name, :create_time, :size, :status, :exists? ]

  def initialize(opts={})
    regions = []

    access_key_id     = opts[:access_key_id]     ? opts[:access_key_id]     : ENV['ACCESS_KEY_ID']
    secret_access_key = opts[:secret_access_key] ? opts[:secret_access_key] : ENV['SECRET_ACCESS_KEY']
    ey_cloud_token    = opts[:ey_cloud_token]    ? opts[:ey_cloud_token]    : ENV['EY_CLOUD_TOKEN']

    raise "No ACCESS_KEY_ID supplied"     if access_key_id.nil?
    raise "No SECRET_ACCESS_KEY supplied" if secret_access_key.nil?
    raise "No EY_CLOUD_TOKEN supplied"    if ey_cloud_token.nil?

    # Get EY environment info
    @data = JSON.parse(RestClient.get(EY_URL, 'X-EY-Cloud-Token' => ey_cloud_token).body, :symbolize_names => true)

    # Figure out the region each EY host lives in
    @data[:environments].each do |e|
      e[:instances].each do |i|
        regions << i[:public_hostname].split('.')[1]
      end
    end

    # Clean up regions array, us-east-1 region appears to have different hostnames
    regions.uniq!
    regions << 'us-east-1' if regions.reject! { |r| r == 'compute-1' }

    # Request instance info for each region
    regions.each do |region|
      ec2 = AWS::EC2.new(:access_key_id => access_key_id, :secret_access_key => secret_access_key)
      AWS.memoize do
        ec2.regions[region.to_s].instances.each do |inst|
          add_aws_info(inst)
        end
      end
    end

    self.merge!(@data)
  end

  private
  def map_attributes(attributes, data)
    mapped_attributes = {}
    attributes.each do |attr|
      mapped_attributes[attr] = data.send(attr.to_s) if data.respond_to?(attr.to_s)
    end
    mapped_attributes
  end

  def add_aws_info(inst)
    # Grab all our aws attributes
    aws_attributes = map_attributes(AWS_ATTRIBUTES, inst)

    # Find the instance to attach this stuff to
    instance = @data[:environments].map { |e|
      e[:instances].select { |i| i[:amazon_id] == aws_attributes[:id] }
    }.flatten!.first

    # Now grab all the block attributes
    block_devices = []
    inst.block_device_mappings.each do |mnt, device|
      block_device = map_attributes(AWS_DEVICE_ATTRIBUTES, device)

      # And the volume...
      block_device[:volume] = map_attributes(AWS_VOLUME_ATTRIBUTES, device.volume)

      block_devices << block_device
    end
    aws_attributes[:block_device_mappings] = block_devices

    instance.merge!(aws_attributes)
  end
end
