<?php

namespace App\Product;

interface PersistenceInterface
{
    public function save(array $data): void;
}