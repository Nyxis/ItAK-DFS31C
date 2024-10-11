const express = require('express');
const JsonResponse = require('./FORMAT/jsonResponse');
const XmlResponse = require('./FORMAT/xmlResponse');
const CsvResponse = require('./FORMAT/csvResponse');
const LocationService = require('./services/LocationService');
const app = express();
const PORT = process.env.PORT || 3000;

// Classe pour gérer les formats de réponse
class ResponseFormatter {
    constructor(formatter) {
        this.formatter = formatter;
    }

    sendResponse(data, res) {
        res.send(this.formatter.format(data));
    }
}

// Route pour la page de choix de format
app.get('/', (req, res) => {
    res.send(`
        <h1>Choisissez un format de réponse</h1>
        <form action="/getWeather" method="GET">
            <label for="locationType">Choisir le type de localisation :</label><br>
            <select id="locationType" name="locationType">
                <option value="city">Ville</option>
                <option value="coordinates">Coordonnées GPS</option>
            </select><br><br>
            <label for="location">Entrez le nom de la ville ou les coordonnées GPS (latitude,longitude) :</label><br>
            <input type="text" id="location" name="location"><br><br>
            <label for="format">Choisissez le format de réponse :</label><br>
            <select id="format" name="format">
                <option value="json">JSON</option>
                <option value="xml">XML</option>
                <option value="csv">CSV</option>
            </select><br><br>
            <input type="submit" value="Obtenir la météo">
        </form>
    `);
});

// Endpoint pour obtenir les données météo
app.get('/getWeather', async (req, res) => {
    const { locationType, location, format } = req.query;
    let data;
    let formatter;

    try {
        if (locationType === 'city') {
            data = await LocationService.getWeatherByCity(location);
        } else {
            const [latitude, longitude] = location.split(',');
            data = await LocationService.getWeatherByCoordinates(latitude, longitude);
        }

        // Choisir le format de réponse
        if (format === 'xml') {
            formatter = new ResponseFormatter(new XmlResponse());
        } else if (format === 'csv') {
            formatter = new ResponseFormatter(new CsvResponse());
        } else {
            formatter = new ResponseFormatter(new JsonResponse());
        }

        // Envoyer la réponse
        formatter.sendResponse(data, res);
    } catch (error) {
        res.status(500).send({ error: error.message });
    }
});

// Lancer le serveur
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
