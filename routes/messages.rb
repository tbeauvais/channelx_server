class App < Sinatra::Base

  namespace '/api/v1' do

    get '/messages' do
      json [{name: 'test', link: 'www.test.com'}]
    end

    get '/messages/:id' do
      json ({name: 'test', link: 'www.test.com'})
    end

  end

end
