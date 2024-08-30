<?php

namespace App\Persistence;

use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;

class SqlPersistence implements ProductPersistenceInterface
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function save(Product $product): bool
    {
        try {
            $this->entityManager->persist($product);
            $this->entityManager->flush();
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }
}
