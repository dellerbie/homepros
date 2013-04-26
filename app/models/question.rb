class Question < ActiveRecord::Base
  belongs_to :listing
  
  validates_presence_of :sender_email
  validates_presence_of :text
  validates_presence_of :listing_id
  
  validates_length_of :sender_email, maximum: 255
  validates_length_of :text, maximum: 1000
  
  validates_format_of :sender_email, :with => EmailAddress::VALID_PATTERN, :message => "Please enter a valid email address", :allow_blank => true
  
  attr_accessible :sender_email, :text
  
  # after_commit :question_email, on: :create
  
  def question_email
    QuestionMailer.question_email(self).deliver
  end
end