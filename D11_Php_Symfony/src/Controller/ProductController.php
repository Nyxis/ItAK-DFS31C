<?php
// src/Controller/ProductController.php

namespace App\Controller;

use App\Entity\Product;
use App\Form\ProductType;
use App\Service\ProductAdapter;
use App\Repository\ProductRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class ProductController extends AbstractController
{
    private $productAdapter;
    private $productRepository;

    public function __construct(ProductAdapter $productAdapter, ProductRepository $productRepository)
    {
        $this->productAdapter = $productAdapter;
        $this->productRepository = $productRepository;
    }

    #[Route('/product', name: 'produit_create')]
    public function create(Request $request): Response
    {
        $product = new Product();
        $form = $this->createForm(ProductType::class, $product);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $success = $this->productAdapter->save($product);

            // Ajouter un message de succès ou d'erreur à la session
            if ($success) {
                $this->addFlash('success', 'Produit enregistré avec succès !');
            } else {
                $this->addFlash('error', 'Échec de l\'enregistrement du produit.');
            }

            // Rediriger pour éviter la soumission du formulaire à nouveau
            return $this->redirectToRoute('produit_create');
        }

        return $this->render('product/create.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    #[Route('/product_list', name: 'produit_list')]
    public function list(): Response
    {
        $produits = $this->productRepository->findAll();
        $threshold = 100; // Exemple de seuil pour afficher ✨

        return $this->render('product/list.html.twig', [
            'produits' => $produits,
            'threshold' => $threshold,
        ]);
    }
}
