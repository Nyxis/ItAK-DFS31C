const axios = require('axios'); // Assurez-vous d'avoir axios installé

class LocationService {
    static async getWeatherByCity(city) {
        try {
            // Remplacez l'URL par celle de l'API météorologique que vous utilisez
            const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=1c292887580d30e65ae3a7764df0f72c&units=metric`);
            const data = response.data;
            // Créez et retournez un DTO contenant les données nécessaires
            return {
                country: data.sys.country,
                latitude: data.coord.lat,
                longitude: data.coord.lon,
                temperature: data.main.temp,
                weatherDescription: data.weather[0].description,
                windSpeed: data.wind.speed,
                humidity: data.main.humidity
            };
        } catch (error) {
            throw new Error('Erreur lors de la récupération des données météo par ville');
        }
    }

    static async getWeatherByCoordinates(latitude, longitude) {
        try {
            // Remplacez l'URL par celle de l'API météorologique que vous utilisez
            const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=1c292887580d30e65ae3a7764df0f72c&units=metric`);
            const data = response.data;
            // Créez et retournez un DTO contenant les données nécessaires
            return {
                country: data.sys.country,
                latitude: data.coord.lat,
                longitude: data.coord.lon,
                temperature: data.main.temp,
                weatherDescription: data.weather[0].description,
                windSpeed: data.wind.speed,
                humidity: data.main.humidity
            };
        } catch (error) {
            throw new Error('Erreur lors de la récupération des données météo par coordonnées');
        }
    }
}

module.exports = LocationService;
