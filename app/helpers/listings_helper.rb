module ListingsHelper
  def specialties(listing)
    listing.specialties.map { |s| s.name }.join(', ')
  end
  
  def can_email?(listing)
    (listing.email? && !current_user) || (current_user && current_user != listing.user)
  end
end
