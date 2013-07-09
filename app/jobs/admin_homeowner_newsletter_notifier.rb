require 'resque/errors'

module AdminHomeownerNewsletterNotifier
  extend RetryJob
  
  @queue = :homeowner_notifications
  
  def self.perform(homeowner_id)
    homeowner = Homeowner.find(homeowner_id)
    HomeownerMailer.admin_new_homeowner_email(homeowner).deliver
    
    rescue Resque::TermException
      Resque.enqueue(self, homeowner_id)
  end
end