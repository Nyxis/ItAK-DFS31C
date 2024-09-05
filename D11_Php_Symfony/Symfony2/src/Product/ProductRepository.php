<?php

namespace App\Product;

class ProductRepository
{
    private $persistence;

    public function __construct(PersistenceInterface $persistence)
    {
        $this->persistence = $persistence;
    }

    public function save(Product $product): void
    {
        $data = [
            'id' => $product->id,
            'designation' => $product->designation,
            'univers' => $product->univers,
            'price' => $product->price
        ];
        $this->persistence->save($data);
    }
}