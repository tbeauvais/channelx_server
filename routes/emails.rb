require 'notifier'

class App < Sinatra::Base

  namespace '/api/v1' do

    get '/emails2' do
      json success: 'Yo!'
    end

    post '/emails' do
      content_type :json
      status 201
      email = parse_email(request)
      subject = email['headers']['Subject']

      # temporary message
      message = {
        name: 'SUNNY\'S',
        lastText: subject,
        logo: 'https://static.ctctcdn.com/galileo/images/templates/Galileo-Template-Images/FeedbackRequest/FeedbackRequest_VerticalLogo.png',
        link: 'https://s3.amazonaws.com/channelx/florist.html'
      }

      message_access.add(message)

      Notifier.send_notification('6533903318951d6fe40616f238ad325219f824638535272ea4b8b626d86eae4b', subject)

      File.open('email.json', 'w') {|f| f.write(request.body.read) }
      obj = AwsAccess.upload(email.html)
      puts obj.public_url
      json success: 'Created'
    end

  end

  def parse_email(request)
    JSON.parse(request.body.read)
  end



end
