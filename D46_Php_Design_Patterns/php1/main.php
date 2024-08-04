<?php

use App\Database;
use App\Product;
use App\ProductRepository;
use App\JSONPersistanceAdapter;

$product = new Product(
    id: 1,
    univers: 'Weapon',
    designation: 'FkingBigSword',
    price: 1200
);

$dsn = 'mysql://root:@127.0.0.1:3306/app?serverVersion=10.11.2-MariaDB&charset=utf8mb4';

// Save in Database
$productRepositoryDatabase = new ProductRepository(
    new Database($dsn)
);
$productRepositoryDatabase->save($product);


// Save as JSON
$productRepositoryJSON = new ProductRepository(
    new JSONPersistanceAdapter('products.json')
);

$productRepositoryJSON->save($product);