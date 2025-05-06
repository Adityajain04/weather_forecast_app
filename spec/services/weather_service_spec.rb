# spec/services/weather_service_spec.rb
require 'rails_helper'

RSpec.describe WeatherService do
  describe '.fetch' do
    let(:lat) { 12.9716 }
    let(:lon) { 77.5946 }

    before do
      stub_request(:get, /api.openweathermap.org/)
        .to_return(
          status: 200,
          body: {
            main: {
              temp: 25.0,
              temp_max: 28.0,
              temp_min: 22.0
            },
            weather: [
              { description: "clear sky" }
            ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'returns weather data' do
      result = WeatherService.fetch(12.34, 56.78)
      expect(result[:temperature]).to eq(25.0)
      expect(result[:high]).to eq(28.0)
      expect(result[:low]).to eq(22.0)
      expect(result[:description]).to eq("Clear sky")
    end
  end
end
