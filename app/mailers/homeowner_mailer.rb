class HomeownerMailer < ActionMailer::Base
  default from: ENV['MAILER_EMAIL']
  
  def admin_new_homeowner_email(homeowner)
    @homeowner = homeowner
    mail(to: Figaro.env.admin_email, subject: 'New Homeowner Signed Up')
  end
end
