<?php
session_start();

include_once ('header.php');

include_once('functions.php');
?>

<h2> Raum verleihen: </h2>
<form method="post" class="form-group form-control-lg ">
  <div class="form-group row">
    <label for="inputroom" class="col-sm-1 col-form-label">Raum:</label>
    <div class="col-sm-10">
      <input type="room" class="form-control-lg" name="inputroom" placeholder="0.401">
    </div>
  </div>

  <div class="form-group row">
    <label for="inputmatnr" class="col-sm-1 col-form-label">Martikelnummer:</label>
    <div class="col-sm-10">
      <input type="matnr" class="form-control-lg" name="inputmatnr" placeholder="11132500">
    </div>
  </div>
  <div class="form-group row">
    <label for="inputdate" class="col-sm-1 col-form-label">Zeitraum:</label>
    <div class="col-sm-10">
      <input type="von" class="form-control-lg" name="inputvon" placeholder="von">
      <input type="bis" class="form-control-lg" name="inputbis" placeholder="bis">
    </div>
  </div>
  <button formaction="ausleihen.php" type="submit"  class="btn btn-primary mb-3">Raum ausleihen</button>
  <button formaction="berechtigung.php" type="submit"  class="btn btn-primary mb-3">Berechtigungen überprüfen</button>

</form>





<?php
 include_once ('footer.php');
?>
