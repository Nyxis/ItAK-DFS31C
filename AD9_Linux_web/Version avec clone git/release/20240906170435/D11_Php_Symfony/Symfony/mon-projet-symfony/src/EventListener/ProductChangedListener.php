<?php

namespace App\EventListener;

use App\Entity\Product;
use App\Service\JSONBackupDatabase;
use Doctrine\ORM\Event\PostPersistEventArgs;
use Doctrine\ORM\Event\PostRemoveEventArgs;
use Doctrine\ORM\Event\PostUpdateEventArgs;

class ProductChangedListener
{
    private $jsonBackupDatabase;

    public function __construct(JSONBackupDatabase $jsonBackupDatabase)
    {
        $this->jsonBackupDatabase = $jsonBackupDatabase;
    }

    public function postPersist(PostPersistEventArgs $args): void
    {
        $entity = $args->getObject();

        if ($entity instanceof Product) {
            $this->jsonBackupDatabase->synchronize();
        }
    }

    public function postUpdate(PostUpdateEventArgs $args): void
    {
        $entity = $args->getObject();

        if ($entity instanceof Product) {
            $this->jsonBackupDatabase->synchronize();
        }
    }

    public function postRemove(PostRemoveEventArgs $args): void
    {
        $entity = $args->getObject();

        if ($entity instanceof Product) {
            $this->jsonBackupDatabase->synchronize();
        }
    }
}
