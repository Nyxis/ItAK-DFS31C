const fetch = require('node-fetch');
const DonneeMeteo = require('./modeles/DonneMeteo');
const { config } = require('./config');

class ServiceMeteo {
  constructor() {
    this.baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  }

  async getWeatherData(latitude, longitude) {
    console.log(`Tentative de récupération des données météo pour lat:${latitude}, lon:${longitude}`);
    
    if (!config.openWeatherMapApiKey) {
      console.error('La clé API OpenWeatherMap n\'est pas définie');
      throw new Error('La clé API OpenWeatherMap n\'est pas définie');
    }

    try {
      const url = new URL(this.baseUrl);
      url.searchParams.append('lat', latitude);
      url.searchParams.append('lon', longitude);
      url.searchParams.append('appid', config.openWeatherMapApiKey);
      url.searchParams.append('units', 'metric');

      console.log(`URL de l'API: ${url.toString()}`);

      const response = await fetch(url.toString());
      console.log(`Statut de la réponse: ${response.status}`);

      if (!response.ok) {
        const errorBody = await response.text();
        console.error(`Erreur HTTP: ${response.status}. Corps de la réponse:`, errorBody);
        throw new Error(`Erreur HTTP: ${response.status}`);
      }

      const data = await response.json();
      console.log('Données reçues de l\'API:', JSON.stringify(data, null, 2));

      const { main, wind } = data;
      return new DonneeMeteo(
        main.temp,
        main.humidity,
        wind.speed
      );
    } catch (error) {
      console.error('Erreur détaillée lors de la récupération des données météo:', error);
      throw error;
    }
  }
}

module.exports = ServiceMeteo;