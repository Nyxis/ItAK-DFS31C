<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HelloWorldController extends AbstractController
{
    #[Route('/hello_world', name: 'hello_world')]
    public function __invoke(): Response
    {
        return $this->render('hello_world.html.twig');
    }
}