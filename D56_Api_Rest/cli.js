import axios from 'axios';
import dotenv from 'dotenv';
import crypto from 'crypto';

dotenv.config();

// CLI arguments: lat, lon, key, secret
const [lat, lon, key, secret] = process.argv.slice(2);

// Validate input
if (!lat || !lon || !key || !secret) {
    console.error('Usage: node cli.js <latitude> <longitude> <key> <secret>');
    process.exit(1);
}

// Function to generate the HMAC signature
function generateSignature(lat, lon, secret) {
    const data = `lat=${lat}&lon=${lon}`; // Data to hash (could include method, path, etc.)
    const signature = crypto.createHmac('sha256', secret).update(data).digest('hex');

    // Log the generated signature
    console.log('Generated Signature:', signature);

    return signature;
}

// Fetch the homepage and get the WeatherData endpoint
async function fetchWeather() {
    try {
        const homepageUrl = 'http://localhost:3000/api';  // Base URL without keys in query string

        // Generate signature
        const signature = generateSignature(lat, lon, secret);

        // Send the key, secret, and signature in the headers
        const homepageResponse = await axios.get(homepageUrl, {
            headers: {
                'x-api-key': key,        // API key
                'x-api-signature': signature,  // HMAC signature
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

