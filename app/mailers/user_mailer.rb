class UserMailer < ActionMailer::Base
  default from: ENV['MAILER_EMAIL'], bcc: ENV['MAILER_EMAIL']
  
  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to OC HomeMasters!')
  end
  
  def downgrade_email(user)
    @user = user
    mail(to: user.email, subject: 'OC HomeMasters, Your Listing Will Be Downgraded')
  end
  
  def welcome_to_premium_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to OC HomeMasters Premium Listings!')
  end
end
