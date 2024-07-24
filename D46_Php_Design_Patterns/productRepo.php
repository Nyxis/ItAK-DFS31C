<?php
require_once('product.php');
require_once('database.php');

class ProductRepository
{
    private DatabaseAdapter $databaseAdapter;
    private JsonFileAdapter $jsonFileAdapter;

    public function __construct(DatabaseAdapter $databaseAdapter, JsonFileAdapter $jsonFileAdapter)
    {
        $this->databaseAdapter = $databaseAdapter;
        $this->jsonFileAdapter = $jsonFileAdapter;
    }

    public function save(Product $product)
    {
        if (!$product->isValid()) {
            throw new \Exception("Invalid product data");
        }

        // Sauvegarder dans la BDD SQL
        $this->databaseAdapter->save($product);

        // Sauvegarder dans le fichier JSON
        $this->jsonFileAdapter->save($product);
    }
}

