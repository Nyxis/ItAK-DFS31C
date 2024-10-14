import express from 'express';
import FormatController from '../controllers/FormatController.js';

export default function(apiKey) {
    const router = express.Router();
    const formatController = new FormatController(apiKey);

    router.get('/format/:format', FormatController.getFormat);

    // Now it can accept either lat/lon or city
    router.get('/location-weather', (req, res) => formatController.getLocationWeather(req, res));

    return router;
}

