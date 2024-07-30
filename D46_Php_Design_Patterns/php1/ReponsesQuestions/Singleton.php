<?php

// Singleton pattern
// Le Singleton consiste à n'avoir qu'une seule instance d'une classe pour un seul objet.
// Attention, ça rend le concepte de classe inutile

class Singleton
{
    private static bool $exists;
    private function __construct()
    {
        $this->exists = true;
    }

    public function isSingleton()
    {
        if ($this->exists) {
            return "C'est un singleton";
        } else {
            return "null";
        }
    }
}