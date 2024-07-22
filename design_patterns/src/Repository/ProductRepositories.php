<?php

namespace App\Repository;

use App\Entity\Product;
use App\Service\PersistenceInterface;
use App\Service\DatabaseAdapter;

class ProductRepository
{
    private $persistence;

    public function __construct(PersistenceInterface $persistence)
    {
        $this->persistence = $persistence;
    }

    public function save(Product $product)
    {
        return $this->persistence->saveProduct([
            'id' => $product->id,
            'designation' => $product->designation,
            'univers' => $product->univers,
            'price' => $product->price
        ]);
    }
}