<?php

namespace App\Service;

use App\Entity\Product;

class JsonFileAdapter implements PersistenceAdapter
{
    private $filePath;

    public function __construct(string $projectDir)
    {
        $this->filePath = $projectDir . '/products.json';
    }

    public function saveProduct(Product $product): void
    {
        $products = [];

        if (file_exists($this->filePath)) {
            $products = json_decode(file_get_contents($this->filePath), true);
        }

        $products[] = [
            'id' => $product->getId(),
            'name' => $product->getName(),
            'price' => $product->getPrice(),
        ];

        file_put_contents($this->filePath, json_encode($products, JSON_PRETTY_PRINT));
    }

    public function removeProduct(Product $product): void
    {
        if (!file_exists($this->filePath)) {
            return;
        }

        $products = json_decode(file_get_contents($this->filePath), true);
        $products = array_filter($products, fn($p) => $p['id'] !== $product->getId());

        file_put_contents($this->filePath, json_encode($products, JSON_PRETTY_PRINT));
    }
}
