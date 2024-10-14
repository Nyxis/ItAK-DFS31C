const express = require('express');
const helloRoute = require('./routes/hello');
const locationWeatherRoute = require('./routes/locationWeather');


require('dotenv').config();

const app = express();
const port = 3000;

app.use('/api/v1', helloRoute);
app.use('/api/v1', locationWeatherRoute);


app.listen(port, () => {
    console.log(`Serveur démarré sur le port ${port}`);
});

module.exports = app;