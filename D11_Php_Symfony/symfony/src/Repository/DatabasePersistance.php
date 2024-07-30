<?php
namespace App\Repository;
use PDO;
use App\Repository\PersistanceInterface;

class DatabasePersistance implements PersistanceInterface
{
    protected PDO $connection;

    /**
     * @param string $dsn database connection DSN
     * @example new Database('mysql://root:@127.0.0.1:3306/app?serverVersion=10.11.2-MariaDB&charset=utf8mb4')
     */
    public function __construct(string $dsn, string $user, string $password = null)
    {
        $dsn = str_replace('mysql://', '', $dsn);
        
        $this->connection = new PDO($dsn, $user, $password);
        $this->connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
    
    public function sqlQuery(string $sqlQuery)
    {
        $stmt = $this->connection->prepare($sqlQuery);
        $stmt->execute();
    }

    public function save($data) {
        $sql = "INSERT INTO products (univers, designation, price) VALUES (:univers, :designation, :price)";
        $stmt = $this->connection->prepare($sql);
        $stmt->execute([
            'univers' => $data['univers'],
            'designation' => $data['designation'],
            'price' => $data['price']
        ]);    }


}