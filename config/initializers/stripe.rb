Stripe.api_key = ENV["STRIPE_API_KEY"]
STRIPE_PUBLIC_KEY = ENV["STRIPE_PUBLIC_KEY"]

StripeEvent.setup do
  subscribe 'customer.subscription.deleted' do |event|
    user = User.find_by_customer_id(event.data.object.customer)
    user.update_attributes(premium: false, pending_downgrade: false, without_protection: true)
    UserMailer.downgrade_email(user).deliver
  end
  
  subscribe 'customer.subscription.created' do |event|
    user = User.find_by_customer_id(event.data.object.customer)
    UserMailer.welcome_to_premium_email(user).deliver
  end
end