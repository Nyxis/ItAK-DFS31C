// server.js

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const routes = require('./routes');
const versionChecker = require('./middleware/versionChecker');
const swaggerSpecs = require('./swagger');
const swaggerUi = require('swagger-ui-express');

const app = express();
const port = process.env.PORT || 3001;

// Configuration des options CORS
const corsOptions = {
  origin: 'http://127.0.0.1:5173',
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));

// Analyse du corps des requêtes en JSON
app.use(express.json());

// Journalisation de toutes les requêtes
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  console.log('En-têtes :', req.headers);
  next();
});

// Vérification de la version de l'API
app.use(versionChecker);

// Chargement des routes
app.use('/', routes);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpecs));

// Gestion des erreurs
app.use((err, req, res, next) => {
  console.error('Erreur :', err.message);
  console.error('Stack trace :', err.stack);
  res.status(500).json({ error: 'Erreur interne du serveur' });
});

// Gestion des routes non trouvées
app.use((req, res, next) => {
  res.status(404).json({ error: 'Non trouvé' });
});

// Démarrage du serveur
app.listen(port, () => {
  console.log(`Serveur démarré sur http://localhost:${port}/`);
  console.log(`Swagger UI disponible sur http://localhost:${port}/api-docs`);
});

// Gestion des exceptions non interceptées
process.on('uncaughtException', (error) => {
  console.error('Exception non interceptée :', error);
  process.exit(1);
});

// Gestion des promesses rejetées non gérées
process.on('unhandledRejection', (reason, promise) => {
  console.error('Rejet non géré de la promesse :', promise, 'raison :', reason);
  process.exit(1);
});


