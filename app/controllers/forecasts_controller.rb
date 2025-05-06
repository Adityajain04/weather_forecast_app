class ForecastsController < ApplicationController
  before_action :valid_params, only: [:create]

  def index
  end

  def create
    geo = GeocoderService.call(params[:address])

    if geo[:error]
      redirect_to root_path, alert: geo[:error] and return
    else
      lat = geo[:lat]
      lon = geo[:lon]
      zip_code = geo[:zip_code] || "unknown"
    end

    cache_key = "forecast:#{zip_code}"

    if (cached = Rails.cache.read(cache_key))
      @weather = cached
      @from_cache = true
    else
      @weather = WeatherService.fetch(lat, lon)
      if @weather
        Rails.cache.write(cache_key, @weather, expires_in: 30.minutes)
        @from_cache = false
      else
        redirect_to root_path, alert: "Could not retrieve forecast." and return
      end
    end

    @location = params[:address]
    render :index
  end

  def about; end

  private

  def valid_params
    redirect_to root_path, alert: "Please enter an address." and return if params[:address].blank?
  end
end
