<?php

include_once ('header.php');
include_once('functions.php');
?>

<h2> Ausgeliehe Transponder </h2>

<table class="table table-striped table-bordered" style="width:100%">

<thead>
  <tr>
    <td>Transponder</td>
    <td>Ausleihender</td>
    <td>Ausgeliehen seit</td>
    <td>Ausgeliehen bis</td>
    <td>Abgeben</td>
  </tr>
  </thead>

  <tbody>
<?php
$query = getAllawardedTransponder();

while ($data = mysqli_fetch_array($query)) { ?>

          <tr>
            <td><?php echo $data['transNr']; ?></td>
            <td><?php echo $data['personName']; ?></td>
            <td><?php echo $data['von']; ?></td>
            <td><?php echo $data['bis']; ?></td>

            <?php

              echo '<td class="btn-group">
                  <a type="button" class="btn btn-sm btn-outline-secondary" href="zurueckgeben.php?transId='.$data['transId'].'">zurück geben</a>
              </td>';
             ?>
          </tr>
      <?php } ?>
      </tbody>

  </table>


<?php
 include_once ('footer.php');
?>
