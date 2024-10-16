// Inside routes/home.js
const express = require('express');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const router = express.Router();

dotenv.config();

const apiKey = process.env.API_KEY;
const secretKey = process.env.SECRET_KEY;

// API Homepage route
router.post('/home', (req, res) => {
    const { providedApiKey, providedSecretKey } = req.body;

    // Validate the provided API key and secret
    if (providedApiKey === apiKey && providedSecretKey === secretKey) {
        // Generate a JWT token
        const token = jwt.sign({ apiKey: providedApiKey }, secretKey, { expiresIn: '1h' });

        // Return hypermedia links and the token
        res.json({
            message: "Welcome to the API!",
            token: token,
            links: [
                {
                    rel: "weather-data",
                    href: `/APIexercice/V1/locationWeatherData`
                }
            ]
        });
    } else {
        res.status(401).json({ error: 'Invalid API key or secret key' });
    }
});

module.exports = router;