<?php
namespace App;

class Product
{
    public function __construct(
        public ?int $id,
        public string $designation,
        public string $univers,
        public int $price
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
