<?php

function getConnection(){
$mysqlhost="localhost";
$mysqluser="root";
$mysqlpwd="";
$mysqldb="GamesWebsite";

$connection=mysqli_connect($mysqlhost, $mysqluser, $mysqlpwd, $mysqldb)
    or die("DB Conneciton ERROR!");
    return $connection;
}

function insertIntoFavouritelist($game_id){
  session_start();
  $con = getConnection();
  $sql = 'CALL addToFavourites('.$_SESSION['userid'].', '.$game_id.')';
  $query = mysqli_query($con,$sql);
  return $query;
}

function getAllGames(){
  $con = getConnection();
  $sql = 'SELECT game_id, userpoints, games.name as gamesname, genre_name, publishers.name as publishersname, developers.name as developersname, release_date FROM games  JOIN developers using (dev_id) Join publishers using (pub_id) Join genres using (genre_id)';
  // SELECT games.name as gamesname, genres.name as genrename, publishers.name as publishersname, developers.name as developersname, release_date FROM games  JOIN developers using (dev_id) Join publishers using (pub_id) Join genres using (genre_id);
  $query = mysqli_query($con,$sql);
  return $query;

}

function getFavouriteGames(){
	$con = getConnection();
	$sql = 'SELECT game_id, games.name as gamesname, genre_name, publishers.name as publishersname, developers.name as developersname, release_date, userpoints FROM games  JOIN developers using (dev_id) Join publishers using (pub_id) Join genres using (genre_id)
	        JOIN USERS_GAMES USING (game_id) WHERE user_id='.$_SESSION['userid'];

	$query = mysqli_query($con,$sql);
    return $query;
}

function deleteFromFavouritelist($game_id){
  session_start();
  $con = getConnection();
  $sql = 'CALL deleteFromFavourites('.$_SESSION['userid'].', '.$game_id.')';
  $query = mysqli_query($con,$sql);
  return $query;
}

function deleteUser() {
  session_start();
  $con = getConnection();
  $sql = 'CALL deleteFromUsers('.$_SESSION['userid'].')';
  $query = mysqli_query($con,$sql);
  return $query;
}

 ?>
