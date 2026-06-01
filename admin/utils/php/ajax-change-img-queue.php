<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");


$sqlCase = "(case ";

foreach ($_POST as $key => $value) {
    $sqlCase .= "when id = '$value' then '$key' ";
}
$sqlCase .= " end)";


$id_gallery = $_GET['id_gallery'];
$sql = "UPDATE images SET queue = $sqlCase WHERE id_gallery  = $id_gallery;";
$db = new DatabaseManager();
$pdo = $db::getConnection();
$stmt = $pdo->prepare($sql);
$stmt->execute();

echo 'ok';