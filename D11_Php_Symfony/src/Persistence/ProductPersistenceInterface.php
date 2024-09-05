<?php

namespace App\Persistence;

use App\Entity\Product;

interface ProductPersistenceInterface
{
    public function save(Product $produit): bool;
}
