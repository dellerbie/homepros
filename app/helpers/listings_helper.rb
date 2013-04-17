module ListingsHelper
  def specialties(listing)
    listing.specialties.map { |s| s.name }.join(', ')
  end
end
