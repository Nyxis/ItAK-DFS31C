const axios = require('axios');

class OpenStreetMapService {
    async getLocationByName(name) {
        try {
            const response = await axios.get('https://nominatim.openstreetmap.org/search', {
                params: {
                    q: name,
                    format: 'json',
                    limit: 1
                }
            });
            if (response.data.length > 0) {
                const { lat, lon, display_name } = response.data[0];
                return {
                    name: display_name,
                    latitude: parseFloat(lat),
                    longitude: parseFloat(lon)
                };
            } else {
                throw new Error('Location not found');
            }
        } catch (error) {
            console.error('Error fetching location from OpenStreetMap:', error.message);
            throw error;
        }
    }
}

module.exports = OpenStreetMapService;
