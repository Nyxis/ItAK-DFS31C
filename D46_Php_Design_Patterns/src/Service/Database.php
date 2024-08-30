<?php
// src/Service/Database.php
namespace App\Service;

use Doctrine\DBAL\Connection;

class Database
{
    public function sqlQuery(string $sqlQuery, Connection $connection): void
    {
        $stmt = $connection->prepare($sqlQuery);
        $stmt->execute();
    }
}
?>