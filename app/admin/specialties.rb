ActiveAdmin.register Specialty do
  menu priority: 4
  
  index do 
    column :id
    column :name
    column :slug
    column 'Actions' do |specialty|
      links = ''.html_safe
      links += link_to 'View', resource_path(specialty), :class => "member_link show_link"
      links += link_to 'Edit', edit_resource_path(specialty), :class => "member_link edit_link"
      links += link_to 'Delete', resource_path(specialty), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
    end
  end
  
  form do |f|
    f.inputs "Specialty Details" do
      f.input :name
    end
    f.actions
  end
end
