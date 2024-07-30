<?php
namespace App\Repository;
interface PersistanceInterface
{
    public function save(Array $data);
}