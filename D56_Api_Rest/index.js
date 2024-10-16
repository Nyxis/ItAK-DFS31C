const fs = require('fs');
const dotenv = require('dotenv');
const crypto = require('crypto');
const path = require('path');

// Load existing .env variables
dotenv.config();

const envPath = path.resolve(__dirname, '.env');
let envVariables = {
    OPENWEATHER_API_KEY: process.env.OPENWEATHER_API_KEY || 'my_openweather_key',
    API_KEY: process.env.API_KEY || crypto.randomBytes(16).toString('hex'),  // Generate 32-character key
    SECRET_KEY: process.env.SECRET_KEY || crypto.randomBytes(32).toString('hex') // Generate 64-character secret
};

// Write .env file only if API_KEY, SECRET_KEY, or OPENWEATHER_API_KEY is missing
if (!process.env.API_KEY || !process.env.SECRET_KEY || !process.env.OPENWEATHER_API_KEY) {
    const updatedEnv = `OPENWEATHER_API_KEY=${envVariables.OPENWEATHER_API_KEY}\nAPI_KEY=${envVariables.API_KEY}\nSECRET_KEY=${envVariables.SECRET_KEY}\n`;

    fs.writeFileSync(envPath, updatedEnv);
    console.log('Generated missing API/Secret keys and stored them in .env');
}

const express = require('express');
const app = express();
const port = 3000;
const version = 'V1';
const bodyParser = require('body-parser');

app.use(bodyParser.json()); // To parse incoming JSON data

// Middleware to serve static files
app.use(express.static('public'));

// Serve the documentation
app.use('/documentation', (req, res) => {
    res.sendFile(path.join(__dirname, 'DOC', 'find', 'documentation.md'));
});

// Serve the main page (index.html)
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Routes setup
const homeRoutes = require('./routes/home');
const jsonRoutes = require('./routes/json');
const xmlRoutes = require('./routes/xml');
const csvRoutes = require('./routes/csv');
const weatherRoutes = require('./routes/weather');
const locationRoutes = require('./routes/location');
const locationWeatherDataRoutes = require('./routes/locationWeatherData');

app.use(`/APIexercice/${version}`, homeRoutes);
app.use(`/APIexercice/${version}`, jsonRoutes);
app.use(`/APIexercice/${version}`, xmlRoutes);
app.use(`/APIexercice/${version}`, csvRoutes);
app.use(`/APIexercice/${version}`, weatherRoutes);
app.use(`/APIexercice/${version}`, locationRoutes);
app.use(`/APIexercice/${version}`, locationWeatherDataRoutes);

// Start server
app.listen(port, () => {
    console.log(`Exercice app listening on port ${port}`);
});