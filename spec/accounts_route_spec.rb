require 'spec_helper'
require 'shared_examples_for_rest_api'

describe "Accounts" do
  let(:redis_access) { AccountAccess.new(RedisConnection.client) }
  let(:controller) { 'accounts' }
  it_behaves_like 'rest api'
end
