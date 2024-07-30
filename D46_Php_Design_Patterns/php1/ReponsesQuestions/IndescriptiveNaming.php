<?php
use Twig\Sandbox\SecurityNotAllowedFunctionError;

// Le nomage non descriptif
// Ne pas nommer les variables, fonctions, classes, dossiers, fichiers, namespaces etc avec des noms ayant du sens.
// Cela rend le code difficile à lire et à comprendre pour les autres développeurs
// Cela rend la maintenance et le debug plus difficile
// Cela rend diffcile le fait de se remettre dans le code après un certain temps
// Cela rend le debug compliqué
// Bref, c'est vraiment pas fou

class IndescriptiveNaming {
    private $var1;
    private $var2;
    private $var3;
    private $var4;
    private $var5;

    public function __construct($var1, $var2, $var3, $var4, $var5) {
        $this->var1 = $var1;
        $this->var2 = $var2;
        $this->var3 = $var3;
        $this->var4 = $var4;
        $this->var5 = $var5;
    }
    public function addition1() {
        return $this->var1 + $this->var5;
    }
}