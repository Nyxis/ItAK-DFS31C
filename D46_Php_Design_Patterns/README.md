# Php / Design Pattern


## Design Pattern Adapter

Un pattern Adapter permet de faire travailler ensemble des objets qui ont des responsabilités similaires ou connexes, dont les prototypes ne sont pas compatibles.

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
        // convert Product to proper persistance format
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


## Design Pattern State Machine

