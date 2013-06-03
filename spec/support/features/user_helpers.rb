module Features
  module UserHelpers
    def sign_up(user)
      visit '/users/sign_up'
      fill_in "Enter Your First & Last Name", :with => user.name
      fill_in "Enter Your Email", :with => user.email
      fill_in "Create a Password (6+ characters)", :with => user.password
      click_signup_button
    end

    def sign_in(user)
      visit new_user_session_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button "Sign in"
    end

    def sign_out
      visit '/users/sign_out'
    end
    
    def should_see_signed_in_navbar_for_mvp_user
      expect(page).to have_content('Upgrade to Premium')
      should_see_signed_in_navbar
    end
    
    def should_see_signed_in_navbar 
      expect(page).to have_content('My Listing')
      expect(page).to have_content('My Account')
      expect(page).to have_content('Logout')
    end

    def should_see_signed_out_navbar
      page.should have_content 'Login'
      page.should have_content 'Get Listed Today'
    end

    def should_see_successful_sign_in_message
      page.should have_content "Signed in successfully."
    end
  end
end