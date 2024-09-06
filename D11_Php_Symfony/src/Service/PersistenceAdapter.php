<?php

namespace App\Service;

use App\Entity\Product;

interface PersistenceAdapter
{
    public function saveProduct(Product $product): void;
}
