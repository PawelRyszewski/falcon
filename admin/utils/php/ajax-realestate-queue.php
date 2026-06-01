<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");

if (empty($_POST)) {
    echo 'ok';
    exit;
}

$sqlCase = "(CASE ";
$ids = [];
foreach ($_POST as $queue => $id) {
    $id    = (int) $id;
    $queue = (int) $queue;
    $sqlCase .= "WHEN id = {$id} THEN {$queue} ";
    $ids[] = $id;
}
$sqlCase .= " END)";

$idList = implode(',', $ids);
$pdo  = DatabaseManager::getConnection();
$stmt = $pdo->prepare("UPDATE pages SET queue = {$sqlCase} WHERE id IN ({$idList}) AND type = 'realestate'");
$stmt->execute();

echo 'ok';
