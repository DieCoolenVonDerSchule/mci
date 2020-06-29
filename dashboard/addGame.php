<?php
include_once('header.php');
include_once('functions.php');


insertIntoFavouritelist($_GET['id']);

header('location: index.php');
exit;

?>
