<?php

namespace App\Service;

use App\Entity\Produit;
use App\Persistence\ProductPersistenceInterface;

class ProductAdapter
{
    private $persistence;

    public function __construct(ProductPersistenceInterface $persistence)
    {
        $this->persistence = $persistence;
    }

    public function save(Produit $produit): bool
    {
        // Utilisez la méthode de persistence pour sauvegarder le produit
        return $this->persistence->save($produit);
    }
}
