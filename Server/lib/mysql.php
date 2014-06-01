<?php

class MySQL {
  private static $instance = NULL;

  private function __construct() { }
  private function __clone() { }
 
  public static function getInstance() {
  	//echo "12";
    if (!self::$instance) {
   
    	//echo "11";
      self::$instance = new PDO('mysql:host=localhost;dbname=my_city', 'root', 'binarystargate', $options);;
      self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }
    return self::$instance;
  }
}