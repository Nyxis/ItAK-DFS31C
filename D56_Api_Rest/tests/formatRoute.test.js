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

