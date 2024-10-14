# API_Documentation.md

```md
# Format API Documentation

## Base URL

All URLs referenced in the documentation have the following base:

\`\`\`
http://localhost:3000/api/v1
\`\`\`

## Endpoints

1. [GET /format/json](#1-get-formatjson)
2. [GET /format/xml](#2-get-formatxml)
3. [GET /format/csv](#3-get-formatcsv)
4. [GET /location-weather](#4-get-location-weather)

---

### 1. GET /format/json

Returns a simple JSON object.

#### Request

\`\`\`
GET /format/json
\`\`\`

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/json

\`\`\`json
{
  "hello": "world"
}
\`\`\`

---

### 2. GET /format/xml

Returns a simple XML structure.

#### Request

\`\`\`
GET /format/xml
\`\`\`

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/xml

\`\`\`xml
<hello>world</hello>
\`\`\`

---

### 3. GET /format/csv

Returns a simple CSV format.

#### Request

\`\`\`
GET /format/csv
\`\`\`

#### Response

- **Status Code**: 200 OK
- **Content-Type**: text/csv

\`\`\`
hello
world
\`\`\`

---

### 4. GET /location-weather

Returns weather information for a given location.

#### Request

\`\`\`
GET /location-weather?lat={latitude}&lon={longitude}
\`\`\`

#### Query Parameters

- `lat` (required): Latitude of the location (float between -90 and 90)
- `lon` (required): Longitude of the location (float between -180 and 180)

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/json

\`\`\`json
{
  "locationName": "Mock Location",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "cityName": "MockCity",
  "country": "MockCountry",
  "temperature": 25.5,
  "humidity": 60,
  "windSpeed": 10,
  "timestamp": "2024-10-11T12:00:00Z"
}
\`\`\`

#### Error Responses

1. Missing both latitude and longitude:
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Both latitude and longitude are required"}
   \`\`\`

2. Missing latitude:
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Latitude is required"}
   \`\`\`

3. Missing longitude:
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Longitude is required"}
   \`\`\`

4. Invalid latitude (not between -90 and 90):
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Invalid latitude. Must be a number between -90 and 90."}
   \`\`\`

5. Invalid longitude (not between -180 and 180):
   - **Status Code**: 400 Bad Request
   \`\`\`json
   {"error": "Invalid longitude. Must be a number between -180 and 180."}
   \`\`\`

## Data Models

### LocationWeatherData (DTO)

- `locationName`: string
- `latitude`: float
- `longitude`: float
- `cityName`: string
- `country`: string
- `temperature`: float
- `humidity`: float
- `windSpeed`: float
- `timestamp`: string (ISO8601 format)

## Versioning

This API follows Semantic Versioning. The current version is v1. Any breaking changes will be introduced in a new major version (e.g., v2).


```

# app.js

```js
const express = require('express');
const app = express();
const port = 3000;

// Import our route
const formatRoute = require('./routes/formatRoute');

// Use the route
app.use('/api/v1', formatRoute);

let server;
if (process.env.NODE_ENV !== 'test') {
    server = app.listen(port, () => {
        console.log(`Server running at http://localhost:${port}`);
    });
}

// Function to close the server
const closeServer = () => {
    return new Promise((resolve) => {
        if (server) {
            server.close(() => {
                resolve();
            });
        } else {
            resolve();
        }
    });
};

module.exports = { app, closeServer };  // Export both app and closeServer function

```

# controllers/FormatController.js

```js
const { GPS, City, Location, WeatherData, LocationWeatherData } = require('../models');

class FormatController {
    static getJsonFormat(req, res) {
        res.status(200).json({ hello: 'world' });
    }

    static getXmlFormat(req, res) {
        res.status(200).set('Content-Type', 'application/xml').send('<hello>world</hello>');
    }

    static getCsvFormat(req, res) {
        res.status(200).set('Content-Type', 'text/csv').send('hello\nworld\n');
    }

    static getLocationWeather(req, res) {
        const { lat, lon } = req.query;

        if (!lat && !lon) {
            return res.status(400).json({ error: 'Both latitude and longitude are required' });
        }
        if (!lat) {
            return res.status(400).json({ error: 'Latitude is required' });
        }
        if (!lon) {
            return res.status(400).json({ error: 'Longitude is required' });
        }

        // Validate latitude and longitude
        const latFloat = parseFloat(lat);
        const lonFloat = parseFloat(lon);
        if (isNaN(latFloat) || latFloat < -90 || latFloat > 90) {
            return res.status(400).json({ error: 'Invalid latitude. Must be a number between -90 and 90.' });
        }
        if (isNaN(lonFloat) || lonFloat < -180 || lonFloat > 180) {
            return res.status(400).json({ error: 'Invalid longitude. Must be a number between -180 and 180.' });
        }

        // Here you would typically fetch real data from external APIs
        // For this example, we'll use mock data
        const gps = new GPS(latFloat, lonFloat);
        const city = new City('MockCity');
        const location = new Location('Mock Location', gps, city, 'MockCountry');
        const weatherData = new WeatherData(25.5, 60, 10);

        const locationWeatherData = new LocationWeatherData(location, weatherData);

        res.status(200).json(locationWeatherData);
    }
}

module.exports = FormatController;


```

# models.js

```js
class GPS {
    constructor(latitude, longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }
}

class City {
    constructor(name) {
        this.name = name;
    }
}

class Location {
    constructor(name, coordinates, city, country) {
        this.name = name;
        this.coordinates = coordinates;
        this.city = city;
        this.country = country;
    }
}

class WeatherData {
    constructor(temperature, humidity, windSpeed) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
    }
}

class LocationWeatherData {
    constructor(location, weatherData) {
        this.locationName = location.name;
        this.latitude = location.coordinates.latitude;
        this.longitude = location.coordinates.longitude;
        this.cityName = location.city.name;
        this.country = location.country;
        this.temperature = weatherData.temperature;
        this.humidity = weatherData.humidity;
        this.windSpeed = weatherData.windSpeed;
        this.timestamp = new Date().toISOString();
    }
}

module.exports = {
    GPS,
    City,
    Location,
    WeatherData,
    LocationWeatherData
};

```

# package.json

```json
{
  "name": "api-format-demo",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "jest"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "description": "A simple API that returns data in different formats",
  "dependencies": {
    "express": "^4.21.1"
  },
  "devDependencies": {
    "jest": "^27.5.1",
    "supertest": "^6.3.4"
  }
}

```

# README.md

```md
# D56 - Concevoir / Créer / Consommer des Apis REST

## Hello world et multi-format

Les API HTTP (aussi appelées API REST) offrent la possibilité au client de l'API (aussi appelé consommateur) de choisir son format de sortie via les headers de requêtes.

À l'aide du langage et du framework de votre choix, créez un endpoint qui renvoie la map \`\`\`["hello" => "world"]\`\`\` au format donné en entrée.

Dans un premier temps, ne proposez que les formats json, csv et xml; il devront être sélectionné par votre code via le header HTTP standard.

Pour cet exercice et les suivants, vous veillerez à respecter les principes SOLID, ainsi que les bonnes pratiques des Apis REST vues en cours, sur le versioning sémantique et la documentation.

## DTO et Value objects

Nous allons exposer des données cartographiques recoupées avec des données météo en utilisant des APIs externes.

Commencez par créer des modèles représentant les notions suivantes :
- Un lieu (nom, coordonnées GPS, ville, pays)
- Les données météo à un temps donné (température, humidité, vitesse du vent)

Utilisez une structure objet complète avec des Value Objects, pour la ville par exemple.

Créez maintenant un DTO pour matérialiser les informations recoupées sur les lieux et la météo. Un DTO est un objet simple, contenant les données "à plat" qui vont ensuite être exposées via les Apis REST.
Le DTO prendra en paramètre le lieu et la donnée météo.

__Tips__ : Appelez votre DTO LocationWeatherData. Il est relativement commun de suffixer les DTO avec "Data".


# Projet d'API de Format (Amirofcodes)

## Description
Ce projet implémente une API simple qui renvoie des données dans différents formats (JSON, XML, CSV) et fournit des informations météorologiques pour un lieu donné. Il démontre l'utilisation d'Express.js pour le développement d'API, ainsi que l'implémentation de DTOs (Objets de Transfert de Données) et d'Objets Valeur.

## Structure du Projet
- `app.js`: Fichier principal de l'application
- `routes/formatRoute.js`: Définitions des routes
- `controllers/FormatController.js`: Logique du contrôleur
- `models.js`: Définitions des Objets Valeur et DTO
- `tests/formatRoute.test.js`: Suite de tests
- `API_Documentation.md`: Documentation de l'API

## Configuration et Installation
1. Clonez le dépôt
2. Installez les dépendances :
   \`\`\`
   npm install
   \`\`\`

## Exécution de l'Application
Démarrez le serveur :
\`\`\`
npm start
\`\`\`
Le serveur fonctionnera par défaut sur `http://localhost:3000`.

## Points de Terminaison de l'API
1. `GET /api/v1/format/json`: Renvoie des données JSON
2. `GET /api/v1/format/xml`: Renvoie des données XML
3. `GET /api/v1/format/csv`: Renvoie des données CSV
4. `GET /api/v1/location-weather`: Renvoie des données météorologiques pour un lieu

Pour une documentation détaillée de l'API, consultez `API_Documentation.md`.

## Utilisation de l'API Météo de Localisation
Pour obtenir des données météorologiques pour un lieu, faites une requête GET à :
\`\`\`
/api/v1/location-weather?lat={latitude}&lon={longitude}
\`\`\`
Remplacez `{latitude}` et `{longitude}` par les coordonnées réelles.

Exemple d'une requête correcte :
\`\`\`
GET /api/v1/location-weather?lat=40.7128&lon=-74.0060
\`\`\`

Note :
- La latitude et la longitude doivent toutes deux être fournies en tant que paramètres de requête.
- La latitude doit être comprise entre -90 et 90.
- La longitude doit être comprise entre -180 et 180.

Si des paramètres sont manquants ou invalides, vous recevrez un message d'erreur approprié.

## Modèles de Données
- `GPS`: Objet Valeur pour les coordonnées GPS
- `City`: Objet Valeur pour les informations de la ville
- `Location`: Objet Valeur combinant nom, GPS, ville et pays
- `WeatherData`: Objet Valeur pour les informations météorologiques
- `LocationWeatherData`: DTO combinant Location et WeatherData

## Exécution des Tests
Exécutez la suite de tests :
\`\`\`
npm test
\`\`\`

Les tests couvrent :
- Les points de terminaison des formats JSON, XML et CSV
- La fonctionnalité de l'API Météo de Localisation
- La gestion des erreurs pour les paramètres manquants et invalides

## Résultats des Tests
Les 9 tests passent avec succès, couvrant :
- Les points de terminaison de base (JSON, XML, CSV)
- La récupération réussie des données météorologiques
- La gestion des erreurs pour latitude et/ou longitude manquantes
- La gestion des erreurs pour des valeurs de latitude ou longitude invalides

## Développement
- Le projet utilise Express.js comme framework web.
- Jest est utilisé pour les tests.
- Les DTOs et les Objets Valeur sont implémentés dans `models.js`.

## Améliorations Futures
- Intégrer de vraies APIs externes pour les données météorologiques et de localisation.
- Ajouter une gestion d'erreurs plus complète et une validation des entrées.
- Implémenter une mise en cache pour améliorer les performances.
- Ajouter des tests d'intégration pour les flux de bout en bout.

```

# routes/formatRoute.js

```js
const express = require('express');
const router = express.Router();
const FormatController = require('../controllers/FormatController');

router.get('/format/json', FormatController.getJsonFormat);
router.get('/format/xml', FormatController.getXmlFormat);
router.get('/format/csv', FormatController.getCsvFormat);
router.get('/location-weather', FormatController.getLocationWeather);

module.exports = router;

```

# tests/formatRoute.test.js

```js
const request = require('supertest');
const { app, closeServer } = require('../app');

describe('Format API', () => {
    afterAll(async () => {
        await closeServer();
    });

    describe('Basic Format Endpoints', () => {
        it('should return JSON format', async () => {
            const res = await request(app).get('/api/v1/format/json');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('application/json');
            expect(res.body).toEqual({ hello: 'world' });
        });

        it('should return XML format', async () => {
            const res = await request(app).get('/api/v1/format/xml');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('application/xml');
            expect(res.text).toBe('<hello>world</hello>');
        });

        it('should return CSV format', async () => {
            const res = await request(app).get('/api/v1/format/csv');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('text/csv');
            expect(res.text).toBe('hello\nworld\n');
        });
    });

    describe('Location Weather API', () => {
        it('should return location weather data in a flat structure', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=40.7128&lon=-74.0060');
            expect(res.statusCode).toBe(200);
            expect(res.headers['content-type']).toContain('application/json');
            expect(res.body).toHaveProperty('locationName');
            expect(res.body).toHaveProperty('latitude');
            expect(res.body).toHaveProperty('longitude');
            expect(res.body).toHaveProperty('cityName');
            expect(res.body).toHaveProperty('country');
            expect(res.body).toHaveProperty('temperature');
            expect(res.body).toHaveProperty('humidity');
            expect(res.body).toHaveProperty('windSpeed');
            expect(res.body).toHaveProperty('timestamp');

            // Check specific values
            expect(res.body.latitude).toBe(40.7128);
            expect(res.body.longitude).toBe(-74.0060);
            expect(typeof res.body.locationName).toBe('string');
            expect(typeof res.body.cityName).toBe('string');
            expect(typeof res.body.country).toBe('string');
            expect(typeof res.body.temperature).toBe('number');
            expect(typeof res.body.humidity).toBe('number');
            expect(typeof res.body.windSpeed).toBe('number');
            expect(typeof res.body.timestamp).toBe('string');
        });

        it('should return 400 if both latitude and longitude are missing', async () => {
            const res = await request(app).get('/api/v1/location-weather');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Both latitude and longitude are required');
        });

        it('should return 400 if latitude is missing', async () => {
            const res = await request(app).get('/api/v1/location-weather?lon=-74.0060');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Latitude is required');
        });

        it('should return 400 if longitude is missing', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=40.7128');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Longitude is required');
        });

        it('should return 400 if latitude is invalid', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=91&lon=-74.0060');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Invalid latitude. Must be a number between -90 and 90.');
        });

        it('should return 400 if longitude is invalid', async () => {
            const res = await request(app).get('/api/v1/location-weather?lat=40.7128&lon=181');
            expect(res.statusCode).toBe(400);
            expect(res.body).toHaveProperty('error');
            expect(res.body.error).toBe('Invalid longitude. Must be a number between -180 and 180.');
        });
    });
});


```

