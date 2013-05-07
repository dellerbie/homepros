ActiveAdmin.register City do
  menu priority: 3
  
  index do 
    column :id
    column :name
    column :slug
    column :created_at
    column :updated_at
    column 'Actions' do |city|
      links = ''.html_safe
      links += link_to 'View', resource_path(city), :class => "member_link show_link"
      links += link_to 'Edit', edit_resource_path(city), :class => "member_link edit_link"
      links += link_to 'Delete', resource_path(city), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
    end
  end
  
  form do |f|
    f.inputs "City Details" do
      f.input :name
    end
    f.actions
  end
end
