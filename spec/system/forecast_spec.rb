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

  it 'displays forecast when valid address is given' do
    # Mock external service calls
    stub_request(:get, /maps.googleapis.com/).to_return(body: "[]")
    allow(Geocoder).to receive(:search).and_return([
      OpenStruct.new(latitude: 12.34, longitude: 56.78, postal_code: '12345')
    ])

    stub_request(:get, /api.openweathermap.org/)
      .to_return(
        body: {
          main: { temp: 25.0, temp_max: 28.0, temp_min: 22.0 },
          weather: [{ description: 'clear sky' }]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    visit root_path
    fill_in 'Enter address:', with: 'New York'
    click_button 'Get Forecast'

    expect(page).to have_content('Forecast for New York')
    expect(page).to have_content('🌡️ Temperature: 25.0°C')
    expect(page).to have_content('🌦️ Conditions: Clear sky')
  end
end
