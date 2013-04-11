S3_CONFIG = YAML.load_file(Rails.root.join('config', 's3.yml'))[Rails.env]

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => S3_CONFIG['access_key_id'],
      :aws_secret_access_key  => S3_CONFIG['secret_access_key']
    }
    config.fog_directory  = S3_CONFIG['bucket']   
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end