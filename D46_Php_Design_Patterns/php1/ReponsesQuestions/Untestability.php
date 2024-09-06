<?php

// Le code est difficilement testable
// Car trop de variables en entrée par exemple

class Intestability {
    private $arg1;
    private $arg2;
    private $arg3;
    private $arg4;
    private $arg5;

    public function __construct($arg1, $arg2, $arg3, $arg4, $arg5) {
        $this->arg1 = $arg1;
        $this->arg2 = $arg2;
        $this->arg3 = $arg3;
        $this->arg4 = $arg4;
        $this->arg5 = $arg5;
    }
public function getArg1() { return $this->arg1; }
public function getArg2() { return $this->arg2; }
public function getArg3() { return $this->arg3; }
public function getArg4() { return $this->arg4; }
public function getArg5() { return $this->arg5; }

}