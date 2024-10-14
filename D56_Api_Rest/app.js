const express = require('express');
const helloRoute = require('./routes/hello');
const locationWeatherRoute = require('./routes/locationWeather');
const homepageRouter = require('./routes/homepage');
const authMiddleware = require('./middlewares/authMiddleware');

require('dotenv').config();

const app = express();
const port = 3000;

app.use('/api/v1', helloRoute);
app.use('/api/v1', homepageRouter);
app.use('/api/v1/location-weather', authMiddleware, locationWeatherRoute);

app.listen(port, () => {
    console.log(`Serveur démarré sur le port ${port}`);
});

module.exports = app;