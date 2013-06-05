module Features
  module ListingHelpers
    def should_update_listing(listing, specialty, city)
      company_name = 'My New Business Name'
      email = Faker::Internet.email
      website = Faker::Internet.domain_name
      phone = '949-384-9281'

      fill_in 'listing_company_name', with: company_name
      fill_in 'listing_company_description', with: Faker::Lorem.characters(500)
      select_from_chosen(specialty.name, from: 'What do you specialize in?')
      select_from_chosen(city.name, from: 'Which city or metro area is closest to your company headquarters?')
      fill_in 'listing_contact_email', with: email
      fill_in 'listing_website', with: website
      fill_in 'listing_phone', with: phone

      within('.preview .listing-container') do
        find('.company-name').should have_content(company_name)
        find('.specialties').should have_content(specialty.name)
        find('.location').should have_content(city.name)
        find('.description').should have_content(listing.portfolio_photos.first.description)
      end

      click_on 'Save'

      page.should have_content('Your listing was successfully updated.')

      listing.reload
      current_path.should eql(listing_path(listing))
      page.should have_content(listing.company_name)
      page.should have_content("Specialties: #{listing.specialties.map(&:name).join(', ')}")
      page.should have_content("Headquarted in: #{listing.city.name}, CA")
      page.should have_content("Phone Number: #{number_to_phone(listing.phone, area_code: true)}")
      page.should have_content("#{listing.company_description}")
      page.should have_content("#{listing.website}")

      within('.portfolio-image') do
        find('p').should have_content(listing.portfolio_photos.first.description)
      end
    end
    
    def should_fail_to_update
      click_on 'My Listing'
      click_on 'Edit'

      fill_in 'listing_company_name', with: ''

      within('#listing_specialty_ids_chzn') do
        find('.search-choice-close').click
      end

      fill_in 'listing_contact_email', with: ''
      fill_in 'listing_phone', with: ''

      click_on 'Save'

      page.should have_content('Please review the problems below:')
      page.should have_css('.listing_contact_email.error')
      page.should have_css('.listing_phone.error')
      page.should have_css('.listing_company_name.error')
      page.should have_css('.listing_specialties.error')
    end
  end
end