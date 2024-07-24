Explication principe SOLID

- Single Responsability Principle : Une classe ne doit avoir qu'une seule raison de changer, ce qui signifie qu'elle ne doit avoir qu'un seul fonction à remplir ou responsabilité.
- Open Closed Principle : Les entités logicielles (classes, modules, fonctions, etc.) doivent être ouvertes à l'extension, mais fermées à la modification.
- Liskov Substitution Principle : Si un programme utilise une classe de base, il doit être capable d'utiliser n'importe laquelle de ses sous-classes sans le savoir et sans que le comportement du programme ne change.
- Interface Seggregation Principle : Les clients ne doivent pas être forcés de dépendre d'interfaces qu'ils n'utilisent pas. Au lieu de cela, les interfaces doivent être spécifiques aux besoins des clients.
-  Les modules de haut niveau ne doivent pas dépendre des modules de bas niveau. Les deux doivent dépendre d'abstractions. Les abstractions ne doivent pas dépendre des détails. Les détails doivent dépendre des abstractions.


Explication principe STUPID

Définition :
- Singleton : Un modèle de conception qui restreint l'instanciation d'une classe à une seule instance, garantissant qu'il n'existe qu'un seul objet de la classe tout au long de l'application.
Exemple : 
class Singleton {
    private static $instance = null;
    private $data = [];

    private function __construct() {}

    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new Singleton();
        }
        return self::$instance;
    }

    public function setData($key, $value) {
        $this->data[$key] = $value;
    }

    public function getData($key) {
        return isset($this->data[$key]) ? $this->data[$key] : null;
    }
}

// Usage
$singleton1 = Singleton::getInstance();
$singleton1->setData('name', 'John Doe');

$singleton2 = Singleton::getInstance();
echo $singleton2->getData('name'); // Outputs: John Doe
---

Définition : 
- Tight Coupling : Lorsque deux classes sont fortement dépendantes l'une de l'autre, ce qui rend difficile la modification ou le remplacement d'une classe sans affecter l'autre.
Exemple : 
class User {
    private $email;

    public function __construct($email) {
        $this->email = $email;
    }

    public function getEmail() {
        return $this->email;
    }
}

class EmailService {
    public function sendWelcomeEmail(User $user) {
        $email = $user->getEmail();
        // Send welcome email to $email
    }
}

// Usage
$user = new User('john.doe@example.com');
$emailService = new EmailService();
$emailService->sendWelcomeEmail($user);
--- 

Définition : 
- Untestability : Le code qui est difficile à tester, souvent en raison du manque de modularité, du couplage serré ou de l'utilisation de méthodes statiques et de variables globales.

Exemple : 
class User {
    private $email;

    public function __construct($email) {
        $this->email = $email;
    }

    public function getEmail() {
        return $this->email;
    }

    public function sendWelcomeEmail() {
        $email = $this->getEmail();
        // Send welcome email to $email
    }
}

// Usage
$user = new User('john.doe@example.com');
$user->sendWelcomeEmail();
---

Définition : 
- Premature Optimization : La pratique d'optimiser le code avant qu'il ne soit nécessaire, ce qui conduit souvent à un code plus complexe et plus difficile à maintenir.
Exemple : 
class User {
    private $firstName;
    private $lastName;
    private $fullName;

    public function __construct($firstName, $lastName) {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
        $this->fullName = $firstName . ' ' . $lastName;
    }

    public function getFullName() {
        return $this->fullName;
    }
}

// Usage
$user = new User('John', 'Doe');
echo $user->getFullName(); // Outputs: John Doe
---
Définition : 
- Indescriptive Naming : L'utilisation de noms clairs ou ambigus pour les variables, les fonctions ou les classes, ce qui rend le code plus difficile à comprendre et à maintenir.
Exemple : 
class User {
    private $firstName;
    private $lastName;
    private $fullName;

    public function __construct($firstName, $lastName) {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
        $this->fullName = $firstName . ' ' . $lastName;
    }

    public function getFullName() {
        return $this->fullName;
    }
}

// Usage
$user = new User('John', 'Doe');
echo $user->getFullName(); // Outputs: John Doe
---
Définition : 
- Duplication : La présence de code redondant ou en double, qui peut entraîner des incohérences, des difficultés de maintenance et une taille de code plus importante.
Exemple: 
class User {
    private $firstName;
    private $lastName;
    private $email;

    public function __construct($firstName, $lastName, $email) {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
        $this->email = $email;
    }

    public function getFirstName() {
        return $this->firstName;
    }

    public function getLastName() {
        return $this->lastName;
    }

    public function getEmail() {
        return $this->email;
    }
}

class Customer {
    private $firstName;
    private $lastName;
    private $email;

    public function __construct($firstName, $lastName, $email) {
        $this->firstName = $firstName;
        $this->lastName = $lastName;
        $this->email = $email;
    }

    public function getFirstName() {
        return $this->firstName;
    }

    public function getLastName() {
        return $this->lastName;
    }

    public function getEmail() {
        return $this->email;
    }
}
---
