# 🌤️ Weather Companion - Rails App

A simple Ruby on Rails web application that allows users to enter an address and retrieve the current weather forecast using the OpenWeatherMap API. Results are cached for 30 minutes by zip code to reduce redundant API calls and improve performance.

---

## 🔧 Features

- Enter any address to get the weather forecast
- Displays:
  - Current temperature
  - High and low temperature
  - Weather description
- Caches results for 30 minutes by zip code
- Indicates whether the response was fetched from cache
- Clean UI built with TailwindCSS
- Fully tested with RSpec and Capybara

---

## 🚀 Tech Stack

- Ruby on Rails 7
- HTTParty (for API calls)
- Geocoder (to convert addresses to lat/lon)
- TailwindCSS
- RSpec (unit and controller testing)
- Capybara (system/integration testing)
- SimpleCov (test coverage reporting)

---

## 🧪 Running the App

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/weather-app.git
   cd weather-app
   ```

2. **Install dependencies**
    ```bash
    bundle install
    yarn install
    ```

3. **Set environment variables**

    Create a .env file in the root directory and add your OpenWeather API key:
    ```bash
    OPENWEATHER_API_KEY=your_api_key_here
    ```

4. **Run the server**
    ```bash
    rails server
    ```

5. **Visit the app**
    ```bash
    http://localhost:3000
    ```

---

## ✅ Testing

**To run the test suite:**
   ```bash
   bundle exec rspec
   ```

**To view code coverage:**
   ```bash
   open coverage/index.html
   ```

---

## 💡 Notes
- Weather data is pulled from OpenWeatherMap
- Ensure you use a valid API key; otherwise, API calls will fail
- All responses are cached for 30 minutes using Rails cache mechanism