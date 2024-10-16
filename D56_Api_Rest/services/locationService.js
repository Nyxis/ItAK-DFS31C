const axios = require('axios');

class LocationService {
  constructor() {
    this.baseUrl = 'https://nominatim.openstreetmap.org';
  }

  async getLocationData(query = null, lat = null, lon = null) {
    try {
      let response;

      if (lat && lon) {
        response = await axios.get(`${this.baseUrl}/reverse`, {
          params: {
            lat: lat,
            lon: lon,
            format: 'json',
            addressdetails: 1,
          },
        });
      } else if (query) {
        response = await axios.get(`${this.baseUrl}/search`, {
          params: {
            q: query,
            format: 'json',
            addressdetails: 1,
            limit: 1,
          },
        });
      } else {
        throw new Error('No valid query or GPS coordinates provided');
      }

      return lat && lon ? response.data : response.data[0];
    } catch (error) {
      console.error('Error fetching location data:', error.message);
      throw new Error('Unable to fetch location data');
    }
  }
}

module.exports = LocationService;