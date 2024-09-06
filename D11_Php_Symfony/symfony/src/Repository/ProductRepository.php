<?php
namespace App\Repository;
use App\Repository\PersistanceInterface;
use App\Entity\Product;

class ProductRepository
{
    public function __construct(
        protected PersistanceInterface $persistance
    ){}
    public function save(Product $product)
    {
        $data = $product->toArray();
        $this->persistance->save($data);
    }
}