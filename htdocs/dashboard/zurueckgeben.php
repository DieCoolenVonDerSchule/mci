<?php
include_once('header.php');
include_once('functions.php');


$pdo = new PDO('mysql:host=localhost;dbname=transpondersystem', 'root', '');


$transId=$_GET["transId"];


$sql='DELETE FROM PERSONEN_TRANSPONDER
WHERE (transId=:transId)';


$statement = $pdo->prepare($sql);
$result = $statement->execute(array('transId' => $transId));
$statement->fetch();

header('location: awardedTransponder.php');
exit();

?>
