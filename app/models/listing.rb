class Listing < ActiveRecord::Base
  include EmailAddress
  
  belongs_to :user
  has_and_belongs_to_many :specialties
  belongs_to :city
  
  MAX_SPECIALTIES = 2
  BUDGETS = {
    1 => '$3,000 and under',
    2 => '$3,000-$10,000',
    3 => '$10,000-$25,000',
    4 => '$25,000-$50,000',
    5 => 'Over $50,000'
  }
  
  attr_accessible :budget_id, :specialty_ids, :city_id, :company_logo_photo, :company_logo_photo_cache, :company_name, :contact_email,
    :portfolio_photo, :portfolio_photo_cache, :portfolio_photo_description, :website, :phone_area_code, :phone_exchange, :phone_suffix
    
  mount_uploader :portfolio_photo, PortfolioPhotoUploader
  mount_uploader :company_logo_photo, CompanyLogoUploader
  
  validates :portfolio_photo, :file_size => { :maximum => 10.megabytes }
  validates :company_logo_photo, :file_size => { :maximum => 10.megabytes }
  
  validates_presence_of :portfolio_photo, message: 'Please upload a sample photo of your work'
  validates_presence_of :portfolio_photo_description
  validates_presence_of :company_name
  validates_presence_of :city
  validates_presence_of :contact_email
  validates_presence_of :specialties, message: 'Please select at least one specialty'
  
  validates_presence_of :budget_id, message: 'Please choose a typical budget'
  validates_inclusion_of :budget_id, :in => BUDGETS.keys
  
  validates_presence_of :phone_area_code
  validates_numericality_of :phone_area_code, integer_only: true, message: 'is not a number'
  validates_length_of :phone_area_code, is: 3, message: 'must be 3 numbers'
  
  validates_presence_of :phone_exchange
  validates_numericality_of :phone_exchange, integer_only: true, message: 'is not a number'
  validates_length_of :phone_exchange, is: 3, message: 'must be 3 numbers'
  
  validates_presence_of :phone_suffix
  validates_numericality_of :phone_suffix, integer_only: true, message: 'is not a number'
  validates_length_of :phone_suffix, is: 4, message: 'must be 4 numbers'
    
  validates_length_of :portfolio_photo_description, maximum: 255
  validates_length_of :company_name, maximum: 255
  
  validates_length_of :contact_email, maximum: 255
  validates_format_of :contact_email, :with => EmailAddress::VALID_PATTERN, :message => "Please enter a valid email address", :allow_blank => true
  
  validates_length_of :website, maximum: 255
  validates_format_of :website, :with => URI::regexp(%w(http https)), :allow_blank => true
  
  validate :ensure_max_specialties
  
  before_create :default_state
  
  protected
  
  def ensure_max_specialties
    if self.specialties.length > MAX_SPECIALTIES
      errors.add(:specialties, "You cannot have more than #{MAX_SPECIALTIES} specialties")
    end
  end
  
  def default_state
    self.state = 'CA'
  end
  
end
