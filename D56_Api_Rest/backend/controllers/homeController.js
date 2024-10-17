const jwt = require('jsonwebtoken');
const config = require('../config');

class HomeController {
  static async getHome(req, res) {
    const { apiKey, secretKey } = req.query;

    if (!apiKey || !secretKey) {
      return res.status(400).json({ error: 'API key and secret key are required' });
    }

    if (apiKey !== config.API_KEY || secretKey !== config.SECRET_KEY) {
      return res.status(401).json({ error: 'Invalid API key or secret key' });
    }

    const token = jwt.sign({ apiKey }, config.JWT_SECRET, { expiresIn: '1h' });

    res.json({
      message: 'Welcome to the Weather API',
      token,
      _links: {
        self: { href: '/api/v1', method: 'GET' },
        authenticate: { 
          href: '/api/v1/auth', 
          method: 'POST',
          description: 'Authenticate and get a new token'
        },
        helloWorld: { 
          href: '/api/v1/hello', 
          method: 'GET',
          description: 'Get a "Hello World" message in various formats'
        },
        weatherData: { 
          href: '/api/v1/weather', 
          method: 'GET',
          description: 'Get weather data for a specific location',
          parameters: [
            { name: 'location', type: 'string', required: true, in: 'query' }
          ]
        }
      },
      apiVersion: req.apiVersion
    });
  }
}

module.exports = HomeController;