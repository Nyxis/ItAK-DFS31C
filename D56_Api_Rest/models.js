class GPS {
    constructor(latitude, longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }
}

class City {
    constructor(name) {
        this.name = name;
    }
}

class Location {
    constructor(name, coordinates, city, country) {
        this.name = name;
        this.coordinates = coordinates;
        this.city = city;
        this.country = country;
    }
}

class WeatherData {
    constructor(temperature, humidity, windSpeed) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
    }
}

class LocationWeatherData {
    constructor(location, weatherData) {
        this.location = {
            name: location.name,
            latitude: location.coordinates.latitude,
            longitude: location.coordinates.longitude,
            city: location.city.name,
            country: location.country
        };
        this.weather = {
            temperature: weatherData.temperature,
            humidity: weatherData.humidity,
            windSpeed: weatherData.windSpeed
        };
        this.timestamp = new Date().toISOString();
    }
}

module.exports = {
    GPS,
    City,
    Location,
    WeatherData,
    LocationWeatherData
};
