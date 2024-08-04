<?php

namespace App\Controller;

use App\Entity\Product;
use App\Form\ProductType;
use App\Repository\ProductRepository;
use App\Service\JSONBackupDatabase;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * Contrôleur pour gérer les opérations CRUD sur les produits.
 */
class ProductController extends AbstractController
{
    private $productRepository;
    private $jsonBackupDatabase;

    /**
     * Constructeur: initialise le repository et le service de sauvegarde JSON.
     */
    public function __construct(ProductRepository $productRepository, JSONBackupDatabase $jsonBackupDatabase)
    {
        $this->productRepository = $productRepository;
        $this->jsonBackupDatabase = $jsonBackupDatabase;
    }

    /**
     * Affiche la liste de tous les produits.
     */
    #[Route('/products', name: 'product_list')]
    public function list(): Response
    {
        $products = $this->productRepository->findAll();
        return $this->render('product/product_list.html.twig', [
            'products' => $products,
        ]);
    }

    /**
     * Crée un nouveau produit.
     */
    #[Route('/product/create', name: 'product_create')]
    public function create(Request $request): Response
    {
        $product = new Product();
        $form = $this->createForm(ProductType::class, $product);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // Sauvegarde du produit et synchronisation avec la sauvegarde JSON
            $this->productRepository->save($product, true);
            $this->jsonBackupDatabase->synchronize();
            
            $this->addFlash('success', 'Le produit a été créé avec succès.');
            return $this->redirectToRoute('product_show', ['id' => $product->getId()]);
        }

        return $this->render('product/create.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    /**
     * Affiche les détails d'un produit spécifique.
     */
    #[Route('/product/{id}', name: 'product_show')]
    public function show(Product $product): Response
    {
        return $this->render('product/product_show.html.twig', [
            'product' => $product
        ]);
    }

    /**
     * Modifie un produit existant.
     */
    #[Route('/product/{id}/edit', name: 'product_edit')]
    public function edit(Request $request, Product $product): Response
    {
        $form = $this->createForm(ProductType::class, $product);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // Mise à jour du produit et synchronisation avec la sauvegarde JSON
            $this->productRepository->save($product, true);
            $this->jsonBackupDatabase->synchronize();
            
            $this->addFlash('success', 'Le produit a été mis à jour avec succès.');
            return $this->redirectToRoute('product_show', ['id' => $product->getId()]);
        }

        return $this->render('product/product_edit.html.twig', [
            'form' => $form->createView(),
            'product' => $product,
        ]);
    }

    /**
     * Supprime un produit.
     */
    #[Route('/product/{id}/delete', name: 'product_delete', methods: ['POST'])]
    public function delete(Request $request, Product $product): Response
    {
        if ($this->isCsrfTokenValid('delete'.$product->getId(), $request->request->get('_token'))) {
            // Suppression du produit et synchronisation avec la sauvegarde JSON
            $this->productRepository->remove($product, true);
            $this->jsonBackupDatabase->synchronize();
            
            $this->addFlash('success', 'Le produit a été supprimé avec succès.');
        }

        return $this->redirectToRoute('product_list');
    }
}
