Stripe.api_key = ENV["STRIPE_API_KEY"]
STRIPE_PUBLIC_KEY = ENV["STRIPE_PUBLIC_KEY"]

StripeEvent.setup do
  subscribe 'customer.subscription.deleted' do |event|
    StripeWebhooks.subscription_canceled(event.data.object.customer)
  end
  
  subscribe 'customer.subscription.created' do |event|
    StripeWebhooks.subscription_created(event.data.object.customer)
  end
end