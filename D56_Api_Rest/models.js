const Weather = {};

Weather.GPS = class GPS {
    constructor(latitude, longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }
};

Weather.City = class City {
    constructor(name) {
        this.name = name;
    }
};

Weather.Location = class Location {
    constructor(name, coordinates, city, country) {
        this.name = name;
        this.coordinates = coordinates;
        this.city = city;
        this.country = country;
    }
};

Weather.WeatherData = class WeatherData {
    constructor(temperature, humidity, windSpeed) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
    }
};

Weather.LocationWeatherData = class LocationWeatherData {
    constructor(location, weatherData) {
        this.locationName = location.name;
        this.latitude = location.coordinates.latitude;
        this.longitude = location.coordinates.longitude;
        this.cityName = location.city.name;
        this.country = location.country;
        this.temperature = weatherData.temperature;
        this.humidity = weatherData.humidity;
        this.windSpeed = weatherData.windSpeed;
        this.timestamp = new Date().toISOString();
    }
};

export default Weather;

