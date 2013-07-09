require 'resque/errors'

module AdminNewUserNotifier
  extend RetryJob
  
  @queue = :user_notifications
  
  def self.perform(user_id)
    user = User.find(user_id)
    UserMailer.admin_new_user_email(user).deliver
    
    rescue Resque::TermException
      Resque.enqueue(self, user_id)
  end
end