<?php
require_once("./../../CLASS/DatabaseManager.class.php");

$id_realestate = $_POST['id_realestate'];

$images = DatabaseManager::selectSql("SELECT name, title FROM images WHERE id_realestate = $id_realestate ORDER BY queue ASC");

echo json_encode($images);