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

    def should_be_signed_in(user)
      should_see_profile_menu
      page.should_not have_content "Sign up"
      page.should_not have_content "Sign in"
    end

    def should_be_signed_out
      page.should satisfy {|page| page.has_content?('Sign up') || page.has_content?('Sign in')}
      page.should_not have_content "Logout"
    end

    def should_see_successful_sign_in_message
      page.should have_content "Signed in successfully."
    end
  end
end