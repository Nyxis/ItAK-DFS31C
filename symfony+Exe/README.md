# ProductMNG

ProductMNG est une application web Symfony simple qui permet d'ajouter de nouveaux produits via un formulaire web et de les sauvegarder à la fois dans une base de données MySQL et dans un fichier JSON. Ce projet est conçu pour aider les étudiants en développement fullstack à comprendre et à mettre en œuvre les concepts de base de Symfony.

## Table des matières

- [Aperçu du projet](#aperçu-du-projet)
- [Fonctionnalités](#fonctionnalités)
- [Comment ça marche](#comment-ça-marche)
- [Structure des fichiers et des répertoires](#structure-des-fichiers-et-des-répertoires)
- [Contribution](#contribution)
- [Licence](#licence)

## Aperçu du projet

L'application ProductMNG permet aux utilisateurs d'ajouter de nouveaux produits via un formulaire web. Une fois le formulaire soumis, les informations sur le produit sont sauvegardées dans une base de données MySQL et dans un fichier JSON. L'objectif principal de ce projet est d'illustrer comment créer une application Symfony en utilisant les bonnes pratiques de développement.

## Fonctionnalités

- Formulaire web pour ajouter des produits.
- Sauvegarde des produits dans une base de données MySQL.
- Sauvegarde des produits dans un fichier JSON.
- Affichage d'un message de succès après l'ajout d'un produit.

## Comment ça marche

1. **Accès au formulaire :**
   - L'utilisateur accède à l'URL `/product/new` où il peut voir et remplir le formulaire pour ajouter un nouveau produit.

2. **Soumission du formulaire :**
   - L'utilisateur remplit les champs requis (désignation, univers, prix) et soumet le formulaire.

3. **Traitement des données :**
   - Le contrôleur `ProductController` gère la soumission du formulaire. Il valide les données et les persiste dans la base de données.
   - Le service `JsonProductPersister` est utilisé pour sauvegarder les informations du produit dans un fichier JSON.

4. **Affichage du message de succès :**
   - Après la sauvegarde réussie, un message de succès est affiché à l'utilisateur, et le formulaire est réinitialisé pour permettre l'ajout d'un autre produit.

## Structure des fichiers et des répertoires

Voici la structure des fichiers et des répertoires de ce projet :

```
ProductMNG/
├── config/
│   ├── packages/
│   ├── routes/
│   └── services.yaml
├── migrations/
├── public/
├── src/
│   ├── Controller/
│   │   └── ProductController.php
│   ├── Entity/
│   │   └── Product.php
│   ├── Form/
│   │   └── ProductType.php
│   ├── Repository/
│   ├── Service/
│   │   └── JsonProductPersister.php
│   └── Kernel.php
├── templates/
│   └── product/
│       └── new.html.twig
├── translations/
├── var/
│   ├── cache/
│   ├── log/
│   └── products.json
├── vendor/
├── .env
├── .gitignore
├── composer.json
├── composer.lock
├── Exercices&Définitions_SOLID_STUPID_DesignPattern
└── README.md
```

- **config/** : Contient les fichiers de configuration de l'application.
- **migrations/** : Contient les fichiers de migration de la base de données.
- **public/** : Contient les fichiers publics accessibles depuis le web.
- **src/** : Contient le code source de l'application.
  - **Controller/** : Contient les contrôleurs.
    - `ProductController.php` : Gère les requêtes pour ajouter des produits.
  - **Entity/** : Contient les entités de la base de données.
    - `Product.php` : Définition de l'entité Product.
  - **Form/** : Contient les classes de formulaires.
    - `ProductType.php` : Définition du formulaire pour ajouter des produits.
  - **Service/** : Contient les services.
    - `JsonProductPersister.php` : Service pour sauvegarder les produits en JSON.
- **templates/** : Contient les templates Twig pour le rendu des vues.
  - `product/new.html.twig` : Template pour le formulaire d'ajout de produit.
- **var/** : Contient les fichiers de cache, de log et le fichier JSON de produits.
- **vendor/** : Contient les dépendances du projet installées via Composer.


