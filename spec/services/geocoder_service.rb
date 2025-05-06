# spec/services/geocoder_service_spec.rb
require 'rails_helper'

RSpec.describe GeocoderService do
  describe '.call' do
    it 'returns geocoding data for a valid address' do
      address = '1600 Amphitheatre Parkway, Mountain View, CA'
      location = double('Location', latitude: 37.4221, longitude: -122.0841, postal_code: '94043')
      allow(Geocoder).to receive(:search).with(address).and_return([location])

      result = described_class.call(address)
      expect(result[:lat]).to eq(37.4221)
      expect(result[:lon]).to eq(-122.0841)
      expect(result[:zip_code]).to eq('94043')
    end

    it 'returns error if address is blank' do
      result = described_class.call('')
      expect(result[:error]).to eq("Address can't be blank")
    end

    it 'returns error if address is not found' do
      allow(Geocoder).to receive(:search).and_return([])
      result = described_class.call('unknown address')
      expect(result[:error]).to eq('Address not found')
    end
  end
end
