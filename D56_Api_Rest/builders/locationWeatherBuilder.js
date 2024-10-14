const Location = require('../models/location');
const WeatherData = require('../models/weatherData');
const LocationWeatherData = require('../dto/locationWeatherData');
const OpenStreetMapService = require('../services/openStreetMapService');
const OpenWeatherMapService = require('../services/openWeatherMapService');

class LocationWeatherBuilder {
    constructor() {
        this.openStreetMapService = new OpenStreetMapService();
        this.openWeatherMapService = new OpenWeatherMapService(process.env.OPENWEATHERMAP_API_KEY);
        this.locationName = null;
    }

    declare() {
        return this;
    }

    name(locationName) {
        this.locationName = locationName;
        return this;
    }

    async create() {
        if (!this.locationName) {
            throw new Error('Location name must be provided');
        }

        // Données localisation OpenStreetMap
        const locationData = await this.openStreetMapService.getLocationByName(this.locationName);
        const city = locationData.name.split(',')[0];  // Extraction du nom de la ville

        // Créer une City et Location
        const location = new Location(locationData.name, locationData.latitude, locationData.longitude, city);

        // données météo OpenWeatherMap
        const weatherData = await this.openWeatherMapService.getWeatherByCoordinates(location.latitude, location.longitude);
        const weather = new WeatherData(weatherData.temperature, weatherData.humidity, weatherData.windSpeed);

        // dto LocationWeatherData 
        return new LocationWeatherData(location, weather);
    }
}

module.exports = LocationWeatherBuilder;
