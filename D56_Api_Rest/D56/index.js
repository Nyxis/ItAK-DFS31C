const express = require('express');
const xml2js = require('xml2js');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const app = express();
const port = 3000;

// Middleware pour vérifier le format demandé
const checkAcceptHeader = (req, res, next) => {
  const acceptHeader = req.get('Accept');
  if (acceptHeader === 'application/json' || acceptHeader === 'text/csv' || acceptHeader === 'application/xml') {
    req.acceptFormat = acceptHeader;
    next();
  } else {
    res.status(406).send('Format non supporté. Utilisez application/json, text/csv ou application/xml.');
  }
};

// Fonction pour formater la réponse
const formatResponse = (format, data) => {
  if (format === 'application/json') {
    return JSON.stringify(data);
  }
  if (format === 'text/csv') {
    let result = '';
    for (let [key, value] of Object.entries(data)) {
      if (result !== '') {
        result += '\n';
      }
      result += `${key},${value}`;
    }
    return result;
  }
  if (format === 'application/xml') {
    const builder = new xml2js.Builder();
    return builder.buildObject(data);
  }
  throw new Error('Format non supporté');
};

// Configuration Swagger
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'API Hello World',
      version: '1.0.0',
      description: 'Une simple API Hello World avec support multi-format',
    },
  },
  apis: ['./app.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

/**
 * @swagger
 * /api/v1/hello:
 *   get:
 *     summary: Renvoie "hello world" dans le format spécifié
 *     description: Renvoie un objet contenant "hello world" dans le format spécifié par l'en-tête Accept
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
 *                 hello:
 *                   type: string
 *                   example: world
 *           text/csv:
 *             schema:
 *               type: string
 *               example: "hello,world"
 *           application/xml:
 *             schema:
 *               type: string
 *               example: "<hello>world</hello>"
 *       406:
 *         description: Format non supporté
 */
app.get('/api/v1/hello', checkAcceptHeader, (req, res) => {
  const data = { hello: 'world' };
  const formattedResponse = formatResponse(req.acceptFormat, data);
  res.type(req.acceptFormat).send(formattedResponse);
});

app.listen(port, () => {
  console.log(`Serveur lancé sur http://localhost:${port}`);
  console.log(`Documentation Swagger disponible sur http://localhost:${port}/api-docs`);
});