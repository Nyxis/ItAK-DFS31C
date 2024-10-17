const Location = require('./models/Location');
const Weather = require('./models/Weather');
const OpenStreetMapService = require('./services/OpenStreetMapService');
const OpenWeatherMapService = require('./services/OpenWeatherMapService');

class LocationWeatherBuilder {
  constructor() {
    this.openStreetMapService = new OpenStreetMapService();
    this.openWeatherMapService = new OpenWeatherMapService();
    this.locationName = '';
  }

  setName(name) {
    this.locationName = name;
    return this;
  }

  async build() {
    const location = await this.openStreetMapService.getLocation(this.locationName);
    const weather = await this.openWeatherMapService.getWeather(location.latitude, location.longitude);
    
    return {
      location: new Location(
        location.name,
        location.latitude,
        location.longitude,
        location.city,
        location.country
      ),
      weather: new Weather(
        weather.temperature,
        weather.humidity,
        weather.windSpeed
      )
    };
  }
}

module.exports = LocationWeatherBuilder;