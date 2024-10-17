// Импортируем необходимые модули
const axios = require('axios');
const config = require('../config');
const Location = require('../models/Location');

// Определяем класс OpenStreetMapService
class OpenStreetMapService {
  // Метод для получения данных о местоположении
  async getLocation(name) {
    try {
      // Отправляем GET-запрос к API OpenStreetMap
      const response = await axios.get(config.OPENSTREETMAP_API_URL, {
        params: { q: name, format: 'json', limit: 1 }
      });
      const data = response.data[0];
      
      // Создаем и возвращаем новый объект Location
      return new Location(
        name,
        data.lat,
        data.lon,
        data.display_name.split(',')[0],
        data.display_name.split(',').pop().trim()
      );
    } catch (error) {
      // Если произошла ошибка, выбрасываем исключение
      throw new Error(`Error fetching location data: ${error.message}`);
    }
  }
}

// Экспортируем класс OpenStreetMapService
module.exports = OpenStreetMapService;