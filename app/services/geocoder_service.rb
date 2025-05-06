class GeocoderService
  def self.call(address)
    return { error: "Address can't be blank" } if address.blank?

    results = Geocoder.search(address)
    location = results.first

    if location.present?
      {
        lat: location.latitude,
        lon: location.longitude,
        zip_code: location.postal_code
      }
    else
      { error: "Address not found" }
    end
  rescue => e
    { error: "Geocoding failed: #{e.message}" }
  end
end
