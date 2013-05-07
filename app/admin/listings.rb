ActiveAdmin.register Listing do
  menu priority: 2
  
  filter :city
  filter :user, collection: proc { User.all.map(&:email) }
  filter :id
  filter :company_name
  filter :slug
  filter :contact_email
  filter :created_at
  filter :claimable
  
  index do 
    column :id
    column :claimable
    column :company_name
    column :slug
    column :contact_email
    column :phone
    column :created_at
    column :updated_at
    column 'City' do |listing|
      listing.city.name
    end
    column 'Actions' do |listing|
      links = ''.html_safe
      links += link_to 'View', resource_path(listing), :class => "member_link show_link"
      links += link_to 'Edit', edit_resource_path(listing), :class => "member_link edit_link"
      links += link_to 'Delete', resource_path(listing), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
    end
  end
  
  show do
    panel 'Details' do
      attributes_table_for listing do
        row :id
        row 'Url' do
          listing_url(listing)
        end
        row :claimable
        row :company_name
        row :slug
        row :specialties
        row :contact_email
        row :website
        row :phone
        row 'City' do 
          listing.city.name
        end
        row :company_description
        row :portfolio_photo
        row :portfolio_photo_description
        row :company_logo_photo
        row :created_at
        row :updated_at
      end
    end
    
    if listing.user.present?
      panel 'User' do 
        attributes_table_for listing.user do
          row :id
          row :email
          row 'Stripe Customer ID' do 
            listing.user.customer_id
          end
          row :premium
          row :pending_downgrade
          row :created_at
          row :updated_at
        end
      end
    end
    
    if listing.questions.present? 
      panel 'Questions' do
        table_for listing.questions.sort{|a, b| a.created_at <=> b.created_at} do
          column :id
          column :sender_email
          column :text
          column :created_at
        end
      end
    end
  end
  
  form do |f|
    f.inputs "Listing Details" do
      # city
      # user
      f.input :company_name
      f.input :contact_email
      f.input :website
      f.input :phone
      f.input :company_description
      # f.input :portfolio_photo
      f.input :portfolio_photo_description
      # f.input :company_logo_photo
    end
    f.actions
  end
end
