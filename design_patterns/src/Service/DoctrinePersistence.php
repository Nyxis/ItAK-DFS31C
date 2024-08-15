<?php

namespace App\Service;

use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;

class DoctrinePersistence implements PersistenceInterface
{
    public function __construct(private EntityManagerInterface $entityManager)
    {
    }

    public function saveProduct(array $productData): bool
    {
        $product = new Product();
        $product->setId($productData['id']);
        $product->setDesignation($productData['designation']);
        $product->setUnivers($productData['univers']);
        $product->setPrice($productData['price']);

        $this->entityManager->persist($product);
        $this->entityManager->flush();

        return true;
    }
}