<?php
class Adapter implements TargetInterface {
    private $adaptee;

    public function __construct(Adaptee $adaptee) {
        $this->adaptee = $adaptee;
    }

    public function request() {
        // Adapter l'appel à la méthode spécifique de l'adaptee
        return $this->adaptee->specificRequest();
    }
}
?>
//Implémente l’interface cible et adapte l’interface de la classe à adapter.