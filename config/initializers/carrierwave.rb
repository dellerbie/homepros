if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV["S3_ACCESS_KEY"],
      :aws_secret_access_key  => ENV["S3_SECRET_ACCESS_KEY"]
    }
    # config.asset_host = "http://#{ENV['ASSET_HOST']}"
    config.fog_directory  = ENV["S3_BUCKET"]
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end