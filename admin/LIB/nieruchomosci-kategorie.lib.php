<?php
$smarty = new Smarty();
$realestateSchemaPath = __DIR__ . '/realestate_schema.lib.php';
if (file_exists($realestateSchemaPath)) {
    require_once $realestateSchemaPath;
}

if (function_exists('realestate_ensure_category_status_column')) {
    realestate_ensure_category_status_column();
}
if (function_exists('realestate_ensure_category_img_desc_columns')) {
    realestate_ensure_category_img_desc_columns();
}
if (function_exists('realestate_ensure_category_seo_columns')) {
    realestate_ensure_category_seo_columns();
}
if (function_exists('realestate_ensure_category_homepage_columns')) {
    realestate_ensure_category_homepage_columns();
}
if (function_exists('realestate_ensure_category_menu_name_column')) {
    realestate_ensure_category_menu_name_column();
}
if (function_exists('realestate_ensure_category_icons_table')) {
    realestate_ensure_category_icons_table();
}
if (function_exists('realestate_ensure_category_map_columns')) {
    realestate_ensure_category_map_columns();
}
if (function_exists('realestate_ensure_category_svg_map_table')) {
    realestate_ensure_category_svg_map_table();
}
if (function_exists('realestate_ensure_homepage_section_settings_table')) {
    realestate_ensure_homepage_section_settings_table();
}

$hasCategoryMenuName = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'menu_name')
    : false;

$hasCategoryStatus = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'status')
    : false;
$hasCategoryImg = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'img')
    : false;
$hasCategoryDesc = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'description')
    : false;
$hasCategorySeo = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'title_seo')
    : false;
$hasCategoryHomepage = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'homepage_img')
    : false;

$hasCategoryMap = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'map_lat')
    : false;

if (isset($_POST['add_category'])) {
    $name = $_POST['name'];
    $menu_name = trim($_POST['menu_name'] ?? '');
    $status = isset($_POST['status']) ? (int) $_POST['status'] : 0;
    $img = isset($_POST['category_img']) && (int) $_POST['category_img'] > 0 ? (int) $_POST['category_img'] : 0;
    $description = trim($_POST['description'] ?? '');
    $title_seo = trim($_POST['title_seo'] ?? '');
    $meta_description = trim($_POST['meta_description'] ?? '');
    $keywords = trim($_POST['keywords'] ?? '');
    $url = trim($_POST['url'] ?? '');
    $categoriesLibPath = __DIR__ . '/../../LIB/realestate_categories.lib.php';
    if ($url !== '' && file_exists($categoriesLibPath)) {
        require_once $categoriesLibPath;
        if (function_exists('realestate_category_slugify')) {
            $url = realestate_category_slugify($url);
        }
    }
    $homepage_img = isset($_POST['homepage_img']) && (int) $_POST['homepage_img'] > 0 ? (int) $_POST['homepage_img'] : 0;
    $homepage_title = trim($_POST['homepage_title'] ?? '');
    $homepage_subtitle = trim($_POST['homepage_subtitle'] ?? '');

    if (strlen($name) == 0) {
        $_SESSION['msg_error'] = "Nazwa kategorii nie może być pusta";
    } else {
        $insertData = array('name' => $name);
        if ($hasCategoryMenuName) {
            $insertData['menu_name'] = $menu_name;
        }
        if ($hasCategoryStatus) {
            $insertData['status'] = $status;
        }
        if ($hasCategoryImg) {
            $insertData['img'] = $img;
        }
        if ($hasCategoryDesc) {
            $insertData['description'] = $description;
        }
        if ($hasCategorySeo) {
            $insertData['title_seo'] = $title_seo;
            $insertData['meta_description'] = $meta_description;
            $insertData['keywords'] = $keywords;
            $insertData['url'] = $url;
        }
        if ($hasCategoryHomepage) {
            $insertData['homepage_img'] = $homepage_img;
            $insertData['homepage_title'] = $homepage_title;
            $insertData['homepage_subtitle'] = $homepage_subtitle;
        }
        if ($hasCategoryMap) {
            $mapLatRaw = trim($_POST['map_lat'] ?? '');
            $mapLngRaw = trim($_POST['map_lng'] ?? '');
            $mapZoomRaw = (int) ($_POST['map_zoom'] ?? 15);
            $insertData['map_lat'] = is_numeric($mapLatRaw) ? (float) $mapLatRaw : null;
            $insertData['map_lng'] = is_numeric($mapLngRaw) ? (float) $mapLngRaw : null;
            $insertData['map_zoom'] = ($mapZoomRaw >= 1 && $mapZoomRaw <= 20) ? $mapZoomRaw : 15;
        }
        $newCatId = DatabaseManager::insertSql("realestate_categories", $insertData);
        $_SESSION['msg_success'] = "Kategoria dodana pomyślnie. Możesz teraz dodać ikony.";
        header("Location: /admin/nieruchomosci/kategorie-edytuj/" . (int)$newCatId . "#category-icons");
        exit;
    }
    header("Location: /admin/nieruchomosci/kategorie");
    exit;
}

$galleryImages = DatabaseManager::selectSql("SELECT id, name, title FROM images WHERE id_gallery = 60 ORDER BY queue ASC");

$categoriesSelect = $hasCategoryStatus ? 'SELECT *' : 'SELECT *, 0 AS status';
$categories = DatabaseManager::selectSql("{$categoriesSelect} FROM realestate_categories ORDER BY queue ASC, id DESC");

$categoriesInProgress = [];
$categoriesCompleted = [];
foreach ((array) $categories as $cat) {
    if ((int) ($cat['status'] ?? 0) === 1) {
        $categoriesCompleted[] = $cat;
    } else {
        $categoriesInProgress[] = $cat;
    }
}

$firstSideInProgress = 'left';
$firstSideCompleted = 'left';
if (function_exists('realestate_table_exists') && realestate_table_exists('realestate_homepage_section_settings')) {
    $sectionRows = DatabaseManager::selectSql("SELECT status, first_side FROM realestate_homepage_section_settings");
    if ($sectionRows) {
        foreach ($sectionRows as $row) {
            $side = $row['first_side'] === 'right' ? 'right' : 'left';
            if ((int) $row['status'] === 1) {
                $firstSideCompleted = $side;
            } else {
                $firstSideInProgress = $side;
            }
        }
    }
}

$smarty->assign('categories', $categories);
$smarty->assign('categories_in_progress', $categoriesInProgress);
$smarty->assign('categories_completed', $categoriesCompleted);
$smarty->assign('first_side_in_progress', $firstSideInProgress);
$smarty->assign('first_side_completed', $firstSideCompleted);
$smarty->assign('gallery_images', $galleryImages);
$smarty->assign('has_category_map', $hasCategoryMap);
$smarty->display('nieruchomosci-kategorie.tpl');
