<?php
require_once 'src/JsonFileAdapter.php';
require_once 'src/PersistenceInterface.php';
require_once 'src/Product.php';
require_once 'src/ProductRepository.php';

use App\JsonFileAdapter;
use App\Product;
use App\ProductRepository;

$product = new Product(
    id: null,
    designation: 'FkingBigSword',
    univers: 'Weapon',
    price: 1200
);

$filename = 'products.json';
$adapter = new JsonFileAdapter($filename);
$productRepository = new ProductRepository($adapter);

$productRepository->save($product);
echo "Product saved to JSON file successfully!";
