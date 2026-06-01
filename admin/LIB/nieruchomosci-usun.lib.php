<?php
$smarty = new Smarty();
$realestateSchemaPath = __DIR__ . '/realestate_schema.lib.php';
if (file_exists($realestateSchemaPath)) {
    require_once $realestateSchemaPath;
}
$id_realestate = (int) $_GET['par3'];

if (!function_exists('realestate_db_name')) {
    function realestate_db_name()
    {
        return (string) getenv('DB_NAME');
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

$imagesForeignKey = null;
if (realestate_column_exists('images', 'id_realestate')) {
    $imagesForeignKey = 'id_realestate';
} elseif (realestate_column_exists('images', 'id_page')) {
    $imagesForeignKey = 'id_page';
} elseif (realestate_column_exists('images', 'id_gallery')) {
    $imagesForeignKey = 'id_gallery';
}

if (isset($_POST['confirm_delete'])) {
    if ($imagesForeignKey) {
        $images = DatabaseManager::selectSql("SELECT id, name FROM images WHERE {$imagesForeignKey} = $id_realestate");
        foreach ($images as $image) {
            $file_directory = './../uploads/' . $image['name'];
            $file_directory_thumb = './../uploads/thumb/' . $image['name'];

            if (file_exists($file_directory)) {
                unlink($file_directory);
            }
            if (file_exists($file_directory_thumb)) {
                unlink($file_directory_thumb);
            }

            DatabaseManager::deleteSql('images', 'id = ' . (int) $image['id']);
        }
    } else {
        error_log('[SCHEMA WARNING] Missing images relation column for realestate delete (expected id_realestate, id_page or id_gallery). Skipping image cleanup.');
    }

    DatabaseManager::deleteSql('pages', "id = $id_realestate AND type = 'realestate'");

    $_SESSION['msg_success'] = "Nieruchomość usunięta pomyślnie";

    header("Location: /admin/nieruchomosci");
    exit;
}


$realestate = DatabaseManager::selectSql("SELECT title FROM pages WHERE id = $id_realestate AND type = 'realestate'");

$smarty->assign("title", $realestate[0]['title']);
$smarty->display('nieruchomosci-usun.tpl');
