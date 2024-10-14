const express = require('express');
const router = express.Router();
const FormatController = require('../controllers/FormatController');

router.get('/format/:format', FormatController.getFormat);
router.get('/location-weather', FormatController.getLocationWeather);

module.exports = router;

