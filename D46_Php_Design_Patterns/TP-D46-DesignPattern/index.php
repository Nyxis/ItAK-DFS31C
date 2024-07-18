<?php 

interface PersistenceInterface
{
    public function save(array $data): void;
}

class DatabaseAdapter implements PersistenceInterface
{
    private Database $database;
    private \PDO $connection;

    public function __construct(Database $database, \PDO $connection)
    {
        $this->database = $database;
        $this->connection = $connection;
    }

    public function save(array $data): void
    {
        $sqlQuery = "INSERT INTO products (id, designation, univers, price) VALUES (:id, :designation, :univers, :price)";
        $this->database->sqlQuery($sqlQuery, $this->connection);
    }
}

class ProductRepository
{
    private PersistenceInterface $persistence;

    public function __construct(PersistenceInterface $persistence)
    {
        $this->persistence = $persistence;
    }

    public function save(Product $product): void
    {
        $data = [
            'id' => $product->id,
            'designation' => $product->designation,
            'univers' => $product->univers,
            'price' => $product->price
        ];
        $this->persistence->save($data);
    }
}

class JsonFileAdapter implements PersistenceInterface
{
    private string $filename;

    public function __construct(string $filename)
    {
        $this->filename = $filename;
    }

    public function save(array $data): void
    {
        $jsonData = json_encode($data);
        file_put_contents($this->filename, $jsonData . PHP_EOL, FILE_APPEND);
    }
}


$database = new Database();
$connection = new \PDO(/* paramètres de connexion */);
$databaseAdapter = new DatabaseAdapter($database, $connection);
$productRepository = new ProductRepository($databaseAdapter);

// Pour utiliser le fichier JSON
$jsonAdapter = new JsonFileAdapter('products.json');
$productRepository = new ProductRepository($jsonAdapter);

// Sauvegarder un produit
$product = new Product();
$product->id = 1;
$product->designation = "Produit ";
$product->univers = "Électronique";
$product->price = 1999;

$productRepository->save($product);