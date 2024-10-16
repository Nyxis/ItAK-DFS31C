require('dotenv').config();
const axios = require('axios');

class WeatherService {
  constructor() {
    this.baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
    this.apiKey = process.env.OPENWEATHER_API_KEY;  // Ensure the API key is set in the environment
  }

  async getWeatherData(lat, lon) {
    try {
      const response = await axios.get(this.baseUrl, {
        params: {
          lat: lat,
          lon: lon,
          appid: this.apiKey,
          units: 'metric'
        },
      });

      return response.data;
    } catch (error) {
      console.error('Error fetching weather data:', error.message);
      throw new Error('Unable to fetch weather data');
    }
  }
}

module.exports = {
  getWeather: async (city) => {
    // Actual implementation
  },
};