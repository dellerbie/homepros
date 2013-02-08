class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :listing, :dependent => :destroy
  accepts_nested_attributes_for :listing
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :listing_attributes
  
  def after_initialize
    self.build_listing if self.listing.nil?
  end
end
