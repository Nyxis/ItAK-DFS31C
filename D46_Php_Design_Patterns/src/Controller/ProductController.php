<?php
// src/Controller/ProductController.php

namespace App\Controller;

use App\Entity\Product;
use App\Service\PersistenceInterface;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class ProductController extends AbstractController
{
    private PersistenceInterface $persistence;
    private EntityManagerInterface $entityManager;

    public function __construct(PersistenceInterface $persistence, EntityManagerInterface $entityManager)
    {
        $this->persistence = $persistence;
        $this->entityManager = $entityManager;
    }

    /**
     * @Route("/product/new", name="product_new")
     */
    public function new(Request $request): Response
    {
        if ($request->isMethod('POST')) {
            $product = new Product();
            $product->setDesignation($request->request->get('designation'));
            $product->setUnivers($request->request->get('univers'));
            $product->setPrice($request->request->get('price'));

            // Persist the product
            $this->entityManager->persist($product);
            $this->entityManager->flush();

            // Add a flash message
            $this->addFlash('success', 'Product added successfully.');

            // Redirect to the new product form page to stay on the same page
            return $this->redirectToRoute('product_new');
        }

        return $this->render('product/new.html.twig');
    }


    /**
     * @Route("/product", name="product_list")
     */
    public function list(): Response
    {
        $products = $this->entityManager->getRepository(Product::class)->findAll();

        return $this->render('product/list.html.twig', [
            'products' => $products,
        ]);
    }

    /**
     * @Route("/product/delete/{id}", name="product_delete", methods={"POST"})
     */
    /**
     * @Route("/product/delete/{id}", name="product_delete", methods={"POST"})
     */
    public function delete(Product $product): Response
    {
        $this->entityManager->remove($product);
        $this->entityManager->flush();

        $this->addFlash('success', 'Product deleted successfully.');

        return $this->redirectToRoute('product_list');
    }

}
?>
