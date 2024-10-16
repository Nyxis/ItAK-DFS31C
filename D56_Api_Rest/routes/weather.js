const express = require('express');
const router = express.Router();
const WeatherService = require('../services/weatherService');

const weatherService = new WeatherService();

// Route to get weather by latitude and longitude
router.get('/weather', async (req, res) => {
  const { lat, lon } = req.query;

  if (!lat || !lon) {
    return res.status(400).json({ error: 'Latitude and longitude are required' });
  }

  try {
    const weatherData = await weatherService.getWeatherData(lat, lon);
    return res.json(weatherData);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

module.exports = router;