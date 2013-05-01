class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :listing, :dependent => :destroy
  accepts_nested_attributes_for :listing
  
  default_scope :include => [:listing => [:city, :specialties]]
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :listing_attributes, :stripe_token
  attr_accessor :stripe_token
  
  after_commit :welcome_email, on: :create
  
  STRIPE_ERROR_BLANK_TOKEN = "Can't upgrade to premium at this time.  Please try again later."
  STRIPE_ERROR_ALREADY_PREMIUM_USER = "You are already a premium user."
  PREMIUM_PLAN = 'premium'
  
  def after_initialize
    self.build_listing if self.listing.nil?
  end
  
  def welcome_email
    UserMailer.welcome_email(self).deliver
  end
  
  def upgrade
    raise STRIPE_ERROR_BLANK_TOKEN if stripe_token.blank?
    
    if customer_id.present?
      customer = Stripe::Customer.retrieve(customer_id)
      customer.update_subscription(plan: PREMIUM_PLAN)
    else 
      customer = Stripe::Customer.create(
        email: email,
        description: "Customer for #{email}", 
        card: stripe_token,
        plan: PREMIUM_PLAN
      )
    end
    
    self.last_4_digits = customer.active_card.last4
    self.customer_id = customer.id
    self.card_type = customer.active_card.type
    self.exp_month = customer.active_card.exp_month
    self.exp_year = customer.active_card.exp_year
    self.stripe_token = nil
    self.premium = true
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: #{e.message}"
    self.stripe_token = nil
    errors.add :base, "Unable to upgrade to premium #{e.message}."
    false
  end
  
  def update_card
    unless customer_id.blank? || stripe_token.blank?
      customer = Stripe::Customer.retrieve(customer_id)
      customer.card = stripe_token
      customer.email = email
      customer.description = "Customer for #{email}"
      customer.save
      self.last_4_digits = customer.active_card.last4
      self.customer_id = customer.id
      self.card_type = customer.active_card.type
      self.exp_month = customer.active_card.exp_month
      self.exp_year = customer.active_card.exp_year
      self.stripe_token = nil
      self.premium = true
    end
    true
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: #{e.message}"
    errors.add :base, "Unable to update your credit card #{e.message}."
    false
  end
  
  def downgrade
    unless customer_id.blank?
      customer = Stripe::Customer.retrieve(customer_id)
      unless customer.blank? || customer.respond_to?('deleted')
        if customer.subscription.status == 'active'
          customer.cancel_subscription
          true
        end
      end
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: #{e.message}"
    errors.add :base, "Unable to cancel your subscription #{e.message}."
    false
  end
end
