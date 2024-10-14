import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import assert from 'assert';
import axios from 'axios';
import express from 'express';
import formatRoute from '../routes/formatRoute.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, '..', '.env') });

console.log('OPENWEATHERMAP_API_KEY:', process.env.OPENWEATHERMAP_API_KEY);

const TEST_PORT = 3001;
const BASE_URL = `http://localhost:${TEST_PORT}/api/v1`;

async function runTests() {
    let server;

    try {
        const app = express();
        app.use('/api/v1', formatRoute(process.env.OPENWEATHERMAP_API_KEY));

        server = app.listen(TEST_PORT, () => console.log(`Test server running on port ${TEST_PORT}`));

        // Test location-weather endpoint
        const weatherResponse = await axios.get(`${BASE_URL}/location-weather?lat=40.7128&lon=-74.0060`);
        assert.strictEqual(weatherResponse.status, 200);
        assert.strictEqual(typeof weatherResponse.data.locationName, 'string');
        assert.strictEqual(weatherResponse.data.latitude, 40.7128);
        assert.strictEqual(weatherResponse.data.longitude, -74.0060);
        assert.strictEqual(typeof weatherResponse.data.temperature, 'number');
        assert.strictEqual(typeof weatherResponse.data.humidity, 'number');
        assert.strictEqual(typeof weatherResponse.data.windSpeed, 'number');

        console.log('All tests passed successfully!');
    } catch (error) {
        console.error('Test failed:', error.message);
    } finally {
        if (server) {
            server.close(() => {
                console.log('Test server closed');
            });
        }
    }
}

runTests();


