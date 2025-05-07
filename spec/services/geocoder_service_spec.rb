# spec/services/geocoder_service_spec.rb
require 'rails_helper'

RSpec.describe GeocoderService do
  describe '.call' do
    context 'with a valid address' do
      it 'returns latitude, longitude, and zip code' do
        fake_location = double('Location', latitude: 12.34, longitude: 56.78, postal_code: '12345')
        allow(Geocoder).to receive(:search).with('New York').and_return([fake_location])

        result = described_class.call('New York')

        expect(result[:lat]).to eq(12.34)
        expect(result[:lon]).to eq(56.78)
        expect(result[:zip_code]).to eq('12345')
        expect(result[:error]).to be_nil
      end
    end

    context 'with a blank address' do
      it 'returns an error message' do
        result = described_class.call('')
        expect(result[:error]).to eq("Address can't be blank")
      end
    end

    context 'with an address that returns no results' do
      it 'returns an address not found error' do
        allow(Geocoder).to receive(:search).with('UnknownPlace').and_return([])

        result = described_class.call('UnknownPlace')
        expect(result[:error]).to eq("Address not found")
      end
    end

    context 'when an exception is raised during geocoding' do
      it 'returns a geocoding failed error' do
        allow(Geocoder).to receive(:search).and_raise(StandardError.new('Boom!'))

        result = described_class.call('Delhi')
        expect(result[:error]).to include("Geocoding failed")
      end
    end
  end
end
