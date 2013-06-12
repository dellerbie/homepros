ActiveAdmin.register User do
  config.sort_order = 'premium'
  
  menu priority: 1
  
  filter :email
  filter :premium
  filter :pending_downgrade
  filter :created_at
  filter :updated_at
  filter :customer_id, label: 'Stripe Customer ID'
  
  member_action :become, :method => :post do
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url
  end
  
  action_item :only => :show do
    links = ''.html_safe
    links += link_to 'Edit Listing', edit_admin_listing_path(user.listing)
    links += link_to 'Login as user', become_admin_user_path(user), method: :post, :target => '_blank'
  end
  
  index do 
    column :email
    column :created_at
    column :updated_at
    column 'Last Sign In', :last_sign_in_at
    column :customer_id
    column :premium
    column :pending_downgrade
    column '# Sign ins', :sign_in_count
    column 'Actions' do |user|
      links = ''.html_safe
      links += link_to 'View', resource_path(user), :class => "member_link show_link"
      links += link_to 'Login', become_admin_user_path(user), method: :post, :class => 'member_link become_link', :target => '_blank'
      links += link_to 'Edit', edit_resource_path(user), :class => "member_link edit_link"
      links += link_to 'Delete', resource_path(user), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
    end
  end
  
  show do
    panel 'Details' do
      attributes_table_for user do
        row :id
        row :email
        row 'Stripe Customer ID' do 
          user.customer_id
        end
        row :premium
        row :pending_downgrade
        row 'Last Sign In' do 
          user.last_sign_in_at
        end
        row :created_at
        row :updated_at
      end
    end
    
    panel 'Listing' do 
      attributes_table_for user.listing do
        row :id
        row :claimable
        row :company_name
        row :slug
        row :contact_email
        row :company_description
        row :website
        row :phone
        row :created_at
        row :updated_at
        row 'City' do |listing|
          listing.city.name
        end
        row :company_logo_photo
        table_for user.listing.portfolio_photos do 
          column :portfolio_photo
        end
      end
    end
  end
  
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password, :as => :string
      f.input :password_confirmation, :as => :string
    end
    f.actions
  end
end
