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

## Injection de dépendance

Utilisez maintenant le composant d'injection de dépendance pour accéder au `ProductRepository` depuis votre Controller au moment de la soumission du formulaire pour remplacer la chaîne de création qui était nécessaire jusqu'ici.

Une erreur doit survenir : en effet, le composant d'injection de dépendance ne peut pas résoudre l'argument abstrait de l'Adapter (le persistence interface). Il faut donc déclarer explicitement quelle implémentation sera utilisée dans l'application, Json ou Sql. Pour ce faire, utilisez la clé `services._default.bind` du fichier `config/services.yaml`.

## Templating et visuels

Améliorez maintenant le rendu de votre code :
 - Intégrez le framework Tailwind 2 à votre projet (un appel au CDN sera suffisant dans un 1er temps)
 - Créez un dossier spécifique aux vues concernant votre module "Produits" dans le dossier `templates`
 - Créez une route / action / template pour afficher la liste des produits enregistrés dans l'une de vos persistences. Dans le tableau, si le prix du produit dépasse un certain montant défini dans la configuration du projet, le symbole ✨ doit être affiché à côté du prix (_tips : utilisez un filtre_).
 - Votre vue devra contenir une barre de navigation avec un lien sur la page de liste des produits, qui sera en surbrillance si la page affichée est dans le module "Produits".
 - Créez une page "Nouveau produit", qui affiche un formulaire de création de Produits. Veillez à utiliser le thème Tailwind 2 pour afficher ce formulaire.
 - À la soumission du formulaire, enregistrez votre produit via la classe ProductRepository






