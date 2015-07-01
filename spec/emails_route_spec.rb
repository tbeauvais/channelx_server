require 'spec_helper'

describe 'App' do

  context 'emails' do

    context 'post' do

      before(:each) {
        expect(Notifier).to receive(:send_notification)
      }

      let(:email) { {headers: {Subject: 'this is a test'}, html: '<html><body>test</body></html>'} }

      it 'responds with 201' do
        post '/api/v1/emails', email.to_json
        expect(last_response.status).to eq 201
      end

      it 'adds new email' do
        post '/api/v1/emails', email.to_json
        expect(last_response.body).to eq ({'success' => 'Created'}.to_json)
      end

      xit 'stores email html to s3' do
        post '/api/v1/emails', email.to_json
        expect(last_response.body).to eq ({'success' => 'Created'}.to_json)
      end

      xit 'adds new message' do
        post '/api/v1/emails', email.to_json
        expect(last_response.body).to eq ({'success' => 'Created'}.to_json)
      end

    end

  end

end
