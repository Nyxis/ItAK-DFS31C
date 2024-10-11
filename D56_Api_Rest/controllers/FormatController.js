const { GPS, City, Location, WeatherData, LocationWeatherData } = require('../models');

class FormatController {
    static getJsonFormat(req, res) {
        res.status(200).json({ hello: 'world' });
    }

    static getXmlFormat(req, res) {
        res.status(200).set('Content-Type', 'application/xml').send('<hello>world</hello>');
    }

    static getCsvFormat(req, res) {
        res.status(200).set('Content-Type', 'text/csv').send('hello\nworld\n');
    }

    static getLocationWeather(req, res) {
        const { lat, lon } = req.query;

        if (!lat && !lon) {
            return res.status(400).json({ error: 'Both latitude and longitude are required' });
        }
        if (!lat) {
            return res.status(400).json({ error: 'Latitude is required' });
        }
        if (!lon) {
            return res.status(400).json({ error: 'Longitude is required' });
        }

        // Validate latitude and longitude
        const latFloat = parseFloat(lat);
        const lonFloat = parseFloat(lon);
        if (isNaN(latFloat) || latFloat < -90 || latFloat > 90) {
            return res.status(400).json({ error: 'Invalid latitude. Must be a number between -90 and 90.' });
        }
        if (isNaN(lonFloat) || lonFloat < -180 || lonFloat > 180) {
            return res.status(400).json({ error: 'Invalid longitude. Must be a number between -180 and 180.' });
        }

        // Here you would typically fetch real data from external APIs
        // For this example, we'll use mock data
        const gps = new GPS(latFloat, lonFloat);
        const city = new City('MockCity');
        const location = new Location('Mock Location', gps, city, 'MockCountry');
        const weatherData = new WeatherData(25.5, 60, 10);

        const locationWeatherData = new LocationWeatherData(location, weatherData);

        res.status(200).json(locationWeatherData);
    }
}

module.exports = FormatController;
