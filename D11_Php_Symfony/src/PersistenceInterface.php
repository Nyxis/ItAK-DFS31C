<?php

namespace App;

interface PersistenceInterface
{
    public function persist(array $data): void;
}
