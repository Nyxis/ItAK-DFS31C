<?php

namespace App\Product;

class Product
{
    public int $id;
    public string $designation;
    public string $univers;
    public int $price;

    public function __construct(int $id = 0, string $designation = '', string $univers = '', int $price = 0)
    {
        $this->id = $id;
        $this->designation = $designation;
        $this->univers = $univers;
        $this->price = $price;
    }
}