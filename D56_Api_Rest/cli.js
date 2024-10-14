import axios from 'axios';
import crypto from 'crypto';
import dotenv from 'dotenv';

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
    const data = `lat=${lat}&lon=${lon}`; // Data to hash
    console.log('Client Data for Signature:', data);  // Log the data string
    const signature = crypto.createHmac('sha256', secret).update(data).digest('hex');
    console.log('Generated Signature (Client):', signature);
    return signature;
}

// Fetch the homepage and get the WeatherData endpoint
async function fetchWeather() {
    try {
        const homepageUrl = 'http://localhost:3000/api';  // Base URL

        // Generate signature
        const signature = generateSignature(lat, lon, secret);

        // Send the key, secret, and signature in the headers
        const homepageResponse = await axios.get(homepageUrl, {
            headers: {
                'x-api-key': key,        // API key
                'x-api-signature': signature,  // HMAC signature
            }
        });

        console.log('Homepage Response:', homepageResponse.data);

    } catch (error) {
        console.error('Error fetching weather data:', error.message);
    }
}

fetchWeather();

