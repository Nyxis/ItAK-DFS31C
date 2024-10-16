#!/usr/bin/env node

const axios = require('axios');
const commander = require('commander');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

const program = new commander.Command();

// Define CLI options
program
  .version('1.0.0')
  .description('CLI tool to query weather data from the API')
  .option('-c, --city <name>', 'City name to fetch weather data')
  .option('--lat <latitude>', 'Latitude for GPS weather data')
  .option('--lon <longitude>', 'Longitude for GPS weather data')
  .option('--auth', 'Get API token using API_KEY and SECRET_KEY from .env')
  .parse(process.argv);

const options = program.opts();

const BASE_URL = 'http://localhost:3000/APIexercice/V1';
const apiKey = process.env.API_KEY;
const secretKey = process.env.SECRET_KEY;

// Function to get a token
async function getToken() {
  try {
    const response = await axios.post(`${BASE_URL}/auth`, {
      providedApiKey: apiKey,
      providedSecretKey: secretKey,
    });
    return response.data.token;
  } catch (error) {
    console.error('Error fetching token:', error.response ? error.response.data : error.message);
    process.exit(1);
  }
}

// Function to fetch weather data using the token
async function fetchWeather(token, query) {
  try {
    const response = await axios.get(`${BASE_URL}/locationWeatherData`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
      params: query,
    });
    console.log('Weather Data:', JSON.stringify(response.data, null, 2));
  } catch (error) {
    console.error('Error fetching weather data:', error.response ? error.response.data : error.message);
  }
}

// Main logic
(async () => {
  if (options.auth) {
    // Authenticate and get a token
    const token = await getToken();
    console.log('Your API token:', token);
    return;
  }

  if (options.city || (options.lat && options.lon)) {
    // Get token to authenticate the query
    const token = await getToken();
    const query = {};

    if (options.city) {
      query.city = options.city;
    } else if (options.lat && options.lon) {
      query.lat = options.lat;
      query.lon = options.lon;
    }

    await fetchWeather(token, query);
  } else {
    console.log('Please provide a city name or GPS coordinates (--lat, --lon). Use --help for options.');
  }
})();