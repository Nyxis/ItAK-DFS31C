<?php

namespace App\Controller;

use App\Product\Product;
use App\Product\ProductRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;

class ProductController extends AbstractController
{
    private $productRepository;

    public function __construct(ProductRepository $productRepository)
    {
        $this->productRepository = $productRepository;
    }

    #[Route('/product', name: 'product')]

    


    #[Route('/product/new', name: 'app_product_new')]
public function new(Request $request, ProductRepository $productRepository): Response
{
    $product = new Product();
    $form = $this->createForm(ProductType::class, $product);
    $form->handleRequest($request);

    if ($form->isSubmitted() && $form->isValid()) {
        $productRepository->save($product, true);
        return $this->redirectToRoute('app_product_list');
    }

    return $this->render('product/new.html.twig', [
        'form' => $form->createView(),
    ]);
}




    public function index(Request $request): Response
    {
        $product = new Product();

        $form = $this->createFormBuilder($product)
            ->add('designation', TextType::class)
            ->add('univers', TextType::class)
            ->add('price', NumberType::class)
            ->add('save', SubmitType::class, ['label' => 'Create Product'])
            ->getForm();

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $product = $form->getData();
            $this->productRepository->save($product);

            $this->addFlash('success', 'Product saved successfully!');
            return $this->redirectToRoute('product');
        }

        return $this->render('product/index.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}