ActiveAdmin.register Question do
  menu priority: 5
  
  filter :listing_id, as: :numeric
  filter :id
  filter :sender_email
  filter :text
  filter :created_at
  
  index do 
    column :id
    column :sender_email
    column :text
    column :created_at
    column 'Listing ID' do |question|
      question.listing.id
    end
    column 'Actions' do |question|
      links = ''.html_safe
      links += link_to 'View', resource_path(question), :class => "member_link show_link"
      links += link_to 'Edit', edit_resource_path(question), :class => "member_link edit_link"
      links += link_to 'Delete', resource_path(question), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
    end
  end
end
