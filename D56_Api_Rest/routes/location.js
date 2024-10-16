const express = require('express');
const router = express.Router();
const LocationService = require('../services/locationService');

const locationService = new LocationService();

router.get('/location', async (req, res) => {
  const { city } = req.query;

    const locationData = await locationService.getLocationData(city);
    return res.json(locationData);
  });

module.exports = router;