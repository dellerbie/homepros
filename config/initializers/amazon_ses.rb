ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => ENV["S3_ACCESS_KEY"],
  :secret_access_key => ENV["S3_SECRET_ACCESS_KEY"]