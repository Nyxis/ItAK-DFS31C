import Weather from '../models.js';

class LocationWeatherBuilder {
    constructor() {
        this.locationName = '';
        this.latitude = 0;
        this.longitude = 0;
        this.cityName = '';
        this.country = '';
        this.temperature = 0;
        this.humidity = 0;
        this.windSpeed = 0;
        this.timestamp = new Date().toISOString();
    }

    setLocationName(name) {
        this.locationName = name;
        return this;
    }

    setCoordinates(latitude, longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
        return this;
    }

    setCityName(cityName) {
        this.cityName = cityName;
        return this;
    }

    setCountry(country) {
        this.country = country;
        return this;
    }

    setWeatherData(temp, humidity, windSpeed) {
        this.temperature = temp;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
        return this;
    }

    build() {
        const gps = new Weather.GPS(this.latitude, this.longitude);
        const city = new Weather.City(this.cityName);
        const location = new Weather.Location(this.locationName, gps, city, this.country);
        const weatherData = new Weather.WeatherData(this.temperature, this.humidity, this.windSpeed);

        return new Weather.LocationWeatherData(location, weatherData);
    }
}

export default LocationWeatherBuilder;


