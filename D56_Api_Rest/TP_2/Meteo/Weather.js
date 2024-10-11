class Weather {
    constructor(temperature, humidity, windSpeed) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
    }

    getWeatherInfo() {
        return `Temperature: ${this.temperature}°C, Humidity: ${this.humidity}%, Wind Speed: ${this.windSpeed} km/h`;
    }
}

module.exports = Weather;
