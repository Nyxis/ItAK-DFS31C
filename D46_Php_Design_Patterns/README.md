# D46 - Php / Design Pattern

## Principes SOLID

Les principes SOLID ont pour but de minimiser la variance des fonctions dans des objets et l'impact du contexte sur l'exécution des fonction d'un objet.

Voici la liste :
 - Single Responsability Principle
 - Open Closed Principle
 - Liskov Substitution Principle
 - Interface Seggregation Principle
 - Dependency Inversion Principle

Expliquez en quoi consiste chacun en une phrase.

## Anti patterns STUPID

L'accronyme STUPID liste des pratiques contestables dans le développement informatique du point de vue de la clarté du code et de la maintenabilité de l'application en général.

Les voici :
 - Singleton
 - Tight Coupling
 - Untestability
 - Premature Optimization
 - Indescriptive Naming
 - Duplication

Expliquez chacun en une phrase et donnez un exemple de code en Php.

## Design Pattern Adapter

Le pattern Adapter permet de faire travailler ensemble des objets qui ont des responsabilités similaires ou connexes, dont les prototypes ne sont pas compatibles.
Il permet de ne pas lier fortement des classes entre elles mais simplement à leurs comportements. Ainsi, quand un comportement doit évoluer, il n'y a pas de risques d'incompatibilité avec le reste de l'application.

Mise en place :
  - Identifier le comportement à adapter / à connecter
  - Abstraire ce comportement dans une interface
  - Créer une dépendance à cette interface dans la classe qui va faire appel au comportement, puis l'appeler
  - Créer une classe concrète qui implémente l'interface du comportement à adapter
  - Créer une dépendance sur la classe à adapter, puis l'utiliser

Voici les classes suivantes :
```php

class Product
{
    public int $id;
    public string $designation;
    public string $univers;
    public int $price;
}

class ProductRepository
{
    public function save(Product $product)
    {
        // convert Product to proper persistence format
    }
}

class Database
{
    public function sqlQuery(string $sqlQuery, \PDO $connexion)
    {
        $stmt = $connexion->createStatement($sqlQuery);
        $stmt->execute();
    }
}

```

Créez le code permettrant de sauvegarder l'objet Product dans une base de données SQL via les classes ProductRepository et Database.

Modifiez ensuite votre code pour introduire un Adapter entre ProductRepository et Database.
Utilisez maintenant cet Adapter pour modifier la persistance des données sans modifier la classe Repository, pour écrire les données produits au format JSON dans un fichier au lieu d'une base de données.

Pour tous ces exercices, veillez à respecter les principes SOLID.

_Tips : ```json_encode()``` / ```file_put_contents()```_
