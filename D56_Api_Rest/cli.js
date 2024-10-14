import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

// CLI arguments: lat, lon, key, secret
const [lat, lon, key, secret] = process.argv.slice(2);

// Validate input
if (!lat || !lon || !key || !secret) {
    console.error('Usage: node cli.js <latitude> <longitude> <key> <secret>');
    process.exit(1);
}

// Fetch the homepage and get the WeatherData endpoint
async function fetchWeather() {
    try {
        const homepageUrl = 'http://localhost:3000/api';  // Base URL without keys in query string

        // Send the key and secret in the headers
        const homepageResponse = await axios.get(homepageUrl, {
            headers: {
                'x-api-key': key,        // Custom headers for key and secret
                'x-api-secret': secret
            }
        });

        const weatherEndpoint = homepageResponse.data.availableEndpoints.find(
            endpoint => endpoint.name === 'Get Weather Data'
        );

        if (!weatherEndpoint) {
            throw new Error('Weather Data endpoint not found');
        }

        // Construct the weather data URL with the provided coordinates
        const weatherUrl = weatherEndpoint.link.replace('{latitude}', lat).replace('{longitude}', lon);
        const weatherResponse = await axios.get(weatherUrl);

        console.log('Weather Data:', weatherResponse.data);
    } catch (error) {
        console.error('Error fetching weather data:', error.message);
    }
}

fetchWeather();

