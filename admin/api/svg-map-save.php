<?php
// Standalone AJAX endpoint for SVG map save.
// Bypasses the main router (which outputs HTML before lib files run).
// Reads DB credentials via env.php, checks session, then saves JSON.

ini_set('display_errors', '0');
ini_set('html_errors',    '0');
ini_set('log_errors',     '1');
error_reporting(E_ALL);

define('ADMIN_DIR', dirname(__DIR__));

ini_set('session.gc_maxlifetime', 3600 * 4);
session_set_cookie_params(3600 * 4);
session_start();
while (ob_get_level() > 0) { ob_end_clean(); }

header('Content-Type: application/json; charset=utf-8');

function svg_map_save_fail($msg, $code = 500, $extra = [])
{
    http_response_code($code);
    error_log('[svg-map-save] FAIL ' . $code . ': ' . $msg . (empty($extra) ? '' : ' | ' . json_encode($extra)));
    echo json_encode(array_merge(['success' => false, 'error' => $msg], $extra));
    exit;
}

if (!isset($_SESSION['logged_in'])) {
    svg_map_save_fail('Sesja wygasła — zaloguj się ponownie', 403);
}

require_once ADMIN_DIR . '/env.php';
set_include_path(get_include_path() . PATH_SEPARATOR . ADMIN_DIR . '/CLASS');
require_once ADMIN_DIR . '/CLASS/DatabaseManager.class.php';

$schemaLib = ADMIN_DIR . '/LIB/realestate_schema.lib.php';
if (file_exists($schemaLib)) {
    require_once $schemaLib;
}

$categoryId = (int) ($_GET['cat'] ?? 0);
if ($categoryId <= 0) {
    svg_map_save_fail('Brak ID kategorii', 400);
}

if (function_exists('realestate_ensure_category_svg_map_table')) {
    realestate_ensure_category_svg_map_table();
}

$imageId     = (int)  ($_POST['image_id']     ?? 0);
$imageName   = trim((string) ($_POST['image_name']   ?? ''));
$imageWidth  = (int)  ($_POST['image_width']  ?? 0);
$imageHeight = (int)  ($_POST['image_height'] ?? 0);
$shapesRaw   = trim((string) ($_POST['shapes']       ?? '[]'));

$shapesDecoded = json_decode($shapesRaw, true);
if (!is_array($shapesDecoded)) {
    $shapesDecoded = [];
}
$shapesJson = json_encode($shapesDecoded, JSON_UNESCAPED_UNICODE);

try {
    $pdo = DatabaseManager::getConnection();
    if (!$pdo) {
        svg_map_save_fail('Brak połączenia z bazą danych', 500);
    }

    $tableCheckRaw = DatabaseManager::selectSql("SELECT COUNT(*) AS qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'realestate_category_svg_maps' LIMIT 1");
    if (empty($tableCheckRaw[0]['qty'])) {
        svg_map_save_fail('Brak tabeli realestate_category_svg_maps — uruchom migrację', 500);
    }

    $existing = DatabaseManager::selectSql("SELECT id FROM realestate_category_svg_maps WHERE category_id = {$categoryId} LIMIT 1");
    if (!empty($existing)) {
        $stmt = $pdo->prepare("UPDATE `realestate_category_svg_maps` SET `image_id`=?,`image_name`=?,`image_width`=?,`image_height`=?,`shapes`=?,`updated_at`=NOW() WHERE `category_id`=?");
        $stmt->execute([$imageId ?: null, $imageName, $imageWidth, $imageHeight, $shapesJson, $categoryId]);
    } else {
        DatabaseManager::insertSql('realestate_category_svg_maps', [
            'category_id'  => $categoryId,
            'image_id'     => $imageId ?: null,
            'image_name'   => $imageName,
            'image_width'  => $imageWidth,
            'image_height' => $imageHeight,
            'shapes'       => $shapesJson,
        ]);
    }

    echo json_encode([
        'success'      => true,
        'category_id'  => $categoryId,
        'image_id'     => $imageId,
        'shapes_count' => count($shapesDecoded),
    ]);
} catch (\Throwable $e) {
    svg_map_save_fail('Błąd zapisu: ' . $e->getMessage(), 500, [
        'category_id' => $categoryId,
        'image_id'    => $imageId,
    ]);
}
exit;
