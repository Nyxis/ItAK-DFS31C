<?php


require 'vendor/autoload.php';

use App\Product;
use App\ProductRepository;
use App\DatabaseAdapter;
use App\Database;

$product = new Product(
    id: null,
    univers: 'Weapon',
    designation: 'FkingBigSword',
    price: 1200
);

$database = new Database(
    'mysql:host=localhost;dbname=app;charset=utf8mb4',
    'appuser',  // Remplacez par votre nom d'utilisateur MySQL
    'your_password_here'  // Remplacez par votre mot de passe MySQL
);

$databaseAdapter = new DatabaseAdapter(
    table: 'products',
    primaryKey: 'id',
    database: $database
);

$productRepository = new ProductRepository($databaseAdapter);
$productRepository->save($product);

echo "Produit sauvegardé avec succès!\n";