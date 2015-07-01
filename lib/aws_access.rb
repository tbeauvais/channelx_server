require 'aws-sdk'
require 'uuid'

class AwsAccess

  def self.upload(html)
    assert_env!
    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    filename = "#{UUID.generate}.html"
    bucket = s3.bucket(bucket_name)
    object = bucket.object(filename)
    object.put({body: html})
    object
  end

private
  def self.assert_env!
    raise "Export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY." +
      " See http://docs.aws.amazon.com/AWSSdkDocsRuby/latest/DeveloperGuide/set-up-creds.html" unless ENV["AWS_ACCESS_KEY_ID"] && ENV["AWS_SECRET_ACCESS_KEY"]
  end

  def self.bucket_name
    "innojam-channel-x"
  end
end
