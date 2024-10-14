const express = require('express');
const jsonFormatter = require('../formatters/jsonFormatter');
const xmlFormatter = require('../formatters/xmlFormatter');
const csvFormatter = require('../formatters/csvFormatter');
const LocationWeatherBuilder = require('../builders/locationWeatherBuilder');

const router = express.Router();

/**
 * @api {get} /location-weather Données météo pour un lieu donné
 * @apiVersion 1.0.0
 * @apiName GetLocationWeather
 * @apiGroup LocationWeather
 *
 * @apiQuery {String} name Nom du lieu (ville, monument, etc.).
 * @apiQuery {String="json","xml","csv"} [format] Format de réponse souhaité (en plus de l'en-tête `Accept`)
 * @apiHeader {String} [Accept] Format de réponse souhaité (application/json, application/xml, text/csv)
 * @apiHeader {String} x-api-key Clé API nécessaire pour l'authentification
 * @apiHeader {String} Authorization Token JWT pour sécuriser la requête
 * 
 * @apiSuccess {String} name Nom du lieu.
 * @apiSuccess {String} city Ville du lieu.
 * @apiSuccess {Number} latitude Latitude du lieu.
 * @apiSuccess {Number} longitude Longitude du lieu.
 * @apiSuccess {Number} temperature Température en °C.
 * @apiSuccess {Number} humidite Humidité en %.
 * @apiSuccess {Number} vitesseVent Vitesse du vent en m/s.
 */
router.get('/', async (req, res) => {
    const locationName = req.query.name;

    if (!locationName) {
        res.status(400).send('Le paramètre "name" est requis.');
        return;
    }

    const formatQuery = req.query.format;
    const acceptHeader = req.headers.accept || '';

    const formatters = {
        'json': {
            formatter: jsonFormatter,
            contentType: 'application/json'
        },
        'xml': {
            formatter: xmlFormatter,
            contentType: 'application/xml'
        },
        'csv': {
            formatter: csvFormatter,
            contentType: 'text/csv'
        }
    };

    let format = null;

    // format si présent dans l'url sinon header Accept sinon json par défaut
    if (formatQuery && formatters[formatQuery.toLowerCase()]) {
        format = formatQuery.toLowerCase();
    } else {
        const supportedFormats = {
            'application/json': 'json',
            'application/xml': 'xml',
            'text/csv': 'csv'
        };
        format = Object.keys(supportedFormats).find((fmt) => acceptHeader.includes(fmt));
        if (format) {
            format = supportedFormats[format];
        }
    }

    if (!format) {
        format = 'json';
    }

    try {
        // builder LocationWeatherData
        const builder = new LocationWeatherBuilder();
        const locationWeatherData = await builder.declare().name(locationName).create();

        // Formater la réponse
        const { formatter, contentType } = formatters[format];
        res.set('Content-Type', contentType);
        res.send(formatter.format(locationWeatherData.toJSON()));
    } catch (error) {
        console.error('Erreur lors de la récupération des données:', error.message);
        res.status(500).send('Erreur lors de la récupération des données.');
    }
});

module.exports = router;
