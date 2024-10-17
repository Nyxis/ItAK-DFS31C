const express = require('express');
const HelloWorldController = require('./controllers/helloWorldController');
const LocationWeatherController = require('./controllers/locationWeatherController');
const HomeController = require('./controllers/homeController');
const AuthController = require('./controllers/authController');
const authMiddleware = require('./middleware/authMiddleware');

const router = express.Router();

// API home page
router.get('/api/v1', HomeController.getHome);

// Аутентификация
router.post('/api/v1/auth', AuthController.login);

// Hello World route, защищенный аутентификацией
router.get('/api/v1/hello', authMiddleware, HelloWorldController.getHelloWorld);

// Weather data route, также защищенный аутентификацией
router.get('/api/v1/weather', authMiddleware, LocationWeatherController.getLocationWeather);

module.exports = router;