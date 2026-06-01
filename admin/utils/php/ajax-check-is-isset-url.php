<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");

$url = $_POST['url'];
$where = "";

if (isset($_POST['id'])) {
    $id = $_POST['id'];
    $where = " AND id != $id";
}

$pages = DatabaseManager::selectSql("SELECT id FROM pages WHERE url = '$url' $where");

if (is_array($pages)) {
    echo count($pages);
} else {
    echo 0;
}
