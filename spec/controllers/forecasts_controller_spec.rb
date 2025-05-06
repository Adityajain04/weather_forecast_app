# spec/controllers/forecasts_controller_spec.rb
require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    let(:address) { 'Bangalore, India' }

    context 'when address is blank' do
      it 'redirects with alert' do
        post :create, params: { address: '' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Please enter an address.')
      end
    end

    context 'when geocoding fails' do
      it 'redirects with error from geocoder' do
        allow(GeocoderService).to receive(:call).and_return({ error: 'Address not found' })
        post :create, params: { address: address }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Address not found')
      end
    end

    context 'when geocoding and weather fetch succeed' do
      let(:geo_data) { { lat: 12.9716, lon: 77.5946, zip_code: '560001' } }
      let(:weather_data) { { temperature: 25, high: 30, low: 20, description: 'Clear sky' } }

      before do
        allow(GeocoderService).to receive(:call).and_return(geo_data)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(WeatherService).to receive(:fetch).and_return(weather_data)
        allow(Rails.cache).to receive(:write)
      end

      it 'renders index with weather info' do
        post :create, params: { address: address }
        expect(response).to render_template(:index)
        expect(assigns(:weather)).to eq(weather_data)
      end
    end
  end
end
