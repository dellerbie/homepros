User.where(email: 'slowblues@gmail.com').destroy_all

user = User.create!(email: 'slowblues@gmail.com', password: '111111', password_confirmation: '111111')

user.build_listing({
  company_name: 'Dellerbie Inc.', 
  contact_email: 'slowblues@gmail.com', 
  website: 'dellerbie.com', 
  phone: '7146127367', 
  portfolio_photo_description: Faker::Lorem.characters,
  portfolio_photo: File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'gibson.jpg')),
  company_logo_photo: File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'fender.jpg')),
  company_description: Faker::Lorem.paragraph(2)
})

user.listing.city = City.where(name: 'Orange').first
user.listing.specialties << Specialty.where(name: 'General Contractors').first
user.save!