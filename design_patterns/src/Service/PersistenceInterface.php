<?php
namespace App\Service;

use App\Entity\Product;

interface PersistenceInterface
{
    public function save(array $productData): bool ; 
}

?>