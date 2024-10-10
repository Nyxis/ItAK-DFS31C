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
