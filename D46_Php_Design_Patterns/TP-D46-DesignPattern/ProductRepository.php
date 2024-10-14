<?php

namespace App\Product;

class ProductRepository
{
    private PersistenceInterface $persistence;

    public function setPersistence(PersistenceInterface $persistence): void
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
