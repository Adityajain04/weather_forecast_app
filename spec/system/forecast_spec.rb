require 'rails_helper'
require 'ostruct'

RSpec.describe 'Forecasts', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'shows error when address is blank' do
    visit root_path
    click_button 'Get Forecast'
    expect(page).to have_content('Please enter an address.')
  end

  it 'shows error when address is not found' do
    allow(GeocoderService).to receive(:call).and_return({ error: "Address not found" })

    visit root_path
    fill_in 'Enter address:', with: 'invalid'
    click_button 'Get Forecast'
    expect(page).to have_content('Address not found')
  end

  it 'displays forecast from API' do
    allow(GeocoderService).to receive(:call).and_return(
      { lat: 12.34, lon: 56.78, zip_code: '12345' }
    )

    allow(Rails.cache).to receive(:read).and_return(nil)
    allow(WeatherService).to receive(:fetch).and_return(
      { temperature: 25, high: 28, low: 22, description: 'Clear sky' }
    )

    visit root_path
    fill_in 'Enter address:', with: 'Delhi'
    click_button 'Get Forecast'

    expect(page).to have_content('Forecast for Delhi')
    expect(page).to have_content('🌡️ Temperature: 25°C')
    expect(page).to have_content('🌦️ Conditions: Clear sky')
    expect(page).to have_content('Live data from API 🔄')
  end

  it 'displays forecast from cache' do
    allow(GeocoderService).to receive(:call).and_return(
      { lat: 12.34, lon: 56.78, zip_code: '12345' }
    )

    allow(Rails.cache).to receive(:read).and_return(
      { temperature: 22, high: 24, low: 20, description: 'Partly cloudy' }
    )

    visit root_path
    fill_in 'Enter address:', with: 'Mumbai'
    click_button 'Get Forecast'

    expect(page).to have_content('🌡️ Temperature: 22°C')
    expect(page).to have_content('Fetched from cache ✅')
  end

  it 'renders about page' do
    visit about_path
    expect(page).to have_content('About')
  end
end

