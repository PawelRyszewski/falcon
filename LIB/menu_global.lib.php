<?php
if (!function_exists('categorySlug')) {
    function categorySlug($name) {
        $name = mb_strtolower($name, 'UTF-8');
        $name = str_replace(
            ['ą', 'ć', 'ę', 'ł', 'ń', 'ó', 'ś', 'ź', 'ż'],
            ['a', 'c', 'e', 'l', 'n', 'o', 's', 'z', 'z'],
            $name
        );
        $name = preg_replace('/[^a-z0-9]+/', '-', $name);
        return trim($name, '-');
    }
}

$smarty = new Smarty();
$smarty->registerPlugin('function', 't', 'smarty_t');
$smarty->registerPlugin('function', 'page_url', 'smarty_page_url');

$menuPages = DatabaseManager::selectSql(
    "SELECT * FROM `pages` WHERE `show_in_menu` = 1 AND `is_published` = 1 ORDER BY queue_menu ASC"
);

$dbName = getenv('DB_NAME');
$categoryTableExists = true;
$categoryStatusExists = false;
if ($dbName) {
    $dbNameSafe = addslashes($dbName);
    $tableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' LIMIT 1");
    $categoryTableExists = !empty($tableCheck[0]['qty']);

    $colCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'status' LIMIT 1");
    $categoryStatusExists = !empty($colCheck[0]['qty']);
}

if (!$categoryTableExists) {
    error_log("[SCHEMA WARNING] Missing realestate_categories table. Falling back to empty investments menu in menu_global.lib.php");
    $categories = [];
} else {
    $catCols = '`rc`.`id`, `rc`.`name`';
    if ($categoryStatusExists) $catCols .= ', `rc`.`status`';

    $categoryUrlExists = false;
    if ($dbName) {
        $dbNameSafe = addslashes($dbName);
        $menuNameExists = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'menu_name' LIMIT 1")[0]['qty']);
        if ($menuNameExists) $catCols .= ', `rc`.`menu_name`';

        $categoryUrlExists = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'url' LIMIT 1")[0]['qty']);
        if ($categoryUrlExists) $catCols .= ', `rc`.`url`';
    } else {
        $menuNameExists = false;
    }

    $categories = DatabaseManager::selectSql(
        "SELECT {$catCols}
         FROM `realestate_categories` rc
         WHERE EXISTS (
             SELECT 1 FROM `pages` p
             WHERE p.type = 'realestate'
               AND p.category = rc.id
               AND COALESCE(p.is_hide, 0) = 0
         )
         ORDER BY rc.`queue` ASC, rc.`id` DESC"
    );
    if (!$categories) $categories = [];
}

$investments_in_progress = [];
$investments_completed = [];

foreach ($categories as $category) {
    $displayName = !empty($category['menu_name']) ? $category['menu_name'] : $category['name'];
    $categorySlug = !empty($category['url']) ? $category['url'] : categorySlug($category['name']);
    $menuItem = [
        'id'    => (int) $category['id'],
        'title' => $displayName,
        'url'   => '/inwestycje/' . $categorySlug,
    ];

    $status = (int) ($category['status'] ?? 0);

    if ($status === 1) {
        $investments_completed[] = $menuItem;
        continue;
    }

    $investments_in_progress[] = $menuItem;
}

$languages = DatabaseManager::selectSql('SELECT name, is_default FROM pages_langs ORDER BY id ASC');
$currentLang = $_SESSION['lang'] ?? getDefaultLang();

$smarty->assign('menuPages', $menuPages);
$smarty->assign('investments_in_progress', $investments_in_progress);
$smarty->assign('investments_completed', $investments_completed);
$smarty->assign('languages', $languages);
$smarty->assign('currentLang', $currentLang);
$smarty->display('menu_global.tpl');
