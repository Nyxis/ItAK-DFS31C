# API_Documentation.md

```md
# Format API Documentation

## Base URL

All URLs referenced in the documentation have the following base:

\`\`\`
http://localhost:3000/api/v1
\`\`\`

## Endpoints

1. [GET /format/:format](#1-get-formatformat)
2. [GET /location-weather](#2-get-location-weather)

---

### 1. GET /format/:format

Returns a simple object in the specified format.

#### Request

\`\`\`
GET /format/:format
\`\`\`

Where `:format` can be one of:
- `json`
- `xml`
- `csv`

#### Response

- **Status Code**: 200 OK
- **Content-Type**: Depends on the requested format

##### JSON Format
- **Content-Type**: application/json

\`\`\`json
{
  "hello": "world"
}
\`\`\`

##### XML Format
- **Content-Type**: application/xml

\`\`\`xml
<hello>world</hello>
\`\`\`

##### CSV Format
- **Content-Type**: text/csv

\`\`\`
hello
world
\`\`\`

#### Error Response

If an unsupported format is requested:

- **Status Code**: 400 Bad Request
- **Content-Type**: application/json

\`\`\`json
{
  "error": "Unsupported format"
}
\`\`\`

---

### 2. GET /location-weather

Returns weather information for a given location.

#### Request

\`\`\`
GET /location-weather?lat={latitude}&lon={longitude}
\`\`\`

#### Query Parameters

- `lat` (required): Latitude of the location (float between -90 and 90)
- `lon` (required): Longitude of the location (float between -180 and 180)

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/json

\`\`\`json
{
  "locationName": "Mock Location",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "cityName": "MockCity",
  "country": "MockCountry",
  "temperature": 25.5,
  "humidity": 60,
  "windSpeed": 10,
  "timestamp": "2024-10-11T12:00:00Z"
}
\`\`\`

#### Error Responses

1. Missing both latitude and longitude:
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Both latitude and longitude are required"}
   \`\`\`

2. Missing latitude:
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Latitude is required"}
   \`\`\`

3. Missing longitude:
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Longitude is required"}
   \`\`\`

4. Invalid latitude (not between -90 and 90):
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Invalid latitude. Must be a number between -90 and 90."}
   \`\`\`

5. Invalid longitude (not between -180 and 180):
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Invalid longitude. Must be a number between -180 and 180."}
   \`\`\`

## Data Models

All models are now under the `Weather` namespace.

### Weather.GPS
- `latitude`: float
- `longitude`: float

### Weather.City
- `name`: string

### Weather.Location
- `name`: string
- `coordinates`: Weather.GPS
- `city`: Weather.City
- `country`: string

### Weather.WeatherData
- `temperature`: float
- `humidity`: float
- `windSpeed`: float

### Weather.LocationWeatherData (DTO)
- `locationName`: string
- `latitude`: float
- `longitude`: float
- `cityName`: string
- `country`: string
- `temperature`: float
- `humidity`: float
- `windSpeed`: float
- `timestamp`: string (ISO8601 format)

## Versioning

This API follows Semantic Versioning. The current version is v1. Any breaking changes will be introduced in a new major version (e.g., v2).


```

# app.js

```js
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import express from 'express';
import formatRoute from './routes/formatRoute.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, '.env') });

console.log('OPENWEATHERMAP_API_KEY:', process.env.OPENWEATHERMAP_API_KEY);

const app = express();
const port = process.env.PORT || 3000;

app.use('/api/v1', formatRoute(process.env.OPENWEATHERMAP_API_KEY));

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

export { app };


```

# controllers/FormatController.js

```js
import Weather from '../models.js';
import OpenStreetMapClient from '../services/OpenStreetMapClient.js';
import OpenWeatherMapClient from '../services/OpenWeatherMapClient.js';

class FormatController {
    constructor(apiKey) {
        console.log('API Key used in FormatController:', apiKey);
        this.openStreetMapClient = new OpenStreetMapClient();
        this.openWeatherMapClient = new OpenWeatherMapClient(apiKey);
    }

    static getFormat(req, res) {
        const format = req.params.format;
        const formatHandlers = {
            'json': () => res.json({ hello: 'world' }),
            'xml': () => res.type('application/xml').send('<hello>world</hello>'),
            'csv': () => res.type('text/csv').send('hello\nworld\n')
        };

        if (formatHandlers.hasOwnProperty(format)) {
            formatHandlers[format]();
        } else {
            res.status(400).json({ error: 'Unsupported format' });
        }
    }

    async getLocationWeather(req, res) {
        const { lat, lon } = req.query;

        if (!lat || !lon) {
            return res.status(400).json({ error: 'Both latitude and longitude are required' });
        }

        const latFloat = parseFloat(lat);
        const lonFloat = parseFloat(lon);

        if (isNaN(latFloat) || latFloat < -90 || latFloat > 90) {
            return res.status(400).json({ error: 'Invalid latitude. Must be a number between -90 and 90.' });
        }
        if (isNaN(lonFloat) || lonFloat < -180 || lonFloat > 180) {
            return res.status(400).json({ error: 'Invalid longitude. Must be a number between -180 and 180.' });
        }

        try {
            const [locationData, weatherData] = await Promise.all([
                this.openStreetMapClient.getLocationInfo(latFloat, lonFloat),
                this.openWeatherMapClient.getWeatherData(latFloat, lonFloat)
            ]);

            console.log('Location Data:', JSON.stringify(locationData, null, 2));
            console.log('Weather Data:', JSON.stringify(weatherData, null, 2));

            const gps = new Weather.GPS(latFloat, lonFloat);
            const city = new Weather.City(locationData.address?.city || locationData.address?.town || locationData.address?.village || 'Unknown');
            const location = new Weather.Location(locationData.display_name, gps, city, locationData.address?.country || 'Unknown');

            const weather = new Weather.WeatherData(
                weatherData.main.temp,
                weatherData.main.humidity,
                weatherData.wind.speed
            );

            const locationWeatherData = new Weather.LocationWeatherData(location, weather);

            res.status(200).json(locationWeatherData);
        } catch (error) {
            console.error('Error fetching location or weather data:', error);

            let errorMessage = 'Failed to fetch location or weather data';
            let statusCode = 500;

            if (error.response) {
                statusCode = error.response.status;
                errorMessage += `: ${error.response.data.message || error.response.statusText}`;
            } else if (error.request) {
                errorMessage += ': No response received from the server';
            } else {
                errorMessage += `: ${error.message}`;
            }

            res.status(statusCode).json({
                error: errorMessage,
                details: process.env.NODE_ENV === 'development' ? error.stack : undefined
            });
        }
    }
}

export default FormatController;


```

# models.js

```js
const Weather = {};

Weather.GPS = class GPS {
    constructor(latitude, longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }
};

Weather.City = class City {
    constructor(name) {
        this.name = name;
    }
};

Weather.Location = class Location {
    constructor(name, coordinates, city, country) {
        this.name = name;
        this.coordinates = coordinates;
        this.city = city;
        this.country = country;
    }
};

Weather.WeatherData = class WeatherData {
    constructor(temperature, humidity, windSpeed) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
    }
};

Weather.LocationWeatherData = class LocationWeatherData {
    constructor(location, weatherData) {
        this.locationName = location.name;
        this.latitude = location.coordinates.latitude;
        this.longitude = location.coordinates.longitude;
        this.cityName = location.city.name;
        this.country = location.country;
        this.temperature = weatherData.temperature;
        this.humidity = weatherData.humidity;
        this.windSpeed = weatherData.windSpeed;
        this.timestamp = new Date().toISOString();
    }
};

export default Weather;


```

# package.json

```json
{
  "name": "api-format-demo",
  "version": "1.0.0",
  "main": "app.js",
  "type": "module",
  "scripts": {
    "start": "node app.js",
    "dev": "nodemon app.js",
    "test": "node tests/integration.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "description": "A simple API that returns data in different formats and fetches weather data",
  "dependencies": {
    "axios": "^1.7.7",
    "dotenv": "^16.4.5",
    "express": "^4.21.1"
  },
  "devDependencies": {
    "nodemon": "^3.1.7",
    "supertest": "^6.3.4"
  }
}

```

# README.md

```md
# Weather API Integration Project

This project demonstrates the integration of OpenWeatherMap and OpenStreetMap APIs to provide weather and location information.

## Features

- Fetch current weather data for a given latitude and longitude
- Retrieve location information for coordinates
- Combine weather and location data into a single response
- Support for different output formats (JSON, XML, CSV)

## Prerequisites

- Node.js (version 14 or higher)
- npm (Node Package Manager)
- OpenWeatherMap API key (free tier)

## Installation

1. Clone the repository:
   \`\`\`
   git clone https://github.com/your-username/weather-api-integration.git
   cd weather-api-integration
   \`\`\`

2. Install dependencies:
   \`\`\`
   npm install
   \`\`\`

3. Create a `.env` file in the root directory and add your OpenWeatherMap API key:
   \`\`\`
   OPENWEATHERMAP_API_KEY=your_api_key_here
   \`\`\`

## Usage

1. Start the server:
   \`\`\`
   npm start
   \`\`\`

2. Access the API endpoints:
   - Get weather and location data:
     \`\`\`
     http://localhost:3000/api/v1/location-weather?lat=40.7128&lon=-74.0060
     \`\`\`
   - Get data in different formats:
     \`\`\`
     http://localhost:3000/api/v1/format/json
     http://localhost:3000/api/v1/format/xml
     http://localhost:3000/api/v1/format/csv
     \`\`\`

## Running Tests

To run the integration tests:

\`\`\`
npm test
\`\`\`

## API Documentation

### GET /api/v1/location-weather

Retrieves weather and location data for given coordinates.

Query Parameters:
- `lat`: Latitude (required)
- `lon`: Longitude (required)

Example Response:
\`\`\`json
{
  "locationName": "New York City Hall, 260, Broadway, Lower Manhattan, Civic Center, Manhattan, New York County, City of New York, New York, 10000, United States",
  "latitude": 40.7128,
  "longitude": -74.006,
  "cityName": "City of New York",
  "country": "United States",
  "temperature": 11.86,
  "humidity": 87,
  "windSpeed": 1.34,
  "timestamp": "2024-10-14T12:34:56.789Z"
}
\`\`\`

### GET /api/v1/format/:format

Returns a simple "hello world" message in the specified format.

Path Parameters:
- `format`: Can be "json", "xml", or "csv"

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

```

# routes/formatRoute.js

```js
import express from 'express';
import FormatController from '../controllers/FormatController.js';

export default function(apiKey) {
    const router = express.Router();
    const formatController = new FormatController(apiKey);

    router.get('/format/:format', FormatController.getFormat);
    router.get('/location-weather', (req, res) => formatController.getLocationWeather(req, res));

    return router;
}


```

# services/OpenStreetMapClient.js

```js
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


```

# services/OpenWeatherMapClient.js

```js
import axios from 'axios';

class OpenWeatherMapClient {
    constructor(apiKey) {
        this.apiKey = apiKey;
        this.baseURL = 'https://api.openweathermap.org/data/2.5';
    }

    async getWeatherData(lat, lon) {
        try {
            console.log(`Making request with API key: ${this.apiKey}`);
            const response = await axios.get(`${this.baseURL}/weather`, {
                params: {
                    lat: lat,
                    lon: lon,
                    appid: this.apiKey,
                    units: 'metric'
                }
            });
            console.log('Weather API Response:', JSON.stringify(response.data, null, 2));
            return response.data;
        } catch (error) {
            console.error('Error fetching weather data:', error.response ? error.response.data : error.message);
            console.error('Full error object:', JSON.stringify(error, null, 2));
            throw new Error('Failed to fetch weather data');
        }
    }
}

export default OpenWeatherMapClient;


```

# tests/formatRoute.test.js

```js
const request = require('supertest');
const { app, closeServer } = require('../app');
const OpenStreetMapClient = require('../services/OpenStreetMapClient');
const OpenWeatherMapClient = require('../services/OpenWeatherMapClient');

jest.mock('../services/OpenStreetMapClient');
jest.mock('../services/OpenWeatherMapClient');

describe('Format API', () => {
    afterAll(async () => {
        await closeServer();
    });

    beforeEach(() => {
        jest.resetAllMocks();
    });

    describe('Basic Format Endpoints', () => {
        it('should return JSON format', async () => {
            const res = await request(app).get('/api/v1/format/json');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('application/json');
            expect(res.body).toEqual({ hello: 'world' });
        });

        it('should return XML format', async () => {
            const res = await request(app).get('/api/v1/format/xml');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('application/xml');
            expect(res.text).toBe('<hello>world</hello>');
        });

        it('should return CSV format', async () => {
            const res = await request(app).get('/api/v1/format/csv');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('text/csv');
            expect(res.text).toBe('hello\nworld\n');
        });

        it('should return 400 for unsupported format', async () => {
            const res = await request(app).get('/api/v1/format/unsupported');
            expect(res.statusCode).toBe(400);
            expect(res.body).toEqual({ error: 'Unsupported format' });
        });
    });

    describe('Location Weather API', () => {
        it('should return location weather data in a flat structure', async () => {
            OpenStreetMapClient.prototype.getLocationInfo.mockResolvedValue({
                display_name: 'New York City',
                address: {
                    city: 'New York',
                    country: 'United States'
                }
            });

            OpenWeatherMapClient.prototype.getWeatherData.mockResolvedValue({
                main: {
                    temp: 20,
                    humidity: 65
                },
                wind: {
                    speed: 5
                }
            });

            const res = await request(app).get('/api/v1/location-weather?lat=40.7128&lon=-74.0060');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('application/json');
            expect(res.body).toMatchObject({
                locationName: 'New York City',
                latitude: 40.7128,
                longitude: -74.0060,
                cityName: 'New York',
                country: 'United States',
                temperature: 20,
                humidity: 65,
                windSpeed: 5
            });
            expect(res.body).toHaveProperty('timestamp');
        });

        it('should return 400 if both latitude and longitude are missing', async () => {
            const res = await request(app).get('/api/v1/location-weather');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Both latitude and longitude are required');
        });

        it('should return 400 if latitude is missing', async () => {
            const res = await request(app).get('/api/v1/location-weather?lon=-74.0060');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Both latitude and longitude are required');
        });

        it('should return 400 if longitude is missing', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=40.7128');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Both latitude and longitude are required');
        });

        it('should return 400 if latitude is invalid', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=91&lon=-74.0060');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Invalid latitude. Must be a number between -90 and 90.');
        });

        it('should return 400 if longitude is invalid', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=40.7128&lon=181');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Invalid longitude. Must be a number between -180 and 180.');
        });

        it('should return 500 if API calls fail', async () => {
            OpenStreetMapClient.prototype.getLocationInfo.mockRejectedValue(new Error('API error'));

            const res = await request(app).get('/api/v1/location-weather?lat=40.7128&lon=-74.0060');
            expect(res.statusCode).toBe(500);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Failed to fetch location or weather data');
        });
    });
});


```

# tests/integration.js

```js
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



```

