<?php

namespace App;

require_once 'PersistenceInterface.php';

class JsonFileAdapter implements PersistenceInterface
{
    private string $filename;

    public function __construct(string $filename)
    {
        $this->filename = $filename;
    }

    public function persist(array $data): void
    {
        $existingData = [];
        if (file_exists($this->filename)) {
            $existingData = json_decode(file_get_contents($this->filename), true) ?? [];
        }
        $existingData[] = $data;
        file_put_contents($this->filename, json_encode($existingData, JSON_PRETTY_PRINT));
    }
}
