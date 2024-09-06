<?php
namespace App\Controller;

use App\Entity\Product;
use App\Repository\DatabasePersistance;
use App\Repository\ProductRepository;
use App\Repository\JSONPersistanceAdapter;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use App\Form\ProductCreationForm;

class MainController extends AbstractController
{
    private string $jsonPath;
    private string $databaseUrl;

    public function __construct(string $jsonPath, string $databaseUrl)
    {
        $this->jsonPath = $jsonPath;
        $this->databaseUrl = $databaseUrl;
    }

    #[Route('/product/create', name: 'create_product')]
    public function createProduct(Request $request): Response
    {
        $product = new Product();
        $form = $this->createForm(ProductCreationForm::class, $product);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // Save in Database
            $productRepositoryDatabase = new ProductRepository(
                new DatabasePersistance($this->databaseUrl, 'root')
            );
            $productRepositoryDatabase->save($product);

            // Save as JSON
            $productRepositoryJSON = new ProductRepository(
                new JSONPersistanceAdapter($this->jsonPath)
            );
            $productRepositoryJSON->save($product);

            return new Response(
                $this->render('Product/createProduct.html.html.twig', [
                    'message' => 'Product saved successfully in both Database and JSON file!'
                ])
            );
        }

        return $this->render('Product/createProduct.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}
