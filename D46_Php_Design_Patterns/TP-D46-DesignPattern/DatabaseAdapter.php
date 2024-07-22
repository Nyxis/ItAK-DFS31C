<?php

namespace App\Product;

class DatabaseAdapter implements PersistenceInterface
{
    private \PDO $connection;

    public function __construct(\PDO $connection)
    {
        $this->connection = $connection;
    }

    public function save(array $data): void
    {
        $sql = "INSERT INTO products (id, designation, univers, price) VALUES (:id, :designation, :univers, :price)";
        $stmt = $this->connection->prepare($sql);
        $stmt->execute($data);
    }
}