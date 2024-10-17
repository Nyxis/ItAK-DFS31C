// Определяем класс LocationWeatherDTO для передачи данных о местоположении и погоде
class LocationWeatherDTO {
    constructor(location, weather) {
      // Копируем свойства из объекта location
      this.name = location.name;
      this.latitude = location.latitude;
      this.longitude = location.longitude;
      this.city = location.city;
      this.country = location.country;
      // Копируем свойства из объекта weather
      this.temperature = weather.temperature;
      this.humidity = weather.humidity;
      this.windSpeed = weather.windSpeed;
    }
  }
  
  // Экспортируем класс LocationWeatherDTO
  module.exports = LocationWeatherDTO;