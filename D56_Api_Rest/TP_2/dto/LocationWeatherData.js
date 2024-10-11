class LocationWeatherData {
    constructor(location, weather) {
        this.country = location.city.country;
        this.latitude = location.coordinates.latitude;
        this.longitude = location.coordinates.longitude;
        this.temperature = weather.temperature;
        this.weatherDescription = weather.weatherDescription;
        this.windSpeed = weather.windSpeed;
        this.humidity = weather.humidity;
    }
}

module.exports = LocationWeatherData;
