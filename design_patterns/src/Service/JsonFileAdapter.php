<?php

namespace App\Service;

class JsonFileAdapter implements PersistenceInterface
{
    private $filePath;

    public function __construct(string $filePath)
    {
        $this->filePath = $filePath;
    }

    public function saveProduct(array $productData)
    {
        $jsonData = json_encode($productData);
        file_put_contents($this->filePath, $jsonData);
    }
}