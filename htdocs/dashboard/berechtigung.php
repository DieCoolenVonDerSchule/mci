<?php

include_once ('header.php');

$pdo = new PDO('mysql:host=localhost;dbname=transpondersystem', 'root', '');

$personNr=$_POST["inputmatnr"];
$raumNr=$_POST["inputroom"];

$sql='SELECT * FROM PERSONEN_RAEUME PR
JOIN RAEUME R ON (PR.raumId=R.raumId)
JOIN PERSONEN P ON (PR.personId=P.personId)
WHERE (R.raumNr=:raumNr AND P.personNr=:personNr)';

$statement = $pdo->prepare($sql);
$result = $statement->execute(array('raumNr' => $raumNr, 'personNr' => $personNr));
$accessarray = $statement->fetch();


if ($accessarray !== false) {
  ?>
  <h3 class="text-center" style="margin-top: 4%;"><span class="label text-success">ist berechtigt</span></h3>
  <form method="post" class="form-group form-control-lg ">
    <div class="text-center">
      <button formaction="index.php" type="submit"  class="btn btn-primary mb-3">OK</button>
    </div>

  </form>
  <?php
}
else {
  ?>
  <h3 class="text-center" style="margin-top: 4%;"><span class="label text-danger">ist nicht berechtigt</span></h3>
  <form method="post" class="form-group form-control-lg ">
    <div class="text-center">
      <button formaction="index.php" type="submit"  class="btn btn-primary mb-3">OK</button>
    </div>

  </form>

  <?php 
}

?>
