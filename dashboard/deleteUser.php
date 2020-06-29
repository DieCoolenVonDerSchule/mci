<?php
include_once('header.php');
include_once('functions.php');


deleteUser();
session_destroy();

header('location: index.php');
exit;

?>
