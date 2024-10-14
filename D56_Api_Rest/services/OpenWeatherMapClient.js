import axios from 'axios';

class OpenWeatherMapClient {
    constructor(apiKey) {
        this.apiKey = apiKey;
        this.baseURL = 'https://api.openweathermap.org/data/2.5';
    }

    async getWeatherData(lat, lon) {
        try {
            console.log(`Making request with API key: ${this.apiKey}`);
            const response = await axios.get(`${this.baseURL}/weather`, {
                params: {
                    lat: lat,
                    lon: lon,
                    appid: this.apiKey,
                    units: 'metric'
                }
            });
            console.log('Weather API Response:', JSON.stringify(response.data, null, 2));
            return response.data;
        } catch (error) {
            console.error('Error fetching weather data:', error.response ? error.response.data : error.message);
            console.error('Full error object:', JSON.stringify(error, null, 2));
            throw new Error('Failed to fetch weather data');
        }
    }
}

export default OpenWeatherMapClient;

