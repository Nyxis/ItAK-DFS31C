<?php

namespace App\Repository;

use App\Entity\Product;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * Repository pour l'entité Product.
 * Étend ServiceEntityRepository pour bénéficier des fonctionnalités de base de Doctrine.
 */
class ProductRepository extends ServiceEntityRepository
{
    /**
     * Constructeur du repository.
     * 
     * @param ManagerRegistry $registry Le registre de gestion des entités Doctrine.
     */
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Product::class);
    }

    /**
     * Sauvegarde un produit dans la base de données.
     * 
     * @param Product $product Le produit à sauvegarder.
     * @param bool $flush Si vrai, exécute immédiatement la requête en base de données.
     */
    public function save(Product $product, bool $flush = false): void
    {
        $this->getEntityManager()->persist($product);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * Supprime un produit de la base de données.
     * 
     * @param Product $product Le produit à supprimer.
     * @param bool $flush Si vrai, exécute immédiatement la requête en base de données.
     */
    public function remove(Product $product, bool $flush = false): void
    {
        $this->getEntityManager()->remove($product);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }
}
