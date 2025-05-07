# spec/controllers/forecasts_controller_spec.rb
require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe "POST #create" do
    context "when address is blank" do
      it "redirects with alert" do
        post :create, params: { address: "" }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Please enter an address.")
      end
    end

    context "when geocoding fails with error" do
      it "redirects with geocoder error" do
        allow(GeocoderService).to receive(:call).and_return({ error: "Address not found" })
        post :create, params: { address: "xyz123" }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Address not found")
      end
    end

    context "when weather fetch fails" do
      it "redirects with forecast error" do
        geo_data = { lat: 12.34, lon: 56.78, zip_code: '12345' }
        allow(GeocoderService).to receive(:call).and_return(geo_data)
        allow(WeatherService).to receive(:fetch).and_return(nil)

        post :create, params: { address: "Delhi" }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Could not retrieve forecast.")
      end
    end

    context "when forecast is cached" do
      it "renders index with cached data" do
        geo_data = { lat: 12.34, lon: 56.78, zip_code: '12345' }
        weather_data = { temperature: 25, high: 27, low: 23, description: "Clear sky" }

        allow(GeocoderService).to receive(:call).and_return(geo_data)
        allow(Rails.cache).to receive(:read).and_return(weather_data)

        post :create, params: { address: "Mumbai" }
        expect(response).to render_template(:index)
        expect(assigns(:weather)).to eq(weather_data)
        expect(assigns(:from_cache)).to be true
      end
    end

    context "when no cache, API fetch succeeds" do
      it "fetches weather and stores in cache" do
        geo_data = { lat: 12.34, lon: 56.78, zip_code: '12345' }
        weather_data = { temperature: 25, high: 27, low: 23, description: "Clear sky" }

        allow(GeocoderService).to receive(:call).and_return(geo_data)
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(WeatherService).to receive(:fetch).and_return(weather_data)
        allow(Rails.cache).to receive(:write)

        post :create, params: { address: "Bangalore" }
        expect(response).to render_template(:index)
        expect(assigns(:weather)).to eq(weather_data)
        expect(assigns(:from_cache)).to be false
      end
    end
  end

  describe "GET #about" do
    it "renders about page" do
      get :about
      expect(response).to be_successful
    end
  end
end

