<?php
require_once 'PersistenceAdapter.php';
require_once 'Product.php';

class JsonFileAdapter implements PersistenceAdapter
{
    private string $filePath;

    public function __construct(string $filePath)
    {
        $this->filePath = $filePath;
    }

    public function saveProduct(Product $product)
    {
        $data = json_encode([
            'id' => $product->id,
            'designation' => $product->designation,
            'univers' => $product->univers,
            'price' => $product->price,
        ]);

        file_put_contents($this->filePath, $data . PHP_EOL, FILE_APPEND);
    }
}
?>
