<?php

namespace App\Service;

use App\Contract\TargetInterface;

class Client {
    private $target;

    public function __construct(TargetInterface $target) {
        $this->target = $target;
    }

    public function execute() {
        return $this->target->request();
    }
}