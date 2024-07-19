<?php
require_once 'PersistenceAdapter.php';
require_once 'Product.php';

class ProductRepository
{
    private PersistenceAdapter $adapter;

    public function __construct(PersistenceAdapter $adapter)
    {
        $this->adapter = $adapter;
    }

    public function save(Product $product)
    {
        $this->adapter->saveProduct($product);
    }
}
?>
