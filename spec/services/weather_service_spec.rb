# spec/services/weather_service_spec.rb
require 'rails_helper'

RSpec.describe WeatherService do
  describe '.fetch' do
    let(:lat) { 12.34 }
    let(:lon) { 56.78 }

    context 'when API returns successful response' do
      it 'returns weather data' do
        # Create a double that mimics the HTTParty::Response
        response = double('HTTParty::Response', success?: true)

        # Stub dig to simulate response.dig(...) behavior
        allow(response).to receive(:dig).with("main", "temp").and_return(25.0)
        allow(response).to receive(:dig).with("main", "temp_max").and_return(30.0)
        allow(response).to receive(:dig).with("main", "temp_min").and_return(18.0)
        allow(response).to receive(:dig).with("weather", 0, "description").and_return("clear sky")

        # Stub the .get method of WeatherService to return this fake response
        allow(WeatherService).to receive(:get).and_return(response)

        result = described_class.fetch(lat, lon)

        expect(result[:temperature]).to eq(25.0)
        expect(result[:high]).to eq(30.0)
        expect(result[:low]).to eq(18.0)
        expect(result[:description]).to eq("Clear sky")
      end
    end

    context 'when API call fails' do
      it 'returns nil' do
        failed_response = double('HTTParty::Response', success?: false)
        allow(WeatherService).to receive(:get).and_return(failed_response)

        result = described_class.fetch(lat, lon)
        expect(result).to be_nil
      end
    end

    context 'when an exception occurs during fetch' do
      it 'returns an error hash' do
        allow(WeatherService).to receive(:get).and_raise(StandardError.new("Timeout"))

        result = described_class.fetch(lat, lon)
        expect(result[:error]).to include("Weather Forecast failed: Timeout")
      end
    end
  end
end
