import axios from 'axios';
import crypto from 'crypto';
import dotenv from 'dotenv';

dotenv.config();

// CLI arguments: location (city name or "lat,lon"), key, secret
const [location, key, secret] = process.argv.slice(2);

// Validate input
if (!location || !key || !secret) {
    console.error('Usage: node cli.js <location> <key> <secret>');
    console.error('Location can be a city name or "latitude,longitude"');
    process.exit(1);
}

let params = {};

if (location.includes(',')) {
    const [lat, lon] = location.split(',').map(coord => parseFloat(coord.trim()));
    if (isNaN(lat) || isNaN(lon)) {
        console.error('Invalid coordinates. Please use format: latitude,longitude');
        process.exit(1);
    }
    params = { lat, lon };
} else {
    params = { city: location };
}

// Function to generate the HMAC signature
function generateSignature(params, secret) {
    const sortedParams = Object.keys(params)
        .sort()
        .reduce((acc, key) => {
            acc[key] = params[key];
            return acc;
        }, {});

    const data = Object.entries(sortedParams)
        .map(([key, value]) => `${key}=${value}`)
        .join('&');

    console.log('Client Data for Signature:', data);
    const signature = crypto.createHmac('sha256', secret).update(data).digest('hex');
    console.log('Generated Signature (Client):', signature);
    return signature;
}

// Fetch the homepage and get the WeatherData endpoint
async function fetchWeather() {
    try {
        const baseUrl = 'http://localhost:3000/api';

        const signature = generateSignature(params, secret);

        const homepageResponse = await axios.get(baseUrl, {
            params: params,
            headers: {
                'x-api-key': key,
                'x-api-signature': signature,
            }
        });

        console.log('Homepage Response:', homepageResponse.data);

        if (homepageResponse.data.availableEndpoints) {
            const weatherEndpoint = homepageResponse.data.availableEndpoints.find(
                endpoint => endpoint.name === 'Get Weather Data'
            );

            if (weatherEndpoint) {
                let weatherUrl = weatherEndpoint.link;
                if (params.city) {
                    weatherUrl = weatherUrl.replace('{cityName}', encodeURIComponent(params.city));
                } else {
                    weatherUrl = weatherUrl.replace('{latitude}', params.lat).replace('{longitude}', params.lon);
                }

                const weatherResponse = await axios.get(weatherUrl, {
                    headers: {
                        'x-api-key': key,
                        'x-api-signature': signature,
                    }
                });

                console.log('Weather Data:', weatherResponse.data);
            }
        }
    } catch (error) {
        console.error('Error fetching data:', error.message);
        if (error.response) {
            console.error('Response status:', error.response.status);
            console.error('Response data:', error.response.data);
        }
    }
}

fetchWeather();

