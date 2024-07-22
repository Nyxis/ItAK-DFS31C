<?php
namespace App\Service;

use App\Contract\TargetInterface;

class ConcreteService implements TargetInterface {
    public function request() {
        // Implémentation spécifique
        echo "Request handled by ConcreteService";
    }
}
?>