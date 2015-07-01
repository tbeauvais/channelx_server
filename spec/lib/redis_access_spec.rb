require 'spec_helper'
require 'timecop'

shared_examples 'a redis_access' do

  let(:redis_access) { described_class.new(RedisConnection.client) }

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
  let(:sample_data) { {'name' => 'test', 'link' => 'www.test.com'} }
  let(:sample_data2) { {'name' => 'test2', 'link' => 'www.test.com'} }
  let(:redis_access) { described_class.new(RedisConnection.client) }

  it_behaves_like 'a redis_access'

  it 'adds time' do
    redis_access.add(sample_data)
    expect(sample_data['time']).not_to eq nil
  end

  it 'reverse sort by time' do
    expect(SecureRandom).to receive(:uuid).and_return(DEFAULT_UUID, '123')
    time1 = Time.now
    Timecop.freeze(time1) do
      redis_access.add(sample_data)
    end
    time2 = Time.now - 100
    Timecop.freeze(time2) do
      redis_access.add(sample_data2)
    end
    expect(redis_access.fetch_all.map{|a| a['time']}).to eq [time1.to_i, time2.to_i]
  end

end

describe AccountAccess do
  let(:sample_data) { {'name' => 'test', 'link' => 'www.test.com'} }
  it_behaves_like 'a redis_access'
end

describe DeviceAccess do
  let(:sample_data) { {'token' => DEFAULT_UUID, 'type' => 'ios'} }
  it_behaves_like 'a redis_access'
end

