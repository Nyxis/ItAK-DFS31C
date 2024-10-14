import express from 'express';

const router = express.Router();

// Sample hardcoded key/secret for authentication
const API_KEY = 'sample_key';
const API_SECRET = 'sample_secret';

router.get('/', (req, res) => {
    const apiKey = req.headers['x-api-key'];        // Get key from headers
    const apiSecret = req.headers['x-api-secret'];  // Get secret from headers

    // Check for API key and secret in headers
    if (apiKey !== API_KEY || apiSecret !== API_SECRET) {
        return res.status(401).json({ error: 'Unauthorized: Invalid API key or secret' });
    }

    // Hypermedia links (currently only the WeatherData endpoint)
    const hypermediaLinks = {
        version: 'v1',
        availableEndpoints: [
            {
                name: 'Get Weather Data',
                method: 'GET',
                link: `${req.protocol}://${req.get('host')}/api/v1/location-weather?lat={latitude}&lon={longitude}`,
                description: 'Get weather information for a given location'
            }
        ]
    };

    res.status(200).json(hypermediaLinks);
});

export default router;

