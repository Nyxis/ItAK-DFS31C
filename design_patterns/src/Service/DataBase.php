<?php

namespace App\Service;

class Database
{
    public function sqlQuery(string $sqlQuery, \PDO $connexion, array $parameters = [])
    {
        $stmt = $connexion->prepare($sqlQuery);
        $stmt->execute($parameters);
    }
}