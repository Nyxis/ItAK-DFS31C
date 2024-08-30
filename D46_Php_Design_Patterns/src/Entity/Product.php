<?php
// src/Entity/Product.php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
#[ORM\Table(name: "product")]
class Product
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private int $id;

    #[ORM\Column(type: "string", length: 255)]
    private string $designation;

    #[ORM\Column(type: "string", length: 255)]
    private string $univers;

    #[ORM\Column(type: "integer")]
    private int $price;

    // Getters and setters...

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getDesignation(): ?string
    {
        return $this->designation;
    }

    public function setDesignation(string $designation): self
    {
        $this->designation = $designation;

        return $this;
    }

    public function getUnivers(): ?string
    {
        return $this->univers;
    }

    public function setUnivers(string $univers): self
    {
        $this->univers = $univers;

        return $this;
    }

    public function getPrice(): ?int
    {
        return $this->price;
    }

    public function setPrice(int $price): self
    {
        $this->price = $price;

        return $this;
    }
}
