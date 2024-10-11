const express = require('express');
const router = express.Router();
const FormatController = require('../controllers/FormatController');

router.get('/format/json', FormatController.getJsonFormat);
router.get('/format/xml', FormatController.getXmlFormat);
router.get('/format/csv', FormatController.getCsvFormat);
router.get('/location-weather', FormatController.getLocationWeather);

module.exports = router;