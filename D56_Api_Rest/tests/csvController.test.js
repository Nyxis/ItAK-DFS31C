const request = require('supertest');
const express = require('express');
const csvController = require('../controllers/csvController');

const app = express();
app.get('/csv', csvController.getCsv);

describe('GET /csv', () => {
  it('should return CSV data with correct headers', async () => {
    const res = await request(app).get('/csv');
    expect(res.statusCode).toBe(200);
    expect(res.headers['content-type']).toContain('text/csv');
    expect(res.headers['api-version']).toBe('1.0');
    expect(res.text).toBe('hello\nworld');
  });
});