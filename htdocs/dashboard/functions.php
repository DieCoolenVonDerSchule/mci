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
  $sql = 'SELECT PT.transId, transNr, personName, von, bis FROM PERSONEN_TRANSPONDER PT JOIN PERSONEN P ON (P.personId=PT.personId) JOIN TRANSPONDER T ON (T.transId=PT.transId);';
  $query = mysqli_query($con,$sql);
  return $query;
}

function getSearchedRoom() {
  $con = getConnection();
  $sql = 'SELECT * FROM ausleihe';
  $query = mysqli_query($con,$sql);
  return $query;
}

?>
