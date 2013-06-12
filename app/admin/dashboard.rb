ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    panel 'Stats' do 
      div style: 'font-size: 16px; margin-bottom: 20px;' do 
        "Premium Users: #{User.count(conditions: {premium: true})}"
      end
    
      div style: 'font-size: 16px; margin-bottom: 20px;' do 
        "Total Users: #{User.count}"
      end
    
      div style: 'font-size: 16px; margin-bottom: 20px;' do 
        "Total Listings: #{Listing.count}"
      end
      
      div style: 'font-size: 16px; margin-bottom: 20px;' do 
        "Claimable Listings: #{Listing.count(conditions: {claimable: true})}"
      end
    
      div style: 'font-size: 16px; margin-bottom: 20px;' do 
        "Total Questions: #{Question.count}"
      end
      
      div style: 'font-size: 16px; margin-bottom: 20px;' do 
        "Total Homeowners Signed Up: #{Homeowner.count}"
      end
    end

  end
end
