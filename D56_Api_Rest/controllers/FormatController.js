// controllers/FormatController.js
import Weather from '../models.js';
import OpenStreetMapClient from '../services/OpenStreetMapClient.js';
import OpenWeatherMapClient from '../services/OpenWeatherMapClient.js';
import LocationWeatherBuilder from '../builders/LocationWeatherBuilder.js';

class FormatController {
    constructor(apiKey) {
        console.log('API Key used in FormatController:', apiKey);
        this.openStreetMapClient = new OpenStreetMapClient();
        this.openWeatherMapClient = new OpenWeatherMapClient(apiKey);
    }

    static getFormat(req, res) {
        const format = req.params.format;
        const formatHandlers = {
            'json': () => res.json({ hello: 'world' }),
            'xml': () => res.type('application/xml').send('<hello>world</hello>'),
            'csv': () => res.type('text/csv').send('hello\nworld\n')
        };

        if (formatHandlers.hasOwnProperty(format)) {
            formatHandlers[format]();
        } else {
            res.status(400).json({ error: 'Unsupported format' });
        }
    }

    async getLocationWeather(req, res) {
        const { lat, lon } = req.query;

        if (!lat || !lon) {
            return res.status(400).json({ error: 'Both latitude and longitude are required' });
        }

        const latFloat = parseFloat(lat);
        const lonFloat = parseFloat(lon);

        if (isNaN(latFloat) || latFloat < -90 || latFloat > 90) {
            return res.status(400).json({ error: 'Invalid latitude. Must be a number between -90 and 90.' });
        }
        if (isNaN(lonFloat) || lonFloat < -180 || lonFloat > 180) {
            return res.status(400).json({ error: 'Invalid longitude. Must be a number between -180 and 180.' });
        }

        try {
            const [locationData, weatherData] = await Promise.all([
                this.openStreetMapClient.getLocationInfo(latFloat, lonFloat),
                this.openWeatherMapClient.getWeatherData(latFloat, lonFloat)
            ]);

            const builder = new LocationWeatherBuilder();
            const locationWeather = builder
                .setLocationName(locationData.display_name)
                .setCoordinates(latFloat, lonFloat)
                .setCityName(locationData.address?.city || 'Unknown')
                .setCountry(locationData.address?.country || 'Unknown')
                .setWeatherData(weatherData.main.temp, weatherData.main.humidity, weatherData.wind.speed)
                .build();

            res.status(200).json(locationWeather);
        } catch (error) {
            console.error('Error fetching location or weather data:', error);
            res.status(500).json({ error: 'Failed to fetch location or weather data' });
        }
    }
}

export default FormatController;

