<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");

$db = new DatabaseManager();
$pdo = $db::getConnection();


foreach ($_POST as $key => $value) {
    $sql = "UPDATE pages SET queue = $key WHERE type = 'realestate' AND id = $value ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
}

echo 'ok';
