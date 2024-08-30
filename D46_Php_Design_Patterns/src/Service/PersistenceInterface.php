<?php
// src/Service/PersistenceInterface.php
namespace App\Service;

use App\Entity\Product;

interface PersistenceInterface
{
    public function save(Product $product): void;
}
?>