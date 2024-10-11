# D56 - Concevoir / Créer / Consommer des Apis REST

## Hello world et multi-format

Les API HTTP (aussi appelées API REST) offrent la possibilité au client de l'API (aussi appelé consommateur) de choisir son format de sortie via les headers de requêtes.

À l'aide du langage et du framework de votre choix, créez un endpoint qui renvoie la map ```["hello" => "world"]``` au format donné en entrée.

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
   ```
   npm install
   ```

## Exécution de l'Application
Démarrez le serveur :
```
npm start
```
Le serveur fonctionnera par défaut sur `http://localhost:3000`.

## Points de Terminaison de l'API
1. `GET /api/v1/format/json`: Renvoie des données JSON
2. `GET /api/v1/format/xml`: Renvoie des données XML
3. `GET /api/v1/format/csv`: Renvoie des données CSV
4. `GET /api/v1/location-weather`: Renvoie des données météorologiques pour un lieu

Pour une documentation détaillée de l'API, consultez `API_Documentation.md`.

## Utilisation de l'API Météo de Localisation
Pour obtenir des données météorologiques pour un lieu, faites une requête GET à :
```
/api/v1/location-weather?lat={latitude}&lon={longitude}
```
Remplacez `{latitude}` et `{longitude}` par les coordonnées réelles.

Exemple d'une requête correcte :
```
GET /api/v1/location-weather?lat=40.7128&lon=-74.0060
```

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
```
npm test
```

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
