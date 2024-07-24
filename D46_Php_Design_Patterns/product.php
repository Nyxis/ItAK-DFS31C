<?php

class Product
{
    public $id;
    public $designation;
    public $univers;
    public $price;

    public function isValid()
    {
        // Logique de validation
        if (empty($this->designation) || empty($this->univers) || $this->price <= 0) {
            return false;
        }
        return true;
    }
}

