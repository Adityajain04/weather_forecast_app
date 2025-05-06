class WeatherService
  # Include HTTParty for making HTTP requests
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  # Public method to fetch current weather data based on latitude and longitude
  def self.fetch(lat, lon)
    api_key = ENV['OPENWEATHER_API_KEY']
    raise "Missing OpenWeather API key" if api_key.blank?

    # Make the API request to OpenWeather
    response = get('/weather', query: {
      lat: lat,
      lon: lon,
      units: 'metric',
      appid: api_key
    })

    # Handle unsuccessful HTTP responses
    unless response.success?
      log_error("API response failure", response)
      return nil
    end

    # Parse and return the essential weather data
    {
      temperature: response.dig("main", "temp"),
      high:        response.dig("main", "temp_max"),
      low:         response.dig("main", "temp_min"),
      description: response.dig("weather", 0, "description")&.capitalize
    }

  rescue => e
    # Rescue any network/parsing errors and return a meaningful message
    log_error("WeatherService Exception", e.message)
    { error: "Weather Forecast failed: #{e.message}" }
  end

  private

  # Simple logger for debugging API failures
  def self.log_error(context, details)
    Rails.logger.error "[WeatherService] #{context} - #{details}"
  end
end
