<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");

header('Content-Type: application/json');

$ids = $_POST['ids'] ?? [];
if (!is_array($ids) || empty($ids)) {
    echo json_encode(['ok' => false, 'error' => 'no ids']);
    exit;
}

$cleanIds = [];
foreach ($ids as $id) {
    $intId = (int) $id;
    if ($intId > 0) {
        $cleanIds[] = $intId;
    }
}
if (empty($cleanIds)) {
    echo json_encode(['ok' => false, 'error' => 'invalid ids']);
    exit;
}

$dbName = (string) getenv('DB_NAME');
if ($dbName === '') {
    echo json_encode(['ok' => false, 'error' => 'no db']);
    exit;
}

$dbNameSafe = addslashes($dbName);
$tableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = 'realestate_categories' LIMIT 1");
if (empty($tableCheck[0]['qty'])) {
    echo json_encode(['ok' => false, 'error' => 'missing table']);
    exit;
}

$pdo = DatabaseManager::getConnection();
$stmt = $pdo->prepare("UPDATE realestate_categories SET queue = ? WHERE id = ?");
foreach ($cleanIds as $i => $id) {
    $stmt->execute([$i, $id]);
}

echo json_encode(['ok' => true, 'count' => count($cleanIds)]);
