<?php

namespace App\Service;

use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Filesystem\Filesystem;

class JSONBackupDatabase
{
    private $entityManager;
    private $projectDir;
    private $filesystem;

    public function __construct(EntityManagerInterface $entityManager, string $projectDir)
    {
        $this->entityManager = $entityManager;
        $this->projectDir = $projectDir;
        $this->filesystem = new Filesystem();
    }

    public function synchronize(): void
    {
        $products = $this->entityManager->getRepository(Product::class)->findAll();

        $data = [
            'last_updated' => (new \DateTime())->format('Y-m-d H:i:s'),
            'products' => []
        ];

        foreach ($products as $product) {
            $data['products'][] = [
                'id' => $product->getId(),
                'designation' => $product->getDesignation(),
                'univers' => $product->getUnivers(),
                'price' => $product->getPrice()
            ];
        }

        $json = json_encode($data, JSON_PRETTY_PRINT);
        $backupDir = $this->projectDir . '/var/backup';
        $this->filesystem->mkdir($backupDir);
        file_put_contents($backupDir . '/products_backup.json', $json);
    }
}
