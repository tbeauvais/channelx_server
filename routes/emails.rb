require 'notifier'

class App < Sinatra::Base

  namespace '/api/v1' do

    post '/emails' do
      begin
        content_type :json
        status 201
        email = parse_email(request)
        subject = email['headers']['Subject']

        obj = AwsAccess.upload(email['html'])
        
        # temporary message
        message = {
          name: 'SUNNY\'S',
          lastText: subject,
          logo: 'https://static.ctctcdn.com/galileo/images/templates/Galileo-Template-Images/FeedbackRequest/FeedbackRequest_VerticalLogo.png',
          link: obj.public_url
        }

        message_access.add(message)

        Notifier.send_notification('6533903318951d6fe40616f238ad325219f824638535272ea4b8b626d86eae4b', subject)

        #File.open('email.json', 'w') {|f| f.write(request.body.read) }
        json success: 'Created', url: obj.public_url
      rescue => e
        # Rspec doesn't report meaningful errors with Sinatra without this.
        puts e.backtrace
        raise e
      end
    end

  end

  def parse_email(request)
    JSON.parse(request.body.read)
  end



end
