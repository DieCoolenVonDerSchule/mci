<?php
session_start();

include_once ('header.php');

include_once('functions.php');
?>

<h2> Liste mit allen Spielen </h2>

<table class="table table-striped table-bordered" style="width:100%">

<thead>
  <tr>
    <td>Raum</td>
    <td>Transponder</td>
    <td>Ausgeliehende</td>
    <td>Ausgeliehen seit</td>
    <td>Ausgeliehen bis</td>
  </tr>
  </thead>

  <tbody>
<?php
$query = getAllawardedTransponder();

while ($data = mysqli_fetch_array($query)) { ?>

          <tr>
            <td><?php //echo $data['gamesname']; ?></td>
            <td><?php //echo $data['genre_name']; ?></td>
            <td><?php //echo $data['developersname']; ?></td>
            <td><?php //echo $data['publishersname']; ?></td>
            <td><?php //echo $data['release_date']; ?></td>


          </tr>
      <?php } ?>
      </tbody>

  </table>



<?php
 include_once ('footer.php');
?>
