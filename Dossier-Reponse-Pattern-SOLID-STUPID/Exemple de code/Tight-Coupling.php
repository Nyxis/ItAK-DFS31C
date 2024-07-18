<?php 
class Report {
    public function generate() {
        $db = new MySQLDatabase();
        $data = $db->query("SELECT * FROM users");
       
    }
}