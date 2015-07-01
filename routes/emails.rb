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
          name: 'TJ\'S',
          lastText: subject,
          logo: "https://static.ctctcdn.com/galileo/images/templates/Galileo-Template-Images/VerticalLogos/VerticalLogo_Restaurant.png",
          link: obj.public_url
        }

        message_access.add(message)

        device_access.fetch_all.each do |device|
          Notifier.send_notification(device['token'], subject)
        end

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
