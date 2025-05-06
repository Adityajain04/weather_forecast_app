class ForecastsController < ApplicationController
  # Ensure the address is present before proceeding with forecast generation
  before_action :ensure_address_present, only: [:create]

  # Renders the main forecast search page
  def index; end

  # Handles POST request to fetch weather based on user input
  def create
    @location = params[:address]

    # Perform geocoding and handle error if any
    geo = GeocoderService.call(@location)
    redirect_to root_path, alert: geo[:error] and return if geo[:error]

    # Either get weather from cache or fetch fresh and cache it
    cached_response(geo)

    # Render the same index view with results
    render :index
  end

  # Simple "About" page route
  def about; end

  private

  # Validates that the address input is present
  def ensure_address_present
    redirect_to root_path, alert: "Please enter an address." if params[:address].blank?
  end

  # Manages forecast caching logic: fetch from cache or call weather API
  def cached_response(geo)
    cache_key = "forecast:#{(geo[:zip_code] || "unknown")}"

    if (cached = Rails.cache.read(cache_key))
      @weather = cached
      @from_cache = true
    else
      @weather = WeatherService.fetch(geo[:lat], geo[:lon])
      if @weather && !@weather[:error]
        Rails.cache.write(cache_key, @weather, expires_in: 30.minutes)
        @from_cache = false
      else
        redirect_to root_path, alert: "Could not retrieve forecast." and return
      end
    end
  end

end
