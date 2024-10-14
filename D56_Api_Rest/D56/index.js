const express = require('express');
const xml2js = require('xml2js');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const { Lieu, Coordonnees, Ville, Pays } = require('./modeles/Lieu.js');
const DonneeLieuMeteo = require('./dto/DonneeLieuMeteo.js');
const WeatherService = require('./ServiceMeteo.js');
const { setApiKey } = require('./config');

// Récupérer la clé API depuis les arguments de ligne de commande
const apiKey = process.argv[2];

if (!apiKey) {
  console.error('Veuillez fournir une clé API OpenWeatherMap en argument');
  process.exit(1);
}

setApiKey(apiKey);

const app = express();
const port = 3000;

const verifierEnTeteAccept = (req, res, next) => {
  const enTeteAccept = req.get('Accept');
  if (enTeteAccept === 'application/json' || enTeteAccept === 'text/csv' || enTeteAccept === 'application/xml') {
    req.formatAccepte = enTeteAccept;
    next();
  } else {
    res.status(406).send('Format non supporté. Utilisez application/json, text/csv ou application/xml.');
  }
};

const formaterReponse = (format, donnees) => {
  if (format === 'application/json') {
    return JSON.stringify(donnees);
  }
  if (format === 'text/csv') {
    let resultat = '';
    for (let [cle, valeur] of Object.entries(donnees)) {
      if (resultat !== '') {
        resultat += '\n';
      }
      resultat += `${cle},${valeur}`;
    }
    return resultat;
  }
  if (format === 'application/xml') {
    const constructeur = new xml2js.Builder();
    return constructeur.buildObject(donnees);
  }
  throw new Error('Format non supporté');
};

const weatherService = new WeatherService();

const optionsSwagger = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'API Tuto Multi-format',
      version: '1.0.0',
      description: 'Une API démonstrative avec deux endpoints : un simple "Hello World" en JSON, CSV, et XML et des données météo.',
    },
  },
  apis: ['./index.js'],
};

const specSwagger = swaggerJsdoc(optionsSwagger);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specSwagger));

/**
 * @swagger
 * /api/v1/bonjour:
 *   get:
 *     summary: Renvoie "bonjour monde" dans le format spécifié
 *     description: Renvoie un objet contenant "bonjour monde" dans le format spécifié par l'en-tête Accept
 *     produces:
 *       - application/json
 *       - text/csv
 *       - application/xml
 *     responses:
 *       200:
 *         description: Succès
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 bonjour:
 *                   type: string
 *                   example: monde
 *           text/csv:
 *             schema:
 *               type: string
 *               example: "bonjour,monde"
 *           application/xml:
 *             schema:
 *               type: string
 *               example: "<bonjour>monde</bonjour>"
 *       406:
 *         description: Format non supporté
 */
app.get('/api/v1/bonjour', verifierEnTeteAccept, (req, res) => {
  const donnees = { bonjour: 'monde' };
  const reponseFormatee = formaterReponse(req.formatAccepte, donnees);
  res.type(req.formatAccepte).send(reponseFormatee);
});

/**
 * @swagger
 * /api/v1/meteo:
 *   get:
 *     summary: Renvoie les données météo pour un lieu spécifique
 *     description: Renvoie un objet contenant les informations de lieu et de météo dans le format spécifié par l'en-tête Accept
 *     produces:
 *       - application/json
 *       - text/csv
 *       - application/xml
 *     responses:
 *       200:
 *         description: Succès
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 nom:
 *                   type: string
 *                 latitude:
 *                   type: number
 *                 longitude:
 *                   type: number
 *                 ville:
 *                   type: string
 *                 pays:
 *                   type: string
 *                 temperature:
 *                   type: number
 *                 humidite:
 *                   type: number
 *                 vitesseVent:
 *                   type: number
 *           text/csv:
 *             schema:
 *               type: string
 *           application/xml:
 *             schema:
 *               type: string
 *       406:
 *         description: Format non supporté
 *       500:
 *         description: Erreur lors de la récupération des données météo
 */
app.get('/api/v1/meteo', verifierEnTeteAccept, async (req, res) => {
  try {
    const lieu = new Lieu(
      "Tour Eiffel",
      new Coordonnees(48.8584, 2.2945),
      new Ville("Paris"),
      new Pays("France")
    );
    
    const donneeMeteo = await weatherService.getWeatherData(lieu.coordonnees.latitude, lieu.coordonnees.longitude);
    const dto = new DonneeLieuMeteo(lieu, donneeMeteo);
    
    const reponseFormatee = formaterReponse(req.formatAccepte, dto);
    res.type(req.formatAccepte).send(reponseFormatee);
  } catch (error) {
    console.error('Erreur dans /api/v1/meteo:', error);
    res.status(500).send('Erreur lors de la récupération des données météo');
  }
});

app.listen(port, () => {
  console.log(`Serveur lancé sur http://localhost:${port}`);
  console.log(`Documentation Swagger disponible sur http://localhost:${port}/api-docs`);
});