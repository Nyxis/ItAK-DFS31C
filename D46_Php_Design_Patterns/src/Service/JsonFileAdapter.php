<?php
// src/Service/JsonFileAdapter.php
namespace App\Service;

use App\Entity\Product;

class JsonFileAdapter implements PersistenceInterface
{
    private string $filePath;

    public function __construct(string $filePath)
    {
        $this->filePath = $filePath;
    }

    public function save(Product $product): void
    {
        $data = json_encode([
            'id' => $product->getId(),
            'designation' => $product->getDesignation(),
            'univers' => $product->getUnivers(),
            'price' => $product->getPrice(),
        ]);

        file_put_contents($this->filePath, $data . PHP_EOL, FILE_APPEND);
    }
}
?>