// models/locationWeatherDTO.js
// Un lieu (nom, coordonnées GPS, ville, pays)
// Les données météo à un temps donné (température, humidité, vitesse du vent)
class LocationWeatherDTO {
    constructor(location, weather) {
      this.city = location.city || location.address.city;
      this.country = location.country || location.address.country;
      this.latitude = location.lat;
      this.longitude = location.lon;
      this.temperature = weather.main.temp;
      this.weatherDescription = weather.weather[0].description;
      this.windSpeed = weather.wind.speed;
      this.humidity = weather.main.humidity;
    }
  }
  
  module.exports = LocationWeatherDTO;