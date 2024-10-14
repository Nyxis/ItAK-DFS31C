const express = require('express');
const jwt = require('jsonwebtoken');
const router = express.Router();

require('dotenv').config();
const secretKey = process.env.SECRET_KEY;

/**
 * @api {get} /homepage Accéder à la homepage de l'API
 * @apiVersion 1.0.0
 * @apiName GetHomepage
 * @apiGroup Homepage
 *
 * @apiQuery {String} apiKey Clé API fournie par le client.
 * @apiQuery {String} secretKey Clé secrète fournie par le client.
 * @apiQuery {String="v1"} version Version de l'API à utiliser.
 *
 * @apiSuccess {String} message Message de bienvenue à l'API.
 * @apiSuccess {String} token Token JWT à utiliser pour les requêtes suivantes.
 * @apiSuccess {Object} links Liens hypermédias disponibles.
 * @apiSuccess {Object} links.weatherData Lien pour accéder aux données météo.
 * @apiSuccess {String} links.weatherData.href URL pour obtenir les données météo.
 * @apiSuccess {String} links.weatherData.description Description du lien et méthode d'utilisation.
 *
 * @apiSuccessExample {json} Exemple de réponse:
 *     HTTP/1.1 200 OK
 *     {
 *       "message": "Bienvenue sur l'API ! Utilisez ce token pour vous authentifier sur les endpoints.",
 *       "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
 *       "links": {
 *         "weatherData": {
 *           "href": "/api/v1/location-weather",
 *           "description": "Lien pour obtenir les données météo d'un lieu donné. Requiert le token dans l'en-tête Authorization."
 *         }
 *       }
 *     }
 */
router.get('/homepage', (req, res) => {
    const { apiKey, secretKey: clientSecretKey, version } = req.query;

    // Vérif paramètres
    if (!apiKey || !clientSecretKey || !version) {
        return res.status(400).json({
            error: 'Veuillez fournir une clé API, un secret et la version de l\'API.'
        });
    }

    try {
        // Génération du token
        const token = jwt.sign({ apiKey, version }, secretKey, { expiresIn: '1h' });

        // Lien hypermédia avec description
        const links = {
            weatherData: {
                href: `/api/${version}/location-weather`,
                description: "Lien pour obtenir les données météo d'un lieu donné. Requiert le token dans l'en-tête Authorization."
            }
        };

        // Réponse JSON avec message de succès, token et liens
        return res.json({
            message: 'Bienvenue sur l\'API ! Utilisez ce token pour vous authentifier sur les endpoints.',
            token,
            links
        });
    } catch (error) {
        return res.status(500).json({
            error: 'Erreur lors de la génération du token.'
        });
    }
});

module.exports = router;
