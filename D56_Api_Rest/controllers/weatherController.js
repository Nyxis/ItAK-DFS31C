const { getWeather } = require('../services/weatherService');

exports.getWeather = async (req, res) => {
    const city = req.query.city || 'Lyon';  // Default city if not provided

    try {
        const weatherData = await getWeather(city);

        res.json({
            location: city,
            temperature: weatherData.temperature,
            humidity: weatherData.humidity,
            wind_speed: weatherData.wind_speed,
            description: weatherData.weather_descriptions[0]
        });
    } catch (error) {
        res.status(500).json({ error: 'Unable to fetch weather data' });
    }
};