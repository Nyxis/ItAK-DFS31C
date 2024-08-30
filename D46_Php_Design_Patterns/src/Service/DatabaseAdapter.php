<?php
// src/Service/DatabaseAdapter.php

namespace App\Service;

use Doctrine\ORM\EntityManagerInterface;
use App\Repository\ProductRepository;

class DatabaseAdapter implements PersistenceInterface
{
    private EntityManagerInterface $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function save($entity): void
    {
        $this->entityManager->persist($entity);
        $this->entityManager->flush();
    }

    public function getProductRepository(): ProductRepository
    {
        return $this->entityManager->getRepository(Product::class);
    }
}
?>
