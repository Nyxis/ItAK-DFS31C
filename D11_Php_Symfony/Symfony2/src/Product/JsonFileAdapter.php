<?php

namespace App\Product;

class JsonFileAdapter implements PersistenceInterface
{
    private $filename;

    public function __construct(string $filename)
    {
        $this->filename = $filename;
    }

    public function save(array $data): void
    {
        $currentData = file_exists($this->filename) ? json_decode(file_get_contents($this->filename), true) : [];
        $currentData[] = $data;
        file_put_contents($this->filename, json_encode($currentData, JSON_PRETTY_PRINT));
    }
}