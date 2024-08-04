<?php

// Duplication:
// Eviter les répétitions du même code à plusieurs endroits
// Maintenance plus compliqué, il faut changer à chaque endroit
// Plus difficile à lire

class Duplication
{
    public function __construct()
    {}
    public function moyenne($a, $b, $c)
    {
        return ($a + $b + $c) / 3;
    }
    public function sommeTotale($a, $b, $c)
    {
        return $a + $b + $c;
    }
}