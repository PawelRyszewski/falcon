<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");

header('Content-Type: application/json');

$imgId = (int) ($_POST['img_id'] ?? 0);
$hide  = (int) ($_POST['hide']   ?? 0);
$hide  = $hide ? 1 : 0;

if ($imgId <= 0) {
    echo json_encode(['ok' => false, 'error' => 'invalid id']);
    exit;
}

$dbName = (string) getenv('DB_NAME');
if ($dbName !== '') {
    $dbNameSafe = addslashes($dbName);
    $colExists  = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = 'images' AND COLUMN_NAME = 'hide_from_slider' LIMIT 1");
    if (!empty($colExists[0]['qty'])) {
        DatabaseManager::updateSql('images', ['hide_from_slider' => $hide], "id = {$imgId}");
        echo json_encode(['ok' => true, 'hide' => $hide]);
        exit;
    }
}

echo json_encode(['ok' => false, 'error' => 'column missing']);
