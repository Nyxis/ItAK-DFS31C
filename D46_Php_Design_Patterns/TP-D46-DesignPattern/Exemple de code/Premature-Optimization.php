<?php

function calculateTotal($items) {
    $total = 0;
    $count = count($items);
    for ($i = 0; $i < $count; $i++) {
        $total += $items[$i]->price;
    }
    return $total;
}