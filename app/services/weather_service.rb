class WeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  def self.fetch(lat, lon)
    api_key = ENV['OPENWEATHER_API_KEY']
    response = get('/weather', query: {
      lat: lat,
      lon: lon,
      units: 'metric',
      appid: api_key
    })

    return nil unless response.success?

    {
      temperature: response["main"]["temp"],
      high: response["main"]["temp_max"],
      low: response["main"]["temp_min"],
      description: response["weather"][0]["description"].capitalize
    }
  end
end
