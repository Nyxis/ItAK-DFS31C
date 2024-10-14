class LocationWeatherData {
    constructor(location, weatherData) {
        if (!location || !weatherData) {
            throw new Error('Location et WeatherData sont requis pour LocationWeatherData.');
        }
        this.name = location.name;
        this.latitude = location.latitude;
        this.longitude = location.longitude;
        this.city = location.city.toString();
        this.temperature = weatherData.temperature;
        this.humidite = weatherData.humidite;
        this.vitesseVent = weatherData.vitesseVent;
    }

    toJSON() {
        return {
            name: this.name,
            latitude: this.latitude,
            longitude: this.longitude,
            city: this.city,
            temperature: this.temperature,
            humidite: this.humidite,
            vitesseVent: this.vitesseVent,
        };
    }
}

module.exports = LocationWeatherData;