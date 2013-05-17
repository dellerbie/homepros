namespace :move_photos do
  desc "moves the photos from the listings table to the portfolio_photos table"
  task :move => :environment do
    Listing.where('portfolio_photo IS NOT NULL').find_in_batches do |group|
      group.each do |listing| 
        photo = PortfolioPhoto.new(description: listing.portfolio_photo_description)
        photo[:portfolio_photo] = listing.attributes['portfolio_photo']
        photo.portfolio_photo_token = listing.portfolio_photo_token
        photo.listing = listing
        photo.save!
      end
    end
  end
end