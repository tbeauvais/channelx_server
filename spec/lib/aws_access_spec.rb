require 'spec_helper'

describe 'aws access' do

  context '#upload' do

    it 'uploads html' do
      obj = AwsAccess.upload('<html>Hello World</html>')
      expect(obj.public_url).to start_with "https://innojam-channel-x.s3.amazonaws.com/"
      obj.delete
    end

  end

end