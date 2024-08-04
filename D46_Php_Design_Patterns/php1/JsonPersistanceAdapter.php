<?php
namespace App;
use App\PersistanceInterface;
class JSONPersistanceAdapter implements PersistanceInterface {
    protected string $JASONPath;

    public function __construct(string $JASONPath) {
        $this->JASONpath = $JASONPath;
    }

    public function save(array $data)   {
        file_put_contents($this->JASONPath, json_encode($data) . PHP_EOL, FILE_APPEND);
    }
}