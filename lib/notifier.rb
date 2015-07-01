require 'grocer'

class Notifier

  def self.pusher
    Grocer.pusher(certificate: cert_file, gateway:  'gateway.sandbox.push.apple.com',  port: 2195,  retries:  1, passphrase: 'Channelx0628')
  end

  def self.send_notification(token, message)
    notification = Grocer::Notification.new(device_token: token,  alert: message,  badge: 1, sound: 'default')
    pusher.push(notification)
  end

  def self.cert_file
    File.join(File.dirname(__FILE__), '..', 'certs', 'apple_push_notification.pem')
  end

end
