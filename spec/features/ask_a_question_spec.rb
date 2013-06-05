require 'spec_helper'

feature 'Ask a question', js: true do
  
  def cancel_modal
    within('#contact-modal') do 
      click_on 'Cancel'
    end
  end
  
  def should_see_question_modal
    find('#contact-modal')["aria-hidden"].should eql('false')
  end
  
  def should_not_see_question_modal
    find('#contact-modal')["aria-hidden"].should eql('true')
  end
  
  before(:each) do
    @listing = FactoryGirl.create(:free_listing)
    visit listing_path(@listing)
    find('.action.ask-question').click
    find('#contact-modal')["aria-hidden"].should eql('false')
  end
  
  scenario 'successful' do
    fill_in 'question_sender_email', with: 'mytestemail@gmail.com'
    fill_in 'question_text', with: 'yadad yadad yadad'
    within('#contact-modal') do 
      click_on 'Send'
      find('.modal-body .success').should have_content('Your message was sent.')
    end
  end
  
  scenario 'failure' do
    within('#contact-modal') do 
      click_on 'Send'
      page.should have_css('.question_sender_email.error')
      page.should have_css('.question_text.error')
    end
  end
  
  scenario 'cancel' do
    fill_in 'question_sender_email', with: 'mytestemail@gmail.com'
    fill_in 'question_text', with: 'yadad yadad yadad'
    
    cancel_modal
    
    find('#contact-modal')["aria-hidden"].should eql('true')
    find('.action.ask-question').click
    find('#question_sender_email').should have_content('')
    find('#question_text').should have_content('')
  end
  
  scenario 'show modal' do
    cancel_modal
    
    within('.contact-us') do
      click_on 'Email'
    end
    should_see_question_modal
    cancel_modal
    
    within('.contact-container') do
      click_on "Email #{@listing.company_name}"
    end
    should_see_question_modal
  end
  
end