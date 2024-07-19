<?php
require_once 'Product.php';
require_once 'ProductRepository.php';
require_once 'Database.php';
require_once 'DatabaseAdapter.php';
require_once 'JsonFileAdapter.php';
require_once 'PersistenceAdapter.php';

// Настройки подключения к базе данных
$host = 'localhost';
$dbname = 'testdb'; // Убедитесь, что эта база данных существует
$username = 'root'; // Используйте имя пользователя MySQL (по умолчанию 'root')
$password = ''; // Убедитесь, что пароль корректен (по умолчанию пустой)

try {
    // Создайте новое подключение PDO
    $connexion = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Пример использования с базой данных
    $database = new Database();
    $databaseAdapter = new DatabaseAdapter($database, $connexion);

    $productRepository = new ProductRepository($databaseAdapter);
    $product1 = new Product(1, 'Product1', 'Category1', 100);
    $productRepository->save($product1);

    

    echo "Product saved to database successfully.<br>";

} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage() . "<br>";
}

// Пример использования с JSON файлом
$jsonFileAdapter = new JsonFileAdapter('products.json');
$productRepository = new ProductRepository($jsonFileAdapter);

$product2 = new Product(2, 'Product2', 'Category2', 200);
$productRepository->save($product2);

echo "Product saved to JSON file successfully.<br>";
?>
