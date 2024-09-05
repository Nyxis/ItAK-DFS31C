<?php

namespace App\Service;

use App\Entity\Product;

class JsonProductPersister
{
    private string $filePath;

    public function __construct(string $projectDir)
    {
        $this->filePath = $projectDir . '/var/products.json';
    }

    public function save(Product $product): void
    {
        $data = [
            'id' => $product->getId(),
            'designation' => $product->getDesignation(),
            'univers' => $product->getUnivers(),
            'price' => $product->getPrice(),
        ];

        $existingData = file_exists($this->filePath) ? json_decode(file_get_contents($this->filePath), true) : [];
        $existingData[] = $data;

        file_put_contents($this->filePath, json_encode($existingData, JSON_PRETTY_PRINT));
    }
}
