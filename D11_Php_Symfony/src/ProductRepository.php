<?php

namespace App;

require_once 'PersistenceInterface.php';

class ProductRepository
{
    protected PersistenceInterface $persistence;

    public function __construct(PersistenceInterface $persistence)
    {
        $this->persistence = $persistence;
    }

    public function save(Product $product): void
    {
        $this->persistence->persist([
            'id' => $product->id,
            'designation' => $product->designation,
            'univers' => $product->univers,
            'price' => $product->price,
        ]);
    }
}
