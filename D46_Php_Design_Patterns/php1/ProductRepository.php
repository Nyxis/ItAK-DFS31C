<?php
namespace App;
use App\PersistanceInterface;
use App\Product;

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