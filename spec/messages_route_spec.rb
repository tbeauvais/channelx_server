require 'spec_helper'
require 'shared_examples_for_rest_api'

describe "Messages" do
  let(:redis_access) { MessageAccess.new(RedisConnection.client) }
  let(:controller) { 'messages' }
  it_behaves_like 'rest api'
end
