<?php

include_once ('header.php');
include_once('functions.php');

$pdo = new PDO('mysql:host=localhost;dbname=transpondersystem', 'root', '');

$raumNr=$_POST["inputroom"];
$von=$_POST["inputvon"];
$bis=$_POST["inputbis"];
$matnr=$_POST["inputmatnr"];

$personId='SELECT personId FROM Personen WHERE :matnr=personNr';

$sql='SELECT * FROM TRANSPONDER T
JOIN TRANSPONDER_RAEUME TR ON (T.transId=TR.transId)
JOIN RAEUME R ON (TR.raumId=R.raumId)
WHERE NOT EXISTS (SELECT transId FROM PERSONEN_TRANSPONDER PT WHERE T.transId=PT.transId)
AND R.raumNr=:raumNr LIMIT 1';

$statement = $pdo->prepare($sql);
$result = $statement->execute(array('raumNr' => $raumNr));
$transponderarray = $statement->fetch();

$statement = $pdo->prepare($personId);
$result = $statement->execute(array('matnr' => $matnr));
$personIdArray = $statement->fetch();

if ($transponderarray !== false) {
  ?>
    <h3 class="text-center" style="margin-top: 4%;"><span class="label label-default"><?php echo 'Transpondernummer: '.$transponderarray['transNr']; ?> </span></h3>
    <div class="text-center" style="margin-top: 10%;">
    <img width="20%" src="https://www.bf-trader.de/wp-content/uploads/2018/02/unterschrift.png"  class="img-fluid " alt="Responsive image">
    <p>____________________________________________________</p>
    <h4>Unterschrift</h4>
    </div>
    <div class="">


    <form method="post" class="form-group form-control-lg ">

      <?php
      echo '<td class="btn-group">
          <a type="button" class="btn btn-primary mb-3 float-right" href="insertAusleihe.php?personId='.$personIdArray['personId'].'&transId='.$transponderarray['transId'].'&von='.$von.'&bis='.$bis.'">ausleihen</a>
      </td>';
       ?>

      <button  formaction="index.php"class="btn btn-primary mb-3 float-right" style="margin-right: 1%;">abbrechen</button>
    </form>
      <?php
} else {
?>
<h3 class="text-center" style="margin-top: 4%;"><span class="label label-default">Kein Transponder verfügbar</span></h3>
<form method="post" class="form-group form-control-lg ">
  <button formaction="index.php" type="submit"  class="btn btn-primary mb-3 float-right">abbrechen</button>
</form>

<?php
}


 include_once ('footer.php');

?>
