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
        const { lat, lon, city } = req.query;

        let latFloat, lonFloat;

        // If city is provided, get coordinates from OpenStreetMap
        if (city) {
            try {
                const locationData = await this.openStreetMapClient.getCityCoordinates(city);
                latFloat = parseFloat(locationData.lat);
                lonFloat = parseFloat(locationData.lon);
            } catch (error) {
                return res.status(400).json({ error: 'Invalid city name or failed to fetch location data.' });
            }
        } else if (lat && lon) {
            latFloat = parseFloat(lat);
            lonFloat = parseFloat(lon);

            if (isNaN(latFloat) || latFloat < -90 || latFloat > 90) {
                return res.status(400).json({ error: 'Invalid latitude. Must be a number between -90 and 90.' });
            }
            if (isNaN(lonFloat) || lonFloat < -180 || lonFloat > 180) {
                return res.status(400).json({ error: 'Invalid longitude. Must be a number between -180 and 180.' });
            }
        } else {
            return res.status(400).json({ error: 'You must provide either a city name or latitude and longitude.' });
        }

        // Fetch weather data using the lat/lon coordinates
        try {
            const weatherData = await this.openWeatherMapClient.getWeatherData(latFloat, lonFloat);
            const builder = new LocationWeatherBuilder();
            const locationWeather = builder
                .setLocationName(city || weatherData.name)
                .setCoordinates(latFloat, lonFloat)
                .setCityName(weatherData.name || 'Unknown')
                .setCountry(weatherData.sys?.country || 'Unknown')
                .setWeatherData(weatherData.main.temp, weatherData.main.humidity, weatherData.wind.speed)
                .build();

            res.status(200).json(locationWeather);
        } catch (error) {
            console.error('Error fetching weather data:', error);
            res.status(500).json({ error: 'Failed to fetch weather data' });
        }
    }
}

export default FormatController;


