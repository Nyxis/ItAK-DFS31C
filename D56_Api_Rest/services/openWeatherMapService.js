const axios = require('axios');

class OpenWeatherMapService {
    constructor(apiKey) {
        this.apiKey = apiKey;
    }

    async getWeatherByCoordinates(latitude, longitude) {
        try {
            const response = await axios.get('https://api.openweathermap.org/data/2.5/weather', {
                params: {
                    lat: latitude,
                    lon: longitude,
                    appid: this.apiKey,
                    units: 'metric'
                }
            });
            const { temp, humidity } = response.data.main;
            const { speed: windSpeed } = response.data.wind;

            return {
                temperature: temp,
                humidity: humidity,
                windSpeed: windSpeed
            };
        } catch (error) {
            console.error('Error fetching weather data from OpenWeatherMap:', error.message);
            throw error;
        }
    }
}

module.exports = OpenWeatherMapService;
