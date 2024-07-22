<?php

namespace App;

class Product
{
    public function __construct(
        public ?int $id,
        public string $designation,
        public string $univers,
        public int $price
    ) {
    }
}
