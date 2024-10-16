class WeatherData {
    constructor(
        observationTime,
        temperature,
        weatherDescriptions,
        windSpeed,
        windDegree,
        windDir,
        pressure,
        precip,
        humidity,
        cloudcover,
        feelslike,
        uvIndex,
        visibility,
        weatherIcons
    ) {
        this.observationTime = observationTime; // Observation time (e.g., "12:14 PM")
        this.temperature = temperature;         // Temperature in Celsius (e.g., 13)
        this.weatherDescriptions = weatherDescriptions; // Array of weather descriptions (e.g., ["Sunny"])
        this.windSpeed = windSpeed;             // Wind speed in kilometers per hour (e.g., 0)
        this.windDegree = windDegree;           // Wind degree (e.g., 349)
        this.windDir = windDir;                 // Wind direction (e.g., "N")
        this.pressure = pressure;               // Air pressure in millibars (e.g., 1010)
        this.precip = precip;                   // Precipitation in millimeters (e.g., 0)
        this.humidity = humidity;               // Humidity percentage (e.g., 90)
        this.cloudcover = cloudcover;           // Cloud cover percentage (e.g., 0)
        this.feelslike = feelslike;             // Feels-like temperature (e.g., 13)
        this.uvIndex = uvIndex;                 // UV index (e.g., 4)
        this.visibility = visibility;           // Visibility in kilometers (e.g., 16)
        this.weatherIcons = weatherIcons;       // Array of weather icons (e.g., ["https://..."])
    }
}

module.exports = WeatherData;