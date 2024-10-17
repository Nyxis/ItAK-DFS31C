require('dotenv').config();
const axios = require('axios');

const API_URL = `http://localhost:${process.env.PORT}/api/v1`;
const API_KEY = process.env.API_KEY;
const API_SECRET = process.env.API_SECRET;

async function getWeather(location) {
    try {
        // Get home page and token
        const homeResponse = await axios.get(`${API_URL}`, {
            params: { apiKey: API_KEY, secretKey: API_SECRET }
        });
        const { token, _links } = homeResponse.data;

        // Get weather data
        const weatherUrl = _links.weatherData.href;
        const weatherResponse = await axios.get(`${API_URL}${weatherUrl}`, {
            params: { location },
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });

        console.log('Weather data:', weatherResponse.data);
    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
    }
}

// Usage: node cli.js "Paris"
const location = process.argv[2];
if (location) {
    getWeather(location);
} else {
    console.log('Please provide a location. Usage: node cli.js "City Name"');
}