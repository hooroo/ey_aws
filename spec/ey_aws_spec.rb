require File.expand_path('../../lib/ey_aws', __FILE__)
require 'aws-sdk'
require 'webmock/rspec'

CONFIG = {
  :access_key_id     => 'ACCESS_KEY_ID',
  :secret_access_key => 'SECRET_ACCESS_KEY',
  :ey_cloud_token    => 'EY_CLOUD_TOKEN' }

describe EYAWS do
  let(:volume)     { AWS::EC2::Volume.new('vol-abc123') }
  let(:instance)   { AWS::EC2::Instance.new('i-abcd1234') }
  let(:attachment) { AWS::EC2::Attachment.new(volume, instance, '/dev/xxx') }

  before(:each) do
    # Stub AWS methods
    volume.stub(:send).and_return('vol')
    attachment.stub(:send).and_return('dev')
    instance.stub(:send).and_return('i-abcd1234')
    instance.stub_chain(:block_device_mappings, :each).and_yield("/dev/xxx", attachment)
    AWS::EC2.any_instance.stub_chain(:regions, :[], :instances, :each).and_yield(instance)

    # Stub EY data request
    WebMock.enable!
    WebMock.stub_request(:get, "https://cloud.engineyard.com/api/v2/environments").to_return(
      :status => 200,
      :body => File.read(File.join(File.dirname(__FILE__), 'support', 'cloud_engineyard_com.json'))).times(10)

    # Delete existing environment variables
    ENV.delete 'ACCESS_KEY_ID'
    ENV.delete 'SECRET_ACCESS_KEY'
    ENV.delete 'EY_CLOUD_TOKEN'
  end

  context "authentication" do
    it "using environment variables" do
      ENV['ACCESS_KEY_ID']     = 'ENV_ACCESS_KEY_ID'
      ENV['SECRET_ACCESS_KEY'] = 'ENV_SECRET_ACCESS_KEY'
      ENV['EY_CLOUD_TOKEN']    = 'EY_CLOUD_TOKEN'

      expect { EYAWS.new }.to_not raise_error
    end

    it "using argument variables" do
      expect { EYAWS.new(CONFIG) }.to_not raise_error
    end

    it "raise exception if no credentials" do
      expect { EYAWS.new }.to raise_error RuntimeError
    end
  end

  context "lookup" do
    let(:data)        { EYAWS.new(CONFIG) }
    let(:environment) { data[:environments].first }

    it "finds environment attributes" do
      environment[:name].should == "environment_name"
    end

    it "finds instance attributes" do
      environment[:instances].first[:id].should == 'i-abcd1234'
    end

    it "finds device attributes" do
      environment[:instances].first[:block_device_mappings].first[:device].should == 'dev'
    end

    it "finds volume attributes" do
      environment[:instances].first[:block_device_mappings].first[:volume][:id].should == 'vol'
    end
  end

  it "returns a hash" do
    EYAWS.new(CONFIG).should be_a(Hash)
  end
end
