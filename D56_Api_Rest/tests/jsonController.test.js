const request = require('supertest');
const express = require('express');
const jsonController = require('../controllers/jsonController');

const app = express();
app.get('/json', jsonController.getJson);

describe('GET /json', () => {
  it('should return JSON data with correct headers', async () => {
    const res = await request(app).get('/json');
    expect(res.statusCode).toBe(200);
    expect(res.headers['api-version']).toBe('1.0');
    expect(res.body).toEqual({ hello: 'world' });
  });
});