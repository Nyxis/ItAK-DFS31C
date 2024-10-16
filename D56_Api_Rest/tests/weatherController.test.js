const request = require('supertest');
const express = require('express');
const weatherController = require('../controllers/weatherController');
const weatherService = require('../services/weatherService');

jest.mock('../services/weatherService');  // Ensure this is properly mocking

const app = express();
app.get('/weather', weatherController.getWeather);

describe('GET /weather', () => {
  it('should return weather data for a city', async () => {
    weatherService.getWeather.mockResolvedValue({  // Ensure the function is mocked
      temperature: 15,
      humidity: 80,
      wind_speed: 10,
      weather_descriptions: ['Sunny']
    });

    const res = await request(app).get('/weather?city=Lyon');
    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({
      location: 'Lyon',
      temperature: 15,
      humidity: 80,
      wind_speed: 10,
      description: 'Sunny'
    });
  });

  it('should return 500 if weather service fails', async () => {
    weatherService.getWeather.mockRejectedValue(new Error('Service failed'));  // Mock failure

    const res = await request(app).get('/weather?city=Lyon');
    expect(res.statusCode).toBe(500);
    expect(res.body).toEqual({ error: 'Unable to fetch weather data' });
  });
});