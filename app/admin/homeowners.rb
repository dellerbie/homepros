ActiveAdmin.register Homeowner do
  menu priority: 6
  
  filter :id
  filter :city, collection: proc { Hash[City.all.map{|c| [c.name, c.id]}] }
  filter :email
  filter :received_flier
  filter :created_at
  
  index do 
    column :id
    column :email
    column :received_flier
    column 'City' do |homeowner|
      homeowner.city.name
    end
    column :created_at
  end
end
