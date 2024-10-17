require('dotenv').config();

module.exports = {
  PORT: process.env.PORT || 3001,
  OPENWEATHERMAP_API_KEY: process.env.OPENWEATHERMAP_API_KEY,
  OPENSTREETMAP_API_URL: 'https://nominatim.openstreetmap.org/search',
  OPENWEATHERMAP_API_URL: 'https://api.openweathermap.org/data/2.5/weather',
  JWT_SECRET: process.env.JWT_SECRET,
  API_KEY: process.env.API_KEY,
  API_SECRET: process.env.API_SECRET
};