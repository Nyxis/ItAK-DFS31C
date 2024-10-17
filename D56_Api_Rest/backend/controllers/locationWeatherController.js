const OpenStreetMapService = require('../services/OpenStreetMapService');
const OpenWeatherMapService = require('../services/OpenWeatherMapService');
const LocationWeatherDTO = require('../dto/LocationWeatherDTO');

class LocationWeatherController {
  constructor() {
    this.openStreetMapService = new OpenStreetMapService();
    this.openWeatherMapService = new OpenWeatherMapService();

    // Привязываем метод к контексту
    this.getLocationWeather = this.getLocationWeather.bind(this);
  }

  async getLocationWeather(req, res) {
    try {
      console.log('Получен запрос на данные о погоде');
      const locationName = req.query.location;
      
      if (!locationName) {
        console.log('Отсутствует местоположение в запросе');
        return res.status(400).json({ error: 'Требуется указать местоположение' });
      }

      console.log(`Получение погоды для: ${locationName}`);

      const location = await this.openStreetMapService.getLocation(locationName);
      console.log('Данные о местоположении:', location);

      const weather = await this.openWeatherMapService.getWeather(location.latitude, location.longitude);
      console.log('Данные о погоде:', weather);

      const dto = new LocationWeatherDTO(location, weather);

      res.json(dto);
    } catch (error) {
      console.error('Ошибка в getLocationWeather:', error);
      res.status(500).json({ error: error.message || 'Внутренняя ошибка сервера' });
    }
  }
}

module.exports = new LocationWeatherController();
