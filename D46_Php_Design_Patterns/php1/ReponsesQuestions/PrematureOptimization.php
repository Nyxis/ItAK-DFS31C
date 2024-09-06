<?php

// Optimisation trop tôt dans la prod
// Essayer d'optimiser le code avant qu'il soit bien fonctionnel et si c'est même nécessaire

class PrematureOptimization
{
    public function __construct()
    {
    }

    function checkFixedHour() {
 
        $currentMinute = date('i');
    
        if ($currentMinute == '00') {
            return "C'est une heure fixe";
        } elseif ($currentMinute == '01') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '02') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '03') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '04') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '05') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '06') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '07') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '08') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '09') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '10') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '11') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '12') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '13') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '14') {
            echo "Ce n'est pas une heure fixe\n";
        } elseif ($currentMinute == '15') {
            echo "Ce n'est pas une heure fixe\n";
        }
    
        return "Optimisation trop tôt";
    }    
}