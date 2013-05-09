class QuestionMailer < ActionMailer::Base
  default from: ENV['MAILER_EMAIL']
  
  SUBJECT = "Question from prospective customer on OC Homepros"
  
  def question_email(question)
    @question = question
    mail(to: @question.listing.contact_email, subject: SUBJECT)
  end
end
