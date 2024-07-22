<?php

namespace App;

class Database
{
    protected \PDO $connection;

    public function __construct(string $dsn, string $username, string $password)
    {
        $this->connection = new \PDO($dsn, $username, $password);
        $this->connection->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
    }

    public function sqlQuery(string $sqlQuery, array $params = [])
    {
        $stmt = $this->connection->prepare($sqlQuery);
        $stmt->execute($params);
    }
}
