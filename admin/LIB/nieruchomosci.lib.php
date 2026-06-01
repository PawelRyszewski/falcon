<?php
$smarty = new Smarty();
$realestateSchemaPath = __DIR__ . '/realestate_schema.lib.php';
if (file_exists($realestateSchemaPath)) {
    require_once $realestateSchemaPath;
}

if (!function_exists('realestate_db_name')) {
    function realestate_db_name()
    {
        return (string) getenv('DB_NAME');
    }
}

if (!function_exists('realestate_table_exists')) {
    function realestate_table_exists($tableName)
    {
        $dbName = realestate_db_name();
        if ($dbName === '') {
            return false;
        }

        $dbNameSafe = addslashes($dbName);
        $tableSafe = addslashes($tableName);
        $result = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = '{$tableSafe}' LIMIT 1");

        return !empty($result[0]['qty']);
    }
}

if (!function_exists('realestate_column_exists')) {
    function realestate_column_exists($tableName, $columnName)
    {
        $dbName = realestate_db_name();
        if ($dbName === '') {
            return false;
        }

        $dbNameSafe = addslashes($dbName);
        $tableSafe = addslashes($tableName);
        $columnSafe = addslashes($columnName);
        $result = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = '{$tableSafe}' AND COLUMN_NAME = '{$columnSafe}' LIMIT 1");

        return !empty($result[0]['qty']);
    }
}

// #2: toggle_publish — używamy is_hide (0=widoczna, 1=ukryta), bo frontend filtruje po is_hide
if (isset($_POST['toggle_publish'])) {
    $id_page  = (int) $_POST['id_page'];
    $is_hide  = (int) $_POST['is_hide'];

    if (realestate_column_exists('pages', 'is_hide')) {
        DatabaseManager::updateSql('pages', ['is_hide' => $is_hide], "id={$id_page} AND type = 'realestate'");
    }

    $_SESSION['msg_success'] = 'Edycja nieruchomości wykonana pomyślnie';
    header('Location: /admin/nieruchomosci');
    exit;
}

// Odwróć kolejność nieruchomości w kategorii
if (isset($_POST['reverse_order'])) {
    $catId = (int) $_POST['cat_id'];
    $items = DatabaseManager::selectSql(
        "SELECT id FROM pages WHERE type = 'realestate' AND category = {$catId} ORDER BY queue ASC, created_at DESC"
    );
    if ($items) {
        $ids = array_column($items, 'id');
        $n   = count($ids);
        foreach ($ids as $i => $id) {
            DatabaseManager::updateSql('pages', ['queue' => $n - 1 - $i], "id = " . (int) $id);
        }
    }
    $_SESSION['msg_success'] = 'Kolejność odwrócona.';
    header('Location: /admin/nieruchomosci');
    exit;
}

$categoryTableExists = realestate_table_exists('realestate_categories');
$hasCategory         = realestate_column_exists('pages', 'category');
$hasHouseStatus      = realestate_column_exists('pages', 'house_status');

$categorySelect     = $hasCategory ? "p.category" : "0 AS category";
$categoryNameSelect = $categoryTableExists && $hasCategory ? "c.name AS category_name, c.queue AS category_queue" : "'' AS category_name, 0 AS category_queue";
$categoryJoin       = $categoryTableExists && $hasCategory ? " LEFT JOIN realestate_categories c ON p.category = c.id " : "";
$houseStatusSelect  = $hasHouseStatus ? "p.house_status" : "'' AS house_status";

$realestates = DatabaseManager::selectSql(
    "SELECT p.id, p.url, p.title, p.img, p.description, p.is_hide, p.created_at,
            {$houseStatusSelect}, {$categorySelect}, {$categoryNameSelect}
     FROM pages p {$categoryJoin}
     WHERE p.type = 'realestate'
     ORDER BY COALESCE(c.queue, 9999) ASC, c.id ASC, p.queue ASC, p.created_at DESC"
);

$mainImages = '';
if ($realestates) {
    $mainImagesId = array_values(array_filter(array_map(function ($r) {
        return (int) ($r['img'] ?? 0);
    }, $realestates)));

    if ($mainImagesId) {
        $whereMainImages = implode(',', $mainImagesId);
        $mainImages = DatabaseManager::selectSqlGroup("SELECT id, name FROM images WHERE id IN ($whereMainImages)");
    }
}

// #1: Grupowanie po kategorii
$realestatesGrouped = [];
foreach ((array) $realestates as $r) {
    $catName = trim((string) ($r['category_name'] ?? ''));
    $key     = $catName !== '' ? $catName : 'Bez kategorii';
    $realestatesGrouped[$key][] = $r;
}

// #3: Etykiety dla house_status
$houseStatusLabels = [
    'wolne'       => 'Wolne',
    'rezerwacja'  => 'Rezerwacja',
    'niedostepne' => 'Niedostępne',
    ''            => '—',
];

$smarty->assign('realestates_grouped', $realestatesGrouped);
$smarty->assign('house_status_labels', $houseStatusLabels);
$smarty->assign('mainImages', $mainImages);

$smarty->display('nieruchomosci.tpl');
