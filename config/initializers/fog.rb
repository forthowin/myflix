CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     'asdfasdf',               # required
      aws_secret_access_key: 'asdfsdf',           # required
    }
    config.fog_directory  = 'sampleapppic'                      # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end