CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :aws
    config.aws_bucket = ENV.fetch('BUCKET_DIRECTORY')
    config.aws_credentials = {
      access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),               # required
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')           # required
    }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end