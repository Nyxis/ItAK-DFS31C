<?php
namespace App\Repository;
use App\Repository\PersistanceInterface;
class JSONPersistanceAdapter implements PersistanceInterface {
    protected string $jsonPath;

    public function __construct(string $jsonPath) {
        $this->jsonPath = $jsonPath;
    }

    public function save(array $data)   {
        file_put_contents($this->jsonPath, json_encode($data) . PHP_EOL, FILE_APPEND);
    }
}