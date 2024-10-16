const request = require('supertest');
const express = require('express');
const xmlController = require('../controllers/xmlController');

const app = express();
app.get('/xml', xmlController.getXml);

describe('GET /xml', () => {
  it('should return XML data with correct headers', async () => {
    const res = await request(app).get('/xml');
    expect(res.statusCode).toBe(200);
    expect(res.headers['content-type']).toContain('application/xml');  // Updated to use toContain
    expect(res.headers['api-version']).toBe('1.0');
    expect(res.text).toBe('<hello>world</hello>');
  });
});