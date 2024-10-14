import Weather from '../models.js';
import OpenStreetMapClient from '../services/OpenStreetMapClient.js';
import OpenWeatherMapClient from '../services/OpenWeatherMapClient.js';

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

            console.log('Location Data:', JSON.stringify(locationData, null, 2));
            console.log('Weather Data:', JSON.stringify(weatherData, null, 2));

            const gps = new Weather.GPS(latFloat, lonFloat);
            const city = new Weather.City(locationData.address?.city || locationData.address?.town || locationData.address?.village || 'Unknown');
            const location = new Weather.Location(locationData.display_name, gps, city, locationData.address?.country || 'Unknown');

            const weather = new Weather.WeatherData(
                weatherData.main.temp,
                weatherData.main.humidity,
                weatherData.wind.speed
            );

            const locationWeatherData = new Weather.LocationWeatherData(location, weather);

            res.status(200).json(locationWeatherData);
        } catch (error) {
            console.error('Error fetching location or weather data:', error);

            let errorMessage = 'Failed to fetch location or weather data';
            let statusCode = 500;

            if (error.response) {
                statusCode = error.response.status;
                errorMessage += `: ${error.response.data.message || error.response.statusText}`;
            } else if (error.request) {
                errorMessage += ': No response received from the server';
            } else {
                errorMessage += `: ${error.message}`;
            }

            res.status(statusCode).json({
                error: errorMessage,
                details: process.env.NODE_ENV === 'development' ? error.stack : undefined
            });
        }
    }
}

export default FormatController;

