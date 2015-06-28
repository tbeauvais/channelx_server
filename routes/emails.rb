class App < Sinatra::Base

  namespace '/api/v1' do

    post '/emails' do
      content_type :json
      status 201
      File.open('email.json', 'w') {|f| f.write(request.body.read) }
      json success: 'Created'
    end

  end

end
