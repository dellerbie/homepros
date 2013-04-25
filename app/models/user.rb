class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :listing, :dependent => :destroy
  accepts_nested_attributes_for :listing
  
  default_scope :include => [:listing => [:city, :specialties]]
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :listing_attributes
  
  after_commit :welcome_email, on: :create
  
  def after_initialize
    self.build_listing if self.listing.nil?
  end
  
  def welcome_email
    UserMailer.welcome_email(self).deliver
  end
end
