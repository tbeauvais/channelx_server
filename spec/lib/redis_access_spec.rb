require 'spec_helper'

shared_examples 'a redis_access' do

  let(:redis_access) { described_class.new(RedisConnection.client) }
  let(:sample_data) { {'name' => 'test', 'link' => 'www.test.com'} }

  context '#fetch_all' do

    it 'returns empty array when no data' do
      expect(redis_access.fetch_all).to eq []
    end

    it 'returns all data' do
      redis_access.add({})
      expect(redis_access.fetch_all.size).to eq 1
    end

    it 'returns correct data' do
      redis_access.add(sample_data)
      expect(redis_access.fetch_all.first).to eq sample_data
    end

  end

  context '#fetch' do

    it 'returns specified data' do
      redis_access.add(sample_data)
      expect(redis_access.fetch(DEFAULT_UUID)).to eq sample_data
    end

    it 'returns nil when data does not exist' do
      redis_access.add({})
      expect(redis_access.fetch('123')).to eq nil
    end

  end


  context '#add' do

    it 'inserts data' do
      expect{redis_access.add(sample_data)}.to change{redis_access.fetch_all.size}.from(0).to(1)
    end

    it 'sets uuid' do
      redis_access.add(sample_data)
      expect(sample_data['id']).to eq DEFAULT_UUID
    end

  end

  context '#delete' do

    it 'returns non-zero if deleted' do
      redis_access.add(sample_data)
      expect(redis_access.delete(sample_data['id'])).to eq 1
    end

    it 'returns zero if key not found' do
      expect(redis_access.delete('123')).to eq 0
    end

    it 'removes data' do
      redis_access.add(sample_data)
      expect{redis_access.delete(DEFAULT_UUID)}.to change{redis_access.fetch_all.size}.from(1).to(0)
    end

  end

end

describe MessageAccess do
  it_behaves_like 'a redis_access'
end

describe AccountAccess do
  it_behaves_like 'a redis_access'
end

