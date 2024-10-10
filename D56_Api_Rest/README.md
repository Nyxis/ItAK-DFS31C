# D56 - Concevoir / Créer / Consommer des Apis REST

## Hello world et multi-format

Endpoints
1. Endpoint de choix de format
URL: /
Méthode: GET
Description: Page d'accueil offrant des liens pour choisir le format de réponse.
Réponse:
HTML avec des liens pour accéder aux différents formats (JSON, XML, CSV).

2. Endpoint de réponse
URL: /api/hello
Méthode: GET
Description: Renvoie la map {"hello": "world"} dans le format spécifié par le header Accept.
Headers
Accept:
application/json pour recevoir une réponse en JSON.
application/xml pour recevoir une réponse en XML.
text/csv pour recevoir une réponse en CSV.

3. Application des principes SOLID
L'API respecte les principes SOLID, qui sont des lignes directrices pour écrire un code propre, maintenable et extensible. Voici comment chaque principe a été appliqué :

S - Single Responsibility Principle (SRP)
Chaque classe et chaque module de l'application a une seule responsabilité :

JsonResponse, XmlResponse, et CsvResponse : Chacune de ces classes est responsable de formater les données dans un format spécifique (JSON, XML, ou CSV).
ResponseFormatter : Cette classe gère la logique de formatage des réponses et est responsable de l'envoi des réponses formatées au client.
O - Open/Closed Principle (OCP)
Les classes sont ouvertes à l'extension mais fermées à la modification :

Si de nouveaux formats de réponse doivent être ajoutés, il suffit de créer une nouvelle classe (par exemple, HtmlResponse) qui implémente la méthode de formatage sans avoir à modifier le code existant.
L - Liskov Substitution Principle (LSP)
Les classes dérivées doivent pouvoir remplacer leurs classes de base :

Chaque formatteur (JsonResponse, XmlResponse, CsvResponse) peut être utilisé de manière interchangeable avec la classe ResponseFormatter. Les instances de ces classes peuvent être passées à ResponseFormatter, garantissant que le comportement attendu est respecté.
I - Interface Segregation Principle (ISP)
Il est préférable d'avoir plusieurs interfaces spécifiques plutôt qu'une seule interface générale :

Bien que nous n'ayons pas utilisé d'interfaces explicites dans le code, chaque classe de formatteur a une méthode format(data) qui est spécifique à son comportement, permettant une utilisation ciblée sans obliger à utiliser des fonctionnalités non nécessaires.
D - Dependency Inversion Principle (DIP)
Les dépendances doivent être abstraites et non dépendre de modules de bas niveau :

ResponseFormatter dépend des abstractions des formatteurs (JsonResponse, XmlResponse, CsvResponse) plutôt que de classes concrètes, permettant une meilleure flexibilité et facilitant les tests unitaires.


## DTO et Value objects

Nous allons exposer des données cartographiques recoupées avec des données météo en utilisant des APIs externes.

Commencez par créer des modèles représentant les notions suivantes :
- Un lieu (nom, coordonnées GPS, ville, pays)
- Les données météo à un temps donné (température, humidité, vitesse du vent)

Utilisez une structure objet complète avec des Value Objects, pour la ville par exemple.

Créez maintenant un DTO pour matérialiser les informations recoupées sur les lieux et la météo. Un DTO est un objet simple, contenant les données "à plat" qui vont ensuite être exposées via les Apis REST.
Le DTO prendra en paramètre le lieu et la donnée météo.

__Tips__ : Appelez votre DTO LocationWeatherData. Il est relativement commun de suffixer les DTO avec "Data".
