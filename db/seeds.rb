User.where(email: 'slowblues@gmail.com').destroy_all

user = User.create!(email: 'slowblues@gmail.com', password: 'ffffff', password_confirmation: 'ffffff')

user.build_listing({
  company_name: 'Dellerbie Inc.', 
  contact_email: 'slowblues@gmail.com', 
  website: 'dellerbie.com', 
  phone: '7146127367', 
  portfolio_photos_attributes: [{
    description: "Here is an example of some of our fine fine work. As you can see, we only do the finest work. For more information feel free to contact us via email or phone.  Whichever works best for you!",
    portfolio_photo: File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'gibson.jpg')),
  }],
  company_logo_photo: File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'fender.jpg')),
  company_description: "We've been doing business since 1979.  Ever since then we've had a long lasting record of excellence and professionalism.  Please check out some our portfolio photos to get a basic understanding of our craftsmenship."
})

user.listing.city = City.where(name: 'Orange').first
user.listing.specialties << Specialty.where(name: 'General Contractors').first
user.save!