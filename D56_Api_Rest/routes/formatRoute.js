import express from 'express';
import FormatController from '../controllers/FormatController.js';

export default function(apiKey) {
    const router = express.Router();
    const formatController = new FormatController(apiKey);

    router.get('/format/:format', FormatController.getFormat);
    router.get('/location-weather', (req, res) => formatController.getLocationWeather(req, res));

    return router;
}

