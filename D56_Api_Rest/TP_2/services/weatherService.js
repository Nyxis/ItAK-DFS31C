const axios = require('axios');

class WeatherService {
    static async getWeather(latitude, longitude) {
        const apiKey = '1c292887580d30e65ae3a7764df0f72c'; // Remplace par ta clé API météo
        const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&units=metric&appid=${apiKey}`);
        const data = response.data;

        return {
            temperature: data.main.temp,
            weatherDescription: data.weather[0].description,
            windSpeed: data.wind.speed,
            humidity: data.main.humidity,
        };
    }
}

module.exports = WeatherService;
