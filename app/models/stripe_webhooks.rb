class StripeWebhooks 
  class << self
    def subscription_deleted(customer_id)
      user = User.find_by_customer_id(customer_id)
      unless user.blank?
        user.update_attributes({premium: false, pending_downgrade: false}, without_protection: true)
        UserMailer.downgrade_email(user).deliver
      end
    end

    def subscription_created(customer_id)
      user = User.find_by_customer_id(customer_id)
      UserMailer.welcome_to_premium_email(user).deliver unless user.blank?
    end
    
    def payment_succeeded(customer_id)
      user = User.find_by_customer_id(customer_id)
      UserMailer.payment_receipt_email(user).deliver unless user.blank?
    end
    
    def payment_failed(customer_id)
      user = User.find_by_customer_id(customer_id)
      UserMailer.payment_failed_email(user).deliver unless user.blank?
    end
  end
end