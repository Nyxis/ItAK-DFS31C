<?php
require_once 'PersistenceAdapter.php';
require_once 'Product.php';
require_once 'Database.php';

class DatabaseAdapter implements PersistenceAdapter
{
    private Database $database;
    private \PDO $connexion;

    public function __construct(Database $database, \PDO $connexion)
    {
        $this->database = $database;
        $this->connexion = $connexion;
    }

    public function saveProduct(Product $product)
    {
        $sqlQuery = "INSERT INTO products (id, designation, univers, price) VALUES (
            {$product->id}, '{$product->designation}', '{$product->univers}', {$product->price})";
        $this->database->sqlQuery($sqlQuery, $this->connexion);
    }
}
?>
