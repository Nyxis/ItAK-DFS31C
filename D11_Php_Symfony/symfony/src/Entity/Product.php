<?php
namespace App\Entity;

class Product
{
    public function __construct(
        public ?int $id = null,
        public string $designation = '',
        public string $univers = '',
        public int $price = 0
    ){
    }

    public function toArray(): array
    {
        return [
            'id' => $this->id,
            'designation' => $this->designation,
            'univers' => $this->univers,
            'price' => $this->price
        ];
    }
}
