class QuestionMailer < ActionMailer::Base
  
  SUBJECT = "Question from prospective customer on OC Homepros"
  
  def question_email(question)
    @question = question
    mail(from: @question.sender_email, to: @question.listing.contact_email, subject: SUBJECT)
  end
end
