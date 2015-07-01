require 'spec_helper'

describe 'App' do

  context 'emails' do

    context 'post' do

      before(:each) {
        expect(Notifier).to receive(:send_notification)
        expect(AwsAccess).to receive(:upload).and_return(double('aws', public_url: 'www.test.com'))
        expect_any_instance_of(App).to receive(:device_access).and_return(double('access', fetch_all: ['12345']))
      }

      let(:email) { {headers: {Subject: 'this is a test'}, html: '<html><body>test</body></html>'} }

      it 'responds with 201' do
        post '/api/v1/emails', email.to_json
        expect(last_response.status).to eq 201
      end

      it 'adds new email' do
        post '/api/v1/emails', email.to_json
        expect(JSON.parse(last_response.body)).to include({'success' => 'Created'})
      end

      it 'adds message' do
        expect_any_instance_of(App).to receive_message_chain(:message_access, :add)
        post '/api/v1/emails', email.to_json
      end

      it 'stores email html to s3' do
        post '/api/v1/emails', email.to_json
        expect(JSON.parse(last_response.body)['url']).to eq 'www.test.com'
      end

    end

  end

end
