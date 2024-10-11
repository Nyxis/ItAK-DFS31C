const request = require('supertest');
const { app, closeServer } = require('../app');

describe('Format API', () => {
    afterAll(async () => {
        await closeServer();
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
    });

    describe('Location Weather API', () => {
        it('should return location weather data in a flat structure', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=40.7128&lon=-74.0060');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('application/json');
            expect(res.body).toHaveProperty('locationName');
            expect(res.body).toHaveProperty('latitude');
            expect(res.body).toHaveProperty('longitude');
            expect(res.body).toHaveProperty('cityName');
            expect(res.body).toHaveProperty('country');
            expect(res.body).toHaveProperty('temperature');
            expect(res.body).toHaveProperty('humidity');
            expect(res.body).toHaveProperty('windSpeed');
            expect(res.body).toHaveProperty('timestamp');

            // Check specific values
            expect(res.body.latitude).toBe(40.7128);
            expect(res.body.longitude).toBe(-74.0060);
            expect(typeof res.body.locationName).toBe('string');
            expect(typeof res.body.cityName).toBe('string');
            expect(typeof res.body.country).toBe('string');
            expect(typeof res.body.temperature).toBe('number');
            expect(typeof res.body.humidity).toBe('number');
            expect(typeof res.body.windSpeed).toBe('number');
            expect(typeof res.body.timestamp).toBe('string');
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
            expect(res.body.error).toBe('Latitude is required');
        });

        it('should return 400 if longitude is missing', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=40.7128');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Longitude is required');
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
    });
});

