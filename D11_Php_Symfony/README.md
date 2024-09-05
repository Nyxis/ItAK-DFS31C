# D11 - Php / Symfony

## Installation de Symfony

Installez le framework Symfony dans votre workspace.
Les versions minimales à utiliser sont :
 - Php 8.2
 - Symfony 7.1

Vous pouvez utiliser `symfony-cli` ou `composer` pour ce faire.

## Hello World

Créez un Controller `HelloWorldController` et un template `hello_world.html.twig` dans lequel on affiche `<h1>Hello world !</h1>`.
Créez une route qui expose la méthode `HelloWorldController::__invoke()` à l'url `/hello_world`.

Visualisez cette page dans votre navigateur.

## Intégrer du code existant

Intégrez le code de votre design pattern Adapter développé dans le module [D46 - Php / Design Patterns](../D46_Php_Design_Patterns/README.md#design-pattern-adapter) dans le projet Symfony :
 - Créer un module "Produit" (Controller + route + template)
 - Appelez vos classes depuis le Controller pour enregistrer un produit dans les deux persistences
 - Affichez un message de succès dans le template si l'opération s'est bien passée

## Formulaire

Créez maintenant un formulaire qui permet de créer des objets Produit.
Vous utiliserez le composant "Form" de Symfony pour ce faire, puis l'une de vos persistences pour sauvegarder les données.


