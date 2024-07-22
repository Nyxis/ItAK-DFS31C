<?php

namespace App\Product;

class JsonFileAdapater implements PersistenceInterface
{
    private string $filename;

    public function __construct(string $filename)
    {
        $this->filename = $filename;
    }

    public function save(array $data): void
    {
        $jsonData = json_encode($data);
        file_put_contents($this->filename, $jsonData . PHP_EOL, FILE_APPEND);
    }
}