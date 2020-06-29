<?php

function getConnection(){
$mysqlhost="localhost";
$mysqluser="root";
$mysqlpwd="";
$mysqldb="transpondersystem";

$connection=mysqli_connect($mysqlhost, $mysqluser, $mysqlpwd, $mysqldb)
    or die("DB Conneciton ERROR!");
    return $connection;
}



function getAllawardedTransponder(){
  $con = getConnection();
  $sql = 'SELECT * FROM ausleihe';
  $query = mysqli_query($con,$sql);
  return $query;
}

?>
