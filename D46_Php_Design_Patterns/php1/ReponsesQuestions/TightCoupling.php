<?php

// Couplage fort
// Une classe est utilisée pour une créer autre classe
// Cela rend les classes dépendantes les unes des autres et complique la maintenance et le debug

require_once 'Singleton.php';
class TightCoupling
{
    private $singleton;

    public function __construct()
    {
        $this->singleton = new Singleton();
    }
    public function getSingleton()
    {
        return $this->singleton->isSingleton();
    }
}

$TC = new TightCoupling();