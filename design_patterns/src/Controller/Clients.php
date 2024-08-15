<?php

namespace App\Controller;

use App\Contract\TargetInterface;
use App\Service\ProductRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class ClientController extends AbstractController
{
    private $service;

    public function __construct(TargetInterface $service) {
        $this->service = $service;
    }

    public function doSomething(ProductRepository $productRepository) {
        $this->service->request();
    }
}


?>