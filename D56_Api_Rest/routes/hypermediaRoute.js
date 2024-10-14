import express from 'express';
import crypto from 'crypto';

const router = express.Router();

// Sample hardcoded key/secret for authentication
const API_KEY = 'sample_key';
const API_SECRET = 'sample_secret';

// Function to verify the HMAC signature
function verifySignature(lat, lon, receivedSignature, secret) {
    const formattedLat = lat.toFixed(4);
    const formattedLon = lon.toFixed(4);

    const data = `lat=${formattedLat}&lon=${formattedLon}`;
    console.log('Server Data for Signature:', data);

    const generatedSignature = crypto.createHmac('sha256', secret).update(data).digest('hex');
    console.log('Generated Signature (Server):', generatedSignature);
    console.log('Received Signature (Client):', receivedSignature);

    return generatedSignature === receivedSignature;
}


router.get('/', (req, res) => {
    const apiKey = req.headers['x-api-key'];
    const apiSignature = req.headers['x-api-signature'];

    const lat = 40.7128;
    const lon = -74.0060;

    // Check for API key
    if (apiKey !== API_KEY) {
        return res.status(401).json({ error: 'Unauthorized: Invalid API key' });
    }

    // Verify the signature
    if (!verifySignature(lat, lon, apiSignature, API_SECRET)) {
        return res.status(401).json({ error: 'Unauthorized: Invalid signature' });
    }

    // Return hypermedia links or the necessary data
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


