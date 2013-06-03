module ListingsHelper
  def specialties(listing)
    listing.specialties.map { |s| s.name }.join(', ')
  end
  
  def can_email?(listing)
    (listing.email? && !current_user) || (current_user && current_user != listing.user)
  end
  
  def slideshow?(listing)
    listing.premium? && listing.portfolio_photos.count > 1
  end
  
  def tmp_photo?(listing)
    if listing.try(:portfolio_photos).try(:first)
      listing.portfolio_photos.first.portfolio_photo_url.match(/\/uploads\/tmp/)
    else
      false
    end
  end
end
