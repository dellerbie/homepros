ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do


    panel 'Stats' do 
      div do 
        "#{User.count(conditions: {premium: true})} Premium Users"
      end
    
      div do 
        "#{User.count} Total Users"
      end
    
      div do 
        "#{Listing.count} Total Listings"
      end
      
      div do 
        "#{Listing.count(conditions: {claimable: true})} Claimable Listings"
      end
    
      div do 
        "#{Question.count} Total Questions"
      end
    end

  end
end
