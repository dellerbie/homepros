class UserMailer < ActionMailer::Base
  default from: "no-reply@homepros.com"
  
  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to OC Homepros')
  end
end
