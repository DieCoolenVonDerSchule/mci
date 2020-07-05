<?php
include_once('header.php');
include_once('functions.php');

$pdo = new PDO('mysql:host=localhost;dbname=transpondersystem', 'root', '');


$personId=$_GET["personId"];
$transId=$_GET["transId"];
$von=$_GET["von"];
$bis=$_GET["bis"];

$sql='INSERT INTO PERSONEN_TRANSPONDER VALUES (:personId, :transId, :von, :bis)';

$statement = $pdo->prepare($sql);
$result = $statement->execute(array('transId' => $transId, 'personId' => $personId,'von' => $von, 'bis' => $bis));

$statement->fetch();

header('location: awardedTransponder.php');
exit();

?>
