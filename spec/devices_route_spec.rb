require 'spec_helper'
require 'shared_examples_for_rest_api'

describe "Devices" do
  let(:redis_access) { DeviceAccess.new(RedisConnection.client) }
  let(:controller) { 'devices' }
  let(:data) { {'token' => DEFAULT_UUID, 'type' => 'ios'} }
  it_behaves_like 'rest api'
end
