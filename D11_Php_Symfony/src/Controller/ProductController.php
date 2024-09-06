<?php

namespace App\Controller;

use App\Entity\Product;
use App\Repository\ProductRepository;
use App\Service\DatabaseAdapter;
use App\Service\JsonFileAdapter;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;

class ProductController extends AbstractController
{
    private $databaseAdapter;
    private $jsonFileAdapter;
    private $productRepository;

    public function __construct(DatabaseAdapter $databaseAdapter, JsonFileAdapter $jsonFileAdapter, ProductRepository $productRepository)
    {
        $this->databaseAdapter = $databaseAdapter;
        $this->jsonFileAdapter = $jsonFileAdapter;
        $this->productRepository = $productRepository;
    }

    #[Route('/', name: 'homepage')]
    public function index(Request $request): Response
    {
        $product = new Product();

        $form = $this->createFormBuilder($product)
            ->add('name', TextType::class)
            ->add('price', NumberType::class)
            ->add('save', SubmitType::class, ['label' => 'Add Product'])
            ->getForm();

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->databaseAdapter->saveProduct($product);
            $this->jsonFileAdapter->saveProduct($product);
            return $this->redirectToRoute('homepage');
        }

        $products = $this->productRepository->findAll();

        return $this->render('products/index.html.twig', [
            'form' => $form->createView(),
            'products' => $products,
        ]);
    }

    #[Route('/product/delete/{id}', name: 'product_delete')]
    public function delete(int $id): Response
    {
        $product = $this->productRepository->find($id);

        if ($product) {
            $this->databaseAdapter->removeProduct($product);
            $this->jsonFileAdapter->removeProduct($product);
        }

        return $this->redirectToRoute('homepage');
    }
}
