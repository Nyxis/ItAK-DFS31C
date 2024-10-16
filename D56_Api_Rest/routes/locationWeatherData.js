const express = require('express');
const router = express.Router();
const LocationService = require('../services/locationService');
const WeatherService = require('../services/weatherService');
const LocationWeatherDTO = require('../DTO/locationWeatherData');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');

dotenv.config();

const apiKey = process.env.API_KEY;
const secretKey = process.env.SECRET_KEY;

const locationService = new LocationService();
const weatherService = new WeatherService();

// Route to generate a JWT token
router.post('/auth', (req, res) => {
    const { providedApiKey } = req.body; // Only get the API key from the user

    // Validate the provided API key
    if (providedApiKey === process.env.API_KEY) {
        // Generate JWT token using the server's secret key
        const token = jwt.sign({ apiKey: providedApiKey }, process.env.SECRET_KEY, { expiresIn: '1h' });
        res.json({ token });
    } else {
        res.status(401).json({ error: 'Invalid API key' }); // No secret key required from the user
    }
});

// Middleware to authenticate API requests using JWT
function authenticateRequest(req, res, next) {
    const token = req.headers['authorization'];

    if (!token) {
        return res.status(401).json({ error: 'Authorization token is required' });
    }

    try {
        // Verify the token using the secretKey
        const decoded = jwt.verify(token, secretKey);
        req.user = decoded; // Attach decoded token info to the request object
        next(); // Proceed if the token is valid
    } catch (err) {
        return res.status(403).json({ error: 'Unauthorized: ' + err.message });
    }
}

// Apply the authenticateRequest middleware to secure this route
router.use(authenticateRequest);

// Main route to get weather and location data
router.get('/locationWeatherData', async (req, res) => {
    const { city, lat, lon } = req.query;

    try {
        const locationData = await locationService.getLocationData(city, lat, lon);
        const weatherData = await weatherService.getWeatherData(locationData.lat, locationData.lon);
        const locationWeatherData = new LocationWeatherDTO(locationData, weatherData);
        return res.json(locationWeatherData);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;