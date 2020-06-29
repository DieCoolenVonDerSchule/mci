<?php
include_once('header.php');
include_once('functions.php');


deleteFromFavouritelist($_GET['id']);

header('location: favouritelist.php');
exit;

?>