<?php
namespace App;
use PDO;
use App\PersistanceInterface;

class Database implements PersistanceInterface
{
    protected PDO $connection;

    /**
     * @param string $dsn database connection DSN
     * @example new Database('mysql://root:@127.0.0.1:3306/app?serverVersion=10.11.2-MariaDB&charset=utf8mb4')
     */
    public function __construct(string $dsn)
    {
        $this->connection = new PDO($dsn);
    }
    
    public function sqlQuery(string $sqlQuery)
    {
        $stmt = $this->connection->prepare($sqlQuery);
        $stmt->execute();
    }

    public function save($data) {
        $this->sqlQuery("INSERT INTO products (univers, designation, price) VALUES (" . $data . ")");
    }


}