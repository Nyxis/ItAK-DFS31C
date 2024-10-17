const axios = require('axios');
const config = require('../config');

class OpenWeatherMapService {
  async getWeather(latitude, longitude) {
    try {
      console.log('API Key (last 4 characters):', config.OPENWEATHERMAP_API_KEY.slice(-4));
      const url = `${config.OPENWEATHERMAP_API_URL}?lat=${latitude}&lon=${longitude}&appid=${config.OPENWEATHERMAP_API_KEY}&units=metric`;
      console.log('Request URL:', url.replace(config.OPENWEATHERMAP_API_KEY, 'API_KEY_HIDDEN'));

      const response = await axios.get(url);
      
      console.log('OpenWeatherMap response:', response.data);

      return {
        temperature: response.data.main.temp,
        humidity: response.data.main.humidity,
        windSpeed: response.data.wind.speed
      };
    } catch (error) {
      console.error('Full error object:', error);
      if (error.response) {
        console.error('Error status:', error.response.status);
        console.error('Error data:', error.response.data);
      } else if (error.request) {
        console.error('No response received:', error.request);
      } else {
        console.error('Error message:', error.message);
      }
      throw new Error('Error fetching weather data: ' + (error.response ? JSON.stringify(error.response.data) : error.message));
    }
  }
}

module.exports = OpenWeatherMapService;