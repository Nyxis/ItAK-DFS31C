<?php

namespace App;

require_once 'PersistenceInterface.php';

class DatabaseAdapter implements PersistenceInterface
{
    private string $table;
    private string $primaryKey;
    private Database $database;

    public function __construct(string $table, string $primaryKey, Database $database)
    {
        $this->table = $table;
        $this->primaryKey = $primaryKey;
        $this->database = $database;
    }

    public function persist(array $data): void
    {
        if (isset($data[$this->primaryKey]) && $data[$this->primaryKey] === null) {
            unset($data[$this->primaryKey]);
        }

        $columns = implode(', ', array_keys($data));
        $placeholders = implode(', ', array_fill(0, count($data), '?'));
        
        $sql = "INSERT INTO {$this->table} ({$columns}) VALUES ({$placeholders})";
        $this->database->sqlQuery($sql, array_values($data));
    }
}
