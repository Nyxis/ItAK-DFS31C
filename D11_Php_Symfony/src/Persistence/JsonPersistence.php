<?php

namespace App\Persistence;

use App\Entity\Product;
use Symfony\Component\Filesystem\Filesystem;
use Symfony\Component\Filesystem\Exception\IOExceptionInterface;

class JsonPersistence implements ProductPersistenceInterface
{
    private $filePath;

    public function __construct(string $filePath)
    {
        $this->filePath = $filePath;
    }

    public function save(Product $product): bool
    {
        $fs = new Filesystem();

        if (!$fs->exists(dirname($this->filePath))) {
            $fs->mkdir(dirname($this->filePath));
        }

        try {
            $data = ['name' => $product->getName()];
            $json = json_encode($data, JSON_PRETTY_PRINT);
            $fs->dumpFile($this->filePath, $json);
            return true;
        } catch (IOExceptionInterface $exception) {
            return false;
        }
    }
}
