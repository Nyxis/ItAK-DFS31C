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

    // New method to get coordinates by city name
    async getCityCoordinates(city) {
        try {
            const response = await axios.get(`${this.baseURL}/search`, {
                params: {
                    q: city,
                    format: 'json',
                    limit: 1
                }
            });
            if (response.data.length === 0) {
                throw new Error('City not found');
            }
            return response.data[0];  // Return the first result (most relevant)
        } catch (error) {
            console.error('Error fetching city coordinates:', error.response ? error.response.data : error.message);
            throw new Error('Failed to fetch city coordinates');
        }
    }
}

export default OpenStreetMapClient;

