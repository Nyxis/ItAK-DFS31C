<?php
require_once('product.php');
require_once('database.php');
require_once('productRepo.php');


// Interface Persister
interface Persister
{
    public function save(Product $product);
}

// Classe DatabaseAdapter
class DatabaseAdapter implements Persister
{
    private $database;
    private \PDO $connexion;

    public function __construct($database, \PDO $connexion)
    {
        $this->database = $database;
        $this->connexion = $connexion;
    }

    public function save(Product $product)
    {
        try {
            $sqlQuery = "INSERT INTO produitsDb (designation, univers, price) VALUES (:designation, :univers, :price)";
            $stmt = $this->connexion->prepare($sqlQuery);
            $stmt->execute([
                ':designation' => $product->designation,
                ':univers' => $product->univers,
                ':price' => $product->price
            ]);
            // Récupérer le dernier id de la BDD SQL
            $product->id = $this->connexion->lastInsertId();
        } catch (\PDOException $e) {
            throw new \Exception("Database error: " . $e->getMessage());
        }
    }
}


// Classe JsonFileAdapter
class JsonFileAdapter implements Persister
{
    private string $filePath;

    public function __construct(string $filePath)
    {
        $this->filePath = $filePath;
    }

    public function save(Product $product)
    {
        $newProduct = [
            'id' => $product->id,
            'designation' => $product->designation,
            'univers' => $product->univers,
            'price' => $product->price
        ];

        if (file_exists($this->filePath) && filesize($this->filePath) > 0) {
            $currentData = json_decode(file_get_contents($this->filePath), true);
            if (json_last_error() !== JSON_ERROR_NONE) {
                throw new \Exception("Invalid JSON in file.");
            }
            $currentData[] = $newProduct;
        } else {
            $currentData = [$newProduct];
        }

        file_put_contents($this->filePath, json_encode($currentData, JSON_PRETTY_PRINT));
    }
}



try {
    $database = new Database(); 
    $connexion = new \PDO('mysql:host=localhost;dbname=produits', 'root', '');
    $connexion->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);

    $databaseAdapter = new DatabaseAdapter($database, $connexion);
    $jsonFileAdapter = new JsonFileAdapter('fichier.json');

    $productRepository = new ProductRepository($databaseAdapter, $jsonFileAdapter);

    $product = new Product();
    // Défini les paramètre du produit
    $product->designation = "Example Product";
    $product->univers = "Example Universe";
    $product->price = 100;

    $productRepository->save($product);

    echo "Product saved successfully in both database and JSON file.";
} catch (\Exception $e) {
    echo "Error: " . $e->getMessage();
}

