<?php
require_once 'src/Database.php';
require_once 'src/DatabaseAdapter.php';
require_once 'src/PersistenceInterface.php';
require_once 'src/Product.php';
require_once 'src/ProductRepository.php';

use App\Database;
use App\DatabaseAdapter;
use App\Product;
use App\ProductRepository;

$product = new Product(
    id: null,
    designation: 'FkingBigSword',
    univers: 'Weapon',
    price: 1200
);

$dsn = 'mysql:host=localhost;dbname=test_db';
$username = 'root';
$password = '159159';

$database = new Database($dsn, $username, $password);
$adapter = new DatabaseAdapter('products', 'id', $database);
$productRepository = new ProductRepository($adapter);

$productRepository->save($product);
echo "Product saved to database successfully!";
