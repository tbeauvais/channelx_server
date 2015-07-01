require 'spec_helper'

shared_examples 'rest api' do

  context 'get' do

    it 'status is ok' do
      get "/api/v1/#{controller}"
      expect(last_response).to be_ok
    end

    it 'responds with all datas' do
      redis_access.add(data)
      get "/api/v1/#{controller}"
      datas = JSON.parse(last_response.body)
      expect(datas).to eq [data]
    end

    it 'responds with specific data' do
      redis_access.add(data)
      get "/api/v1/#{controller}/#{data['id']}"
      data = JSON.parse(last_response.body)
      expect(data).to eq data
    end

  end

  context 'post' do

    it 'responds with status is created' do
      post "/api/v1/#{controller}", data.to_json
      expect(last_response.status).to eq 201
    end

    it 'replies with new data id' do
      post "/api/v1/#{controller}", data.to_json
      expect(JSON.parse(last_response.body)).to eq({'id' => DEFAULT_UUID})
    end

    it 'add new data' do
      expect { post "/api/v1/#{controller}", data.to_json }.to change { redis_access.fetch_all.size }.from(0).to(1)
    end

  end

  context 'delete' do

    it 'responds with status deleted' do
      delete "/api/v1/#{controller}/#{DEFAULT_UUID}"
      expect(last_response.status).to eq 204
    end

    it 'removes specified data' do
      redis_access.add(data)
      expect { delete "/api/v1/#{controller}/#{DEFAULT_UUID}" }.to change { redis_access.fetch_all.size }.from(1).to(0)
    end

  end

end
