class Listing < ActiveRecord::Base
  include EmailAddress
  extend FriendlyId
  
  MAX_SPECIALTIES = 2
  MAX_PREMIUM_PHOTOS = 6
  MAX_FREE_PHOTOS = 1
  ALL_CITIES_FILTER_KEY = 'all-cities'
  ALL_SPECIALTIES_FILTER_KEY = 'all-specialties'
  NO_CONTACT_EMAIL = 'no-reply@ochomepros.com'
  NO_WEBSITE = 'http://ochomepros.com'
  NO_PHONE = '5555555555'
  PREMIUM_COST_STRING = "$99.00"
  
  friendly_id :company_name_and_location, use: [:slugged]
  
  belongs_to :user
  has_and_belongs_to_many :specialties
  has_many :questions
  has_many :portfolio_photos, dependent: :destroy
  belongs_to :city
  
  accepts_nested_attributes_for :portfolio_photos, limit: MAX_PREMIUM_PHOTOS#, reject_if: :all_blank, allow_destroy: true
  
  default_scope :include => [:city, :specialties]
  
  attr_accessible :specialty_ids, :city_id, :company_logo_photo, :company_logo_photo_cache, :company_name, 
    :contact_email, :website, :phone, :company_description, :portfolio_photos_attributes
    
  mount_uploader :company_logo_photo, CompanyLogoUploader
  
  validates :company_logo_photo, :file_size => { :maximum => 10.megabytes }
  
  validates_presence_of :company_name
  validates_presence_of :city, message: 'Please select a city closest to your business'
  validates_presence_of :contact_email
  validates_presence_of :specialties, message: 'Please select at least one specialty'
  validates_presence_of :portfolio_photos, message: 'Please upload at least one portfolio photo'
  
  validates_presence_of :phone
  validates_numericality_of :phone, integer_only: true, message: 'is not a number'
  validates_length_of :phone, is: 10, message: 'must be 10 numbers'
  
  validates_length_of :company_name, maximum: 255
  validates_length_of :company_description, maximum: 1000
  
  validates_length_of :contact_email, maximum: 255
  validates_format_of :contact_email, :with => EmailAddress::VALID_PATTERN, :message => "Please enter a valid email address", :allow_blank => true
  
  validates_length_of :website, maximum: 255
  validates_format_of :website, :with => URI::regexp(%w(http https)), :allow_blank => true
  
  validate :ensure_max_specialties
  
  before_create :default_state
  
  before_validation :add_default_website_protocol
  
  before_save :ensure_max_portfolio_photos
  
  def company_name_and_location
    "#{company_name} #{city.try(:name)}"
  end
  
  def website?
    website.present? && website != NO_WEBSITE
  end
  
  def email?
    contact_email.present? && contact_email != NO_CONTACT_EMAIL
  end
  
  def phone?
    phone.present? && phone != NO_PHONE
  end
  
  def premium=(premium)
    @premium = premium
  end
  
  def premium?
    @premium || user.try(:premium?)
  end
  
  def can_add_photos?
    n_photos = self.portfolio_photos.count
    max_photos = premium? ? MAX_PREMIUM_PHOTOS : MAX_FREE_PHOTOS
    n_photos < max_photos
  end
  
  def build_portfolio_photos
    n_photos = portfolio_photos.length
    (Listing::MAX_PREMIUM_PHOTOS - n_photos).times { portfolio_photos.build } if premium?
  end

  protected
  
  def ensure_max_specialties
    if self.specialties.length > MAX_SPECIALTIES
      errors.add(:specialties, "You cannot have more than #{MAX_SPECIALTIES} specialties")
    end
  end
  
  def ensure_max_portfolio_photos
    n_photos = self.portfolio_photos.length
    
    if premium? && n_photos > MAX_PREMIUM_PHOTOS
      photos = self.portfolio_photos.take(MAX_PREMIUM_PHOTOS)
      self.portfolio_photos = photos
    elsif !premium? && n_photos > MAX_FREE_PHOTOS
      photo = self.portfolio_photos.first
      self.portfolio_photos = [photo]
    end
  end
  
  def default_state
    self.state = 'CA'
  end
  
  def add_default_website_protocol
    if phone.present?
      self.phone = phone.gsub(/[^\d]/, '')
    end
    
    if website.present? && !website.start_with?('http://', 'https://')
      self.website = "http://#{website}"
    end
  end
end
