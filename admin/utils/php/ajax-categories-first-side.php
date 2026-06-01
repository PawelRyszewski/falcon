<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");

header('Content-Type: application/json');

$status = isset($_POST['status']) ? (int) $_POST['status'] : -1;
$side   = $_POST['side'] ?? '';
if (!in_array($status, [0, 1], true) || !in_array($side, ['left', 'right'], true)) {
    echo json_encode(['ok' => false, 'error' => 'invalid input']);
    exit;
}

$dbName = (string) getenv('DB_NAME');
if ($dbName === '') {
    echo json_encode(['ok' => false, 'error' => 'no db']);
    exit;
}

$dbNameSafe = addslashes($dbName);
$tableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = 'realestate_homepage_section_settings' LIMIT 1");
if (empty($tableCheck[0]['qty'])) {
    $schemaPath = __DIR__ . '/../../LIB/realestate_schema.lib.php';
    if (file_exists($schemaPath)) {
        require_once $schemaPath;
        if (function_exists('realestate_ensure_homepage_section_settings_table')) {
            realestate_ensure_homepage_section_settings_table();
        }
    }
    $tableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = 'realestate_homepage_section_settings' LIMIT 1");
    if (empty($tableCheck[0]['qty'])) {
        echo json_encode(['ok' => false, 'error' => 'missing table']);
        exit;
    }
}

$pdo = DatabaseManager::getConnection();
$stmt = $pdo->prepare("INSERT INTO realestate_homepage_section_settings (status, first_side) VALUES (?, ?) ON DUPLICATE KEY UPDATE first_side = VALUES(first_side)");
$stmt->execute([$status, $side]);

echo json_encode(['ok' => true, 'status' => $status, 'side' => $side]);
