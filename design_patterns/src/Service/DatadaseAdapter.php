<?php

namespace App\Service;

class DatabaseAdapter implements PersistenceInterface
{
    private $database;

    public function __construct(Database $database)
    {
        $this->database = $database;
    }

    public function saveProduct(array $productData)
    {
        //appel à la méthode sqlQuery de la classe Database
        $sqlQuery = "INSERT INTO products (id, designation, univers, price) VALUES (:id, :designation, :univers, :price)";
        $this->database->sqlQuery($sqlQuery, $productData);
    }
}