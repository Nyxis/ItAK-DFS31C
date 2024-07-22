# ItAK-DFS31C

Principes SOLID
1.	Single Responsibility Principle (SRP) :
Une classe égale seule responsabilité (elle ne doit faire qu'une seule chose)
2.	Open Closed Principle (OCP) :
Les « entités logicielles » sont ouvertes à l'extension mais fermées à la modification, pour ajouter de nouvelles fonctionnalités sans toucher au code existant.
3.	Liskov Substitution Principle (LSP) :
Les objets d'une classe dérivée doivent pouvoir remplacer les objets de la classe de base sans affecter le comportement du programme.
4.	Interface Segregation Principle (ISP) :
Il ne faut pas se forcer à rajouter des interfaces non utilisées, ce qui encourage des interfaces plus petites et spécifiques.
5.	Dependency Inversion Principle (DIP) :
Les modules de haut niveau ne doivent pas dépendre des modules de bas niveau, mais plutôt des abstractions, pour plus de flexibilité et de maintenance.

Singleton :
Le Singleton crée une seule instance d'une classe, le code est donc difficile à tester et à maintenir :

class Singleton {
    private static $instance;

    private function __construct() {}

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new Singleton();
        }
        return self::$instance;
    }
}

1.	Tight Coupling :
Un couplage étroit va rendre le code moins flexible et plus difficile à modifier, car un changement dans une classe peut affecter toutes les autres classes.

class Order {
    public function process() {
        $payment = new Payment();
        $payment->charge();
    }
}
2.	Untestability :
Un code difficile à tester est souvent le résultat de dépendances rigides ou d'une mauvaise structure, rendant les tests unitaires complexes.

class User {
    public function getProfile() {
        $db = new DatabaseConnection();
        return $db->query('SELECT * FROM users');
    }
}
3.	Premature Optimization :
L'optimisation prématurée consiste à essayer d'améliorer les performances d'un code avant d'avoir identifié des problèmes réels, ce qui peut compliquer le code.

class DataProcessor {
    public function process($data) {
        // Utilisation de techniques complexes d'optimisation sans nécessité
    }
}
4.	Indescriptive Naming :
Noms de variables/fonctions pas assez descriptifs et qui rendent le code difficile à comprendre et à maintenir.

class A {
    public function b() {
        $c = 5;
        // Logique
    }
}
5.	Duplication :
La duplication de code rend le code plus difficile à maintenir, car les changements doivent être effectués à plusieurs endroits.

class Product {
    public function getFullName() {
        return $this->name . ' ' . $this->description;
    }
}

class Service {
    public function getFullName() {
        return $this->name . ' ' . $this->description;
    }
}


