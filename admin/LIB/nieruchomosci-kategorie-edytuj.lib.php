<?php
$smarty = new Smarty();
$id = (int) $_GET['par3'];
$realestateSchemaPath = __DIR__ . '/realestate_schema.lib.php';
if (file_exists($realestateSchemaPath)) {
    require_once $realestateSchemaPath;
}
$realestateCategoriesLibPath = __DIR__ . '/../../LIB/realestate_categories.lib.php';
if (file_exists($realestateCategoriesLibPath)) {
    require_once $realestateCategoriesLibPath;
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
if (function_exists('realestate_ensure_homepage_slider_table')) {
    realestate_ensure_homepage_slider_table();
}
if (function_exists('realestate_ensure_category_map_columns')) {
    realestate_ensure_category_map_columns();
}

if (function_exists('realestate_ensure_category_svg_map_table')) {
    realestate_ensure_category_svg_map_table();
}

$hasIconsTable = function_exists('realestate_table_exists')
    ? realestate_table_exists('realestate_category_icons')
    : false;

$hasSvgMapTable = function_exists('realestate_table_exists')
    ? realestate_table_exists('realestate_category_svg_maps')
    : false;

// AJAX: save SVG map
if ($hasSvgMapTable && isset($_POST['action']) && $_POST['action'] === 'save_svg_map') {
    while (ob_get_level() > 0) ob_end_clean();
    header('Content-Type: application/json; charset=utf-8');
    $imageId     = (int) ($_POST['image_id'] ?? 0);
    $imageName   = trim($_POST['image_name'] ?? '');
    $imageWidth  = (int) ($_POST['image_width'] ?? 0);
    $imageHeight = (int) ($_POST['image_height'] ?? 0);
    $shapesRaw   = trim($_POST['shapes'] ?? '[]');
    $shapesDecoded = json_decode($shapesRaw, true);
    if (!is_array($shapesDecoded)) {
        $shapesDecoded = [];
    }
    $shapesJson = json_encode($shapesDecoded, JSON_UNESCAPED_UNICODE);
    $existing = DatabaseManager::selectSql("SELECT id FROM realestate_category_svg_maps WHERE category_id = {$id} LIMIT 1");
    if (!empty($existing)) {
        $pdo  = DatabaseManager::getConnection();
        $stmt = $pdo->prepare("UPDATE `realestate_category_svg_maps` SET `image_id`=?,`image_name`=?,`image_width`=?,`image_height`=?,`shapes`=?,`updated_at`=NOW() WHERE `category_id`=?");
        $stmt->execute([$imageId ?: null, $imageName, $imageWidth, $imageHeight, $shapesJson, $id]);
    } else {
        DatabaseManager::insertSql('realestate_category_svg_maps', [
            'category_id'  => $id,
            'image_id'     => $imageId ?: null,
            'image_name'   => $imageName,
            'image_width'  => $imageWidth,
            'image_height' => $imageHeight,
            'shapes'       => $shapesJson,
        ]);
    }
    echo json_encode(['success' => true]);
    exit;
}

$hasSliderTable = function_exists('realestate_table_exists')
    ? realestate_table_exists('homepage_slider_slides')
    : false;

$hasCategoryMap = function_exists('realestate_column_exists')
    ? realestate_column_exists('realestate_categories', 'map_lat')
    : false;

if ($hasSliderTable && isset($_POST['edit_slider_slide'])) {
    $slideEditId = (int) ($_POST['edit_slide_id'] ?? 0);
    $editImgId   = (int) ($_POST['edit_slider_image_id'] ?? 0);
    $editOrder   = (int) ($_POST['edit_slider_slide_order'] ?? 1);
    $editP1      = trim($_POST['edit_slider_text_p1'] ?? '');
    $editP2      = trim($_POST['edit_slider_text_p2'] ?? '');
    $editP3      = trim($_POST['edit_slider_text_p3'] ?? '');
    if ($slideEditId > 0) {
        $pdo  = DatabaseManager::getConnection();
        $stmt = $pdo->prepare("UPDATE `homepage_slider_slides` SET `image_id`=?, `slide_order`=?, `text_p1`=?, `text_p2`=?, `text_p3`=? WHERE `id`=? AND `category_id`=?");
        $stmt->execute([
            $editImgId > 0 ? $editImgId : null,
            $editOrder,
            $editP1 !== '' ? $editP1 : null,
            $editP2 !== '' ? $editP2 : null,
            $editP3 !== '' ? $editP3 : null,
            $slideEditId,
            $id,
        ]);
    }
    header("Location: /admin/nieruchomosci/kategorie-edytuj/{$id}#slider-section");
    exit;
}

if ($hasSliderTable && isset($_POST['add_slider_slide'])) {
    $sliderImgId = (int) ($_POST['slider_image_id'] ?? 0);
    $sliderOrder = (int) ($_POST['slider_slide_order'] ?? 1);
    $textP1 = trim($_POST['slider_text_p1'] ?? '');
    $textP2 = trim($_POST['slider_text_p2'] ?? '');
    $textP3 = trim($_POST['slider_text_p3'] ?? '');
    DatabaseManager::insertSql('homepage_slider_slides', [
        'category_id' => $id,
        'image_id'    => $sliderImgId > 0 ? $sliderImgId : null,
        'slide_order' => $sliderOrder,
        'text_p1'     => $textP1 !== '' ? $textP1 : null,
        'text_p2'     => $textP2 !== '' ? $textP2 : null,
        'text_p3'     => $textP3 !== '' ? $textP3 : null,
    ]);
    header("Location: /admin/nieruchomosci/kategorie-edytuj/{$id}#slider-section");
    exit;
}

if ($hasSliderTable && isset($_POST['delete_slider_slide'])) {
    $slideDelId = (int) ($_POST['slide_id'] ?? 0);
    if ($slideDelId > 0) {
        $pdo = DatabaseManager::getConnection();
        $stmt = $pdo->prepare("DELETE FROM `homepage_slider_slides` WHERE `id` = ? AND `category_id` = ?");
        $stmt->execute([$slideDelId, $id]);
    }
    header("Location: /admin/nieruchomosci/kategorie-edytuj/{$id}#slider-section");
    exit;
}

if ($hasIconsTable && isset($_POST['add_category_icon'])) {
    $iconImgId = (int) ($_POST['icon_image_id'] ?? 0);
    $iconDesc  = trim($_POST['icon_description'] ?? '');
    if ($iconImgId > 0) {
        DatabaseManager::insertSql('realestate_category_icons', [
            'category_id' => $id,
            'image_id'    => $iconImgId,
            'description' => $iconDesc,
            'sort_order'  => 0,
        ]);
    }
    header("Location: /admin/nieruchomosci/kategorie-edytuj/{$id}#category-icons");
    exit;
}

if ($hasIconsTable && isset($_POST['delete_category_icon'])) {
    $iconDelId = (int) ($_POST['icon_id'] ?? 0);
    if ($iconDelId > 0) {
        $pdo = DatabaseManager::getConnection();
        $stmt = $pdo->prepare("DELETE FROM `realestate_category_icons` WHERE `id` = ? AND `category_id` = ?");
        $stmt->execute([$iconDelId, $id]);
    }
    header("Location: /admin/nieruchomosci/kategorie-edytuj/{$id}#category-icons");
    exit;
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

if (isset($_POST['confirm_edit'])) {
    $name = $_POST['name'];
    $menu_name = trim($_POST['menu_name'] ?? '');
    $status = isset($_POST['status']) ? (int) $_POST['status'] : 0;
    $img = isset($_POST['category_img']) && (int) $_POST['category_img'] > 0 ? (int) $_POST['category_img'] : 0;
    $description = trim($_POST['description'] ?? '');
    $title_seo = trim($_POST['title_seo'] ?? '');
    $meta_description = trim($_POST['meta_description'] ?? '');
    $keywords = trim($_POST['keywords'] ?? '');
    $url = trim($_POST['url'] ?? '');
    if ($url !== '' && function_exists('realestate_category_slugify')) {
        $url = realestate_category_slugify($url);
    }
    $homepage_img = isset($_POST['homepage_img']) && (int) $_POST['homepage_img'] > 0 ? (int) $_POST['homepage_img'] : 0;
    $homepage_title = trim($_POST['homepage_title'] ?? '');
    $homepage_subtitle = trim($_POST['homepage_subtitle'] ?? '');

    $updateData = array('name' => $name);
    if ($hasCategoryMenuName) {
        $updateData['menu_name'] = $menu_name;
    }
    if ($hasCategoryStatus) {
        $updateData['status'] = $status;
    }
    if ($hasCategoryImg) {
        $updateData['img'] = $img;
    }
    if ($hasCategoryDesc) {
        $updateData['description'] = $description;
    }
    if ($hasCategorySeo) {
        $updateData['title_seo'] = $title_seo;
        $updateData['meta_description'] = $meta_description;
        $updateData['keywords'] = $keywords;
        $updateData['url'] = $url;
    }
    if ($hasCategoryHomepage) {
        $updateData['homepage_img'] = $homepage_img;
        $updateData['homepage_title'] = $homepage_title;
        $updateData['homepage_subtitle'] = $homepage_subtitle;
    }
    if ($hasCategoryMap) {
        $mapLatRaw = trim($_POST['map_lat'] ?? '');
        $mapLngRaw = trim($_POST['map_lng'] ?? '');
        $mapZoomRaw = (int) ($_POST['map_zoom'] ?? 15);
        $updateData['map_lat'] = is_numeric($mapLatRaw) ? (float) $mapLatRaw : null;
        $updateData['map_lng'] = is_numeric($mapLngRaw) ? (float) $mapLngRaw : null;
        $updateData['map_zoom'] = ($mapZoomRaw >= 1 && $mapZoomRaw <= 20) ? $mapZoomRaw : 15;
    }
    DatabaseManager::updateSql("realestate_categories", $updateData, "id={$id}");
    $_SESSION['msg_success'] = "Edycja wykonana pomyślnie";
    header("Location: /admin/nieruchomosci/kategorie");
    exit;
}

$menuNameCol    = $hasCategoryMenuName  ? 'menu_name'         : "'' AS menu_name";
$statusCol      = $hasCategoryStatus   ? 'status'           : '0 AS status';
$imgCol         = $hasCategoryImg      ? 'img'               : 'NULL AS img';
$descCol        = $hasCategoryDesc     ? 'description'       : "'' AS description";
$seoTitleCol    = $hasCategorySeo      ? 'title_seo'         : "'' AS title_seo";
$seoDescCol     = $hasCategorySeo      ? 'meta_description'  : "'' AS meta_description";
$seoKwCol       = $hasCategorySeo      ? 'keywords'          : "'' AS keywords";
$seoUrlCol      = $hasCategorySeo      ? 'url'               : "'' AS url";
$hpImgCol       = $hasCategoryHomepage ? 'homepage_img'      : 'NULL AS homepage_img';
$hpTitleCol     = $hasCategoryHomepage ? 'homepage_title'    : "'' AS homepage_title";
$hpSubtitleCol  = $hasCategoryHomepage ? 'homepage_subtitle' : "'' AS homepage_subtitle";
$mapLatCol      = $hasCategoryMap      ? 'map_lat'           : 'NULL AS map_lat';
$mapLngCol      = $hasCategoryMap      ? 'map_lng'           : 'NULL AS map_lng';
$mapZoomCol     = $hasCategoryMap      ? 'map_zoom'          : '15 AS map_zoom';

$category = DatabaseManager::selectSql("SELECT name, {$menuNameCol}, {$statusCol}, {$imgCol}, {$descCol}, {$seoTitleCol}, {$seoDescCol}, {$seoKwCol}, {$seoUrlCol}, {$hpImgCol}, {$hpTitleCol}, {$hpSubtitleCol}, {$mapLatCol}, {$mapLngCol}, {$mapZoomCol} FROM realestate_categories WHERE id = {$id}");

if (empty($category)) {
    $_SESSION['msg_error'] = "Nie znaleziono kategorii o podanym ID";
    header("Location: /admin/nieruchomosci/kategorie");
    exit;
}

$currentImg = (int) ($category[0]['img'] ?? 0);
$currentImgName = '';
if ($currentImg > 0) {
    $imgRow = DatabaseManager::selectSql("SELECT name FROM images WHERE id = {$currentImg} LIMIT 1");
    $currentImgName = $imgRow[0]['name'] ?? '';
}

$currentHomepageImg = (int) ($category[0]['homepage_img'] ?? 0);
$currentHomepageImgName = '';
if ($currentHomepageImg > 0) {
    $hpImgRow = DatabaseManager::selectSql("SELECT name FROM images WHERE id = {$currentHomepageImg} LIMIT 1");
    $currentHomepageImgName = $hpImgRow[0]['name'] ?? '';
}

$galleryImages = DatabaseManager::selectSql("SELECT id, name, title FROM images WHERE id_gallery = 60 ORDER BY queue ASC");

$smarty->assign('category_id', $id);
$smarty->assign('name', $category[0]['name']);
$smarty->assign('menu_name', $category[0]['menu_name'] ?? '');
$smarty->assign('status', (int) ($category[0]['status'] ?? 0));
$smarty->assign('current_img', $currentImg);
$smarty->assign('current_img_name', $currentImgName);
$smarty->assign('current_homepage_img', $currentHomepageImg);
$smarty->assign('current_homepage_img_name', $currentHomepageImgName);
$smarty->assign('homepage_title', $category[0]['homepage_title'] ?? '');
$smarty->assign('homepage_subtitle', $category[0]['homepage_subtitle'] ?? '');
$smarty->assign('description', $category[0]['description'] ?? '');
$smarty->assign('title_seo', $category[0]['title_seo'] ?? '');
$smarty->assign('meta_description', $category[0]['meta_description'] ?? '');
$smarty->assign('keywords', $category[0]['keywords'] ?? '');
$smarty->assign('seo_url', $category[0]['url'] ?? '');
$smarty->assign('gallery_images', $galleryImages);

$categoryIcons = [];
if ($hasIconsTable) {
    $categoryIcons = DatabaseManager::selectSql("SELECT rci.id, rci.image_id, rci.description, i.name AS img_name FROM realestate_category_icons rci LEFT JOIN images i ON i.id = rci.image_id WHERE rci.category_id = {$id} ORDER BY rci.sort_order ASC, rci.id ASC") ?: [];
}
$smarty->assign('category_icons', $categoryIcons);
$smarty->assign('has_icons_table', $hasIconsTable);

$categorySliderSlides = [];
$totalCategoriesCount = 1;
if ($hasSliderTable) {
    $categorySliderSlides = DatabaseManager::selectSql(
        "SELECT hss.id, hss.image_id, hss.slide_order, hss.text_p1, hss.text_p2, hss.text_p3, i.name AS img_name
         FROM homepage_slider_slides hss
         LEFT JOIN images i ON i.id = hss.image_id
         WHERE hss.category_id = {$id}
         ORDER BY hss.slide_order ASC, hss.id ASC"
    ) ?: [];
    $countResult = DatabaseManager::selectSql("SELECT COUNT(*) as cnt FROM realestate_categories");
    $totalCategoriesCount = max(1, (int) ($countResult[0]['cnt'] ?? 1));
}
$smarty->assign('category_slider_slides', $categorySliderSlides);
$smarty->assign('has_slider_table', $hasSliderTable);
$smarty->assign('total_categories_count', $totalCategoriesCount);

$smarty->assign('has_category_map', $hasCategoryMap);
$smarty->assign('category_map_lat', $category[0]['map_lat'] ?? null);
$smarty->assign('category_map_lng', $category[0]['map_lng'] ?? null);
$smarty->assign('category_map_zoom', (int) ($category[0]['map_zoom'] ?? 15));

// SVG map data
$svgMapData = null;
if ($hasSvgMapTable) {
    $svgMapRow = DatabaseManager::selectSql("SELECT image_id, image_name, image_width, image_height, shapes FROM realestate_category_svg_maps WHERE category_id = {$id} LIMIT 1");
    if (!empty($svgMapRow)) {
        $svgMapData = $svgMapRow[0];
    }
}
$smarty->assign('svg_map_data', $svgMapData);
$smarty->assign('has_svg_map_table', $hasSvgMapTable);

// Properties in this category (for shape assignment select)
$categoryPropertiesForMap = [];
$dbNameForMap = getenv('DB_NAME');
if ($dbNameForMap) {
    $dbNameSafeMap = addslashes($dbNameForMap);
    $houseStatusExistsMap = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafeMap}' AND TABLE_NAME = 'pages' AND COLUMN_NAME = 'house_status' LIMIT 1")[0]['qty']);
    $imgColExistsMap = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafeMap}' AND TABLE_NAME = 'pages' AND COLUMN_NAME = 'img' LIMIT 1")[0]['qty']);
    $propCols = 'id, url, title';
    if ($houseStatusExistsMap) $propCols .= ', house_status';
    if ($imgColExistsMap)      $propCols .= ', img';
    $propsRaw = DatabaseManager::selectSql("SELECT {$propCols} FROM pages WHERE is_hide = 0 AND type = 'realestate' AND category = {$id} ORDER BY queue ASC, id ASC");
    if ($propsRaw) {
        $propImgIds = [];
        foreach ($propsRaw as $p) {
            $pid = (int)($p['img'] ?? 0);
            if ($pid > 0) $propImgIds[] = $pid;
        }
        $propImgMap = [];
        if ($propImgIds) {
            $wherePI = implode(',', array_unique($propImgIds));
            $piRows  = DatabaseManager::selectSql("SELECT id, name FROM images WHERE id IN ({$wherePI})");
            if ($piRows) {
                foreach ($piRows as $pi) $propImgMap[(int)$pi['id']] = $pi['name'];
            }
        }
        foreach ($propsRaw as $p) {
            $p['img_name']     = $propImgMap[(int)($p['img'] ?? 0)] ?? '';
            $p['house_status'] = $p['house_status'] ?? 'wolne';
            $categoryPropertiesForMap[] = $p;
        }
    }
}
$smarty->assign('category_properties_json', json_encode($categoryPropertiesForMap, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE));

$smarty->display('nieruchomosci-kategorie-edytuj.tpl');
