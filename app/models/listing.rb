class Listing < ActiveRecord::Base
  include EmailAddress
  extend FriendlyId
  
  friendly_id :company_name_and_location, use: [:slugged]
  
  belongs_to :user
  has_and_belongs_to_many :specialties
  has_many :questions
  belongs_to :city
  
  default_scope :include => [:city, :specialties]
  
  MAX_SPECIALTIES = 2
  
  ALL_CITIES_FILTER_KEY = 'all-cities'
  ALL_SPECIALTIES_FILTER_KEY = 'all-specialties'
  
  NO_CONTACT_EMAIL = 'no-reply@ochomepros.com'
  NO_WEBSITE = 'http://ochomepros.com'
  NO_PHONE = '5555555555'
  
  attr_accessible :specialty_ids, :city_id, :company_logo_photo, :company_logo_photo_cache, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_cache, :portfolio_photo_description, :website, :phone, :company_description
    
  mount_uploader :portfolio_photo, PortfolioPhotoUploader
  mount_uploader :company_logo_photo, CompanyLogoUploader
  
  validates :portfolio_photo, :file_size => { :maximum => 10.megabytes }
  validates :company_logo_photo, :file_size => { :maximum => 10.megabytes }
  
  validates_presence_of :portfolio_photo, message: 'Please upload a sample photo of your work'
  validates_presence_of :portfolio_photo_description
  validates_presence_of :company_name
  validates_presence_of :city, message: 'Please select a city closest to your business'
  validates_presence_of :contact_email
  validates_presence_of :specialties, message: 'Please select at least one specialty'
  
  validates_presence_of :phone
  validates_numericality_of :phone, integer_only: true, message: 'is not a number'
  validates_length_of :phone, is: 10, message: 'must be 10 numbers'
  
  validates_length_of :portfolio_photo_description, maximum: 255
  validates_length_of :company_name, maximum: 255
  validates_length_of :company_description, maximum: 1000
  
  validates_length_of :contact_email, maximum: 255
  validates_format_of :contact_email, :with => EmailAddress::VALID_PATTERN, :message => "Please enter a valid email address", :allow_blank => true
  
  validates_length_of :website, maximum: 255
  validates_format_of :website, :with => URI::regexp(%w(http https)), :allow_blank => true
  
  validate :ensure_max_specialties
  
  before_create :default_state
  
  before_validation :add_default_website_protocol
  
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

  protected
  
  def ensure_max_specialties
    if self.specialties.length > MAX_SPECIALTIES
      errors.add(:specialties, "You cannot have more than #{MAX_SPECIALTIES} specialties")
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
