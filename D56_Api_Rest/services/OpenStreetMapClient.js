import axios from 'axios';

class OpenStreetMapClient {
    constructor() {
        this.baseURL = 'https://nominatim.openstreetmap.org';
    }

    async getLocationInfo(lat, lon) {
        try {
            const response = await axios.get(`${this.baseURL}/reverse`, {
                params: {
                    lat: lat,
                    lon: lon,
                    format: 'json'
                }
            });
            console.log('OpenStreetMap API Response:', JSON.stringify(response.data, null, 2));
            return response.data;
        } catch (error) {
            console.error('Error fetching location data:', error.response ? error.response.data : error.message);
            throw new Error('Failed to fetch location data');
        }
    }
}

export default OpenStreetMapClient;

