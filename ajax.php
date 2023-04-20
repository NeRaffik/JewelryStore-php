<?php

spl_autoload_register(function ($class) { include 'Server/' . $class . '.php'; });

$result = Queries::getInfo(Queries::productsInfo());

 $CATALOG = array();

 while($res = $result->fetch()){
     $CATALOG[] = $res;
 }

$jsonString = json_encode($CATALOG); //, JSON_UNESCAPED_UNICODE

header('Content-type:application/json;charset=utf-8');

echo $jsonString;

exit();
?>




 
