<?php
class Product
{
    public int $id;
    public string $designation;
    public string $univers;
    public int $price;

    public function __construct(int $id, string $designation, string $univers, int $price)
    {
        $this->id = $id;
        $this->designation = $designation;
        $this->univers = $univers;
        $this->price = $price;
    }
}
?>
