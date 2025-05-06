class GeocoderService
  # Entry point to perform geocoding for a given address string
  def self.call(address)
    return { error: "Address can't be blank" } if address.blank?

    # Perform geocoding lookup using Geocoder gem
    results = Geocoder.search(address)
    location = results.first

    if location.present?
      {
        lat:      location.latitude,
        lon:      location.longitude,
        zip_code: location.postal_code
      }
    else
      { error: "Address not found" }
    end

  rescue => e
    log_error("Geocoding exception", e.message)
    { error: "Geocoding failed: #{e.message}" }
  end

  private

  # Optional: log errors for debugging in production
  def self.log_error(context, message)
    Rails.logger.error "[GeocoderService] #{context} - #{message}"
  end
end
