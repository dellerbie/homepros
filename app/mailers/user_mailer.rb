class UserMailer < ActionMailer::Base
  default from: ENV['MAILER_EMAIL'], bcc: ENV['MAILER_EMAIL']
  
  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: '[OC HomeMasters] Welcome!')
  end
  
  def downgrade_email(user)
    @user = user
    mail(to: user.email, subject: '[OC HomeMasters] Your Listing Has Been Downgraded')
  end
  
  def welcome_to_premium_email(user)
    @user = user
    mail(to: user.email, subject: '[OC HomeMasters] Welcome to Premium Listings!')
  end
  
  def payment_receipt_email(user)
    @user = user
    mail(to: user.email, subject: '[OC HomeMasters] Payment Receipt')
  end
  
  def payment_failed_email(user)
    @user = user
    mail(to: user.email, subject: '[OC HomeMasters] Declined Payment')
  end
end
