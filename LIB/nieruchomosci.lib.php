<?php
$smarty = new Smarty();
$mainImages = "";

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

if (!function_exists('realestate_status_labels')) {
    function realestate_status_labels()
    {
        return [
            0 => 'W realizacji',
            1 => 'Zrealizowane',
        ];
    }
}

if (!function_exists('realestate_status_bucket_key')) {
    function realestate_status_bucket_key($status)
    {
        return ((int) $status === 1) ? 'realestates_completed' : 'realestates_in_progress';
    }
}

$realestateStatusLabels = realestate_status_labels();

$categoryFilter = isset($_GET['kategoria']) ? (int) $_GET['kategoria'] : 0;

// Redirect legacy ?kategoria=ID to clean /inwestycje/{slug} URL
if ($categoryFilter > 0 && isset($_SERVER['QUERY_STRING']) && strpos($_SERVER['QUERY_STRING'], 'kategoria=') !== false) {
    $dbNameForRedirect = getenv('DB_NAME');
    if ($dbNameForRedirect) {
        $dbNameSafeRedirect = addslashes($dbNameForRedirect);
        $catUrlExistsRedirect = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafeRedirect}' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'url' LIMIT 1")[0]['qty']);
        $redirectCols = $catUrlExistsRedirect ? 'name, url' : 'name';
        $catRow = DatabaseManager::selectSql("SELECT {$redirectCols} FROM realestate_categories WHERE id = {$categoryFilter} LIMIT 1");
        if (!empty($catRow[0]['name'])) {
            $redirectSlug = !empty($catRow[0]['url']) ? $catRow[0]['url'] : categorySlug($catRow[0]['name']);
            header('Location: /inwestycje/' . $redirectSlug, true, 301);
            exit;
        }
    }
}

$whereCategoryFilter = $categoryFilter > 0 ? " AND category = {$categoryFilter}" : '';

$dbName = getenv('DB_NAME');
$pagesRealestateStatusExists = false;
if ($dbName) {
    $dbNameSafe = addslashes($dbName);
    $colCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'pages' AND COLUMN_NAME = 'realestate_status' LIMIT 1");
    $pagesRealestateStatusExists = !empty($colCheck[0]['qty']);
}

if ($pagesRealestateStatusExists) {
    $realestates = DatabaseManager::selectSql("SELECT id, url, title, img, description, content, created_at, realestate_status FROM pages WHERE is_hide = 0 AND img is not NULL AND type = 'realestate'{$whereCategoryFilter} ORDER BY queue ASC, created_at DESC");
} else {
     error_log("[SCHEMA WARNING] Missing pages.realestate_status column. Falling back to default status=0 in nieruchomosci.lib.php. See docs/migrations/2026-03-27_pages_realestate_status_prod.sql");
    $realestates = DatabaseManager::selectSql("SELECT id, url, title, img, description, content, created_at FROM pages WHERE is_hide = 0 AND img is not NULL AND type = 'realestate'{$whereCategoryFilter} ORDER BY queue ASC, created_at DESC");
}

$realestatesInProgress = [];
$realestatesCompleted = [];

if ($realestates) {
    foreach ($realestates as $realestate) {
        $status = (int) ($realestate['realestate_status'] ?? 0);

        if (realestate_status_bucket_key($status) === 'realestates_completed') {
            $realestatesCompleted[] = $realestate;
            continue;
        }

        $realestatesInProgress[] = $realestate;
    }

    $mainImagesId = array_values(array_filter(array_map(function ($realestate) {
        return (int) $realestate['img'];
    }, $realestates)));

    if ($mainImagesId) {
        $whereMainImages = implode(",", $mainImagesId);
        $mainImages = DatabaseManager::selectSqlGroup("SELECT id, name FROM images WHERE id IN ($whereMainImages)");
    }
}

$smarty->assign('realestates', $realestates);
$smarty->assign('realestates_in_progress', $realestatesInProgress);
$smarty->assign('realestates_completed', $realestatesCompleted);
$smarty->assign('realestate_status_labels', $realestateStatusLabels);
$smarty->assign('mainImages', $mainImages);
$smarty->assign('active_category_filter', $categoryFilter);

// Category data — loaded only when viewing a specific category
$categoryHouses = [];
$activeCategoryName = '';
$categoryImgName = '';
$categoryDescription = '';
if ($categoryFilter > 0 && $dbName) {
    $dbNameSafe = isset($dbNameSafe) ? $dbNameSafe : addslashes($dbName);

    $catTableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' LIMIT 1");
    if (!empty($catTableCheck[0]['qty'])) {
        $catImgExists  = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'img' LIMIT 1")[0]['qty']);
        $catDescExists = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'description' LIMIT 1")[0]['qty']);

        $catSelectCols = 'name';
        if ($catImgExists)  $catSelectCols .= ', img';
        if ($catDescExists) $catSelectCols .= ', description';

        $catMapLatExists = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'map_lat' LIMIT 1")[0]['qty']);
        if ($catMapLatExists) {
            $catSelectCols .= ', map_lat, map_lng';
            $catMapZoomExists = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'map_zoom' LIMIT 1")[0]['qty']);
            if ($catMapZoomExists) $catSelectCols .= ', map_zoom';
        }

        $catRow = DatabaseManager::selectSql("SELECT {$catSelectCols} FROM realestate_categories WHERE id = {$categoryFilter} LIMIT 1");
        if (!empty($catRow)) {
            $activeCategoryName = $catRow[0]['name'] ?? '';

            $catImgId = (int) ($catRow[0]['img'] ?? 0);
            if ($catImgId > 0) {
                $catImgRow = DatabaseManager::selectSql("SELECT name FROM images WHERE id = {$catImgId} LIMIT 1");
                $categoryImgName = $catImgRow[0]['name'] ?? '';
            }

            $categoryDescription = $catRow[0]['description'] ?? '';
        }
    }

    $smarty->assign('category_map_lat', isset($catRow[0]) ? ($catRow[0]['map_lat'] ?? null) : null);
    $smarty->assign('category_map_lng', isset($catRow[0]) ? ($catRow[0]['map_lng'] ?? null) : null);
    $smarty->assign('category_map_zoom', isset($catRow[0]) ? (int) ($catRow[0]['map_zoom'] ?? 15) : 15);

    $houseColCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'pages' AND COLUMN_NAME = 'house_status' LIMIT 1");
    $houseFieldsExist = !empty($houseColCheck[0]['qty']);

    if ($houseFieldsExist) {
        $housesRaw = DatabaseManager::selectSql("SELECT id, url, title, img, house_status, plot_area, usable_area, house_price FROM pages WHERE is_hide = 0 AND type = 'realestate' AND category = {$categoryFilter} ORDER BY queue ASC, created_at DESC");
    } else {
        error_log('[SCHEMA WARNING] Missing pages.house_status column. House table will render without status/area/price. Run 2026-04-18_pages_house_fields.sql migration.');
        $housesRaw = DatabaseManager::selectSql("SELECT id, url, title, img FROM pages WHERE is_hide = 0 AND type = 'realestate' AND category = {$categoryFilter} ORDER BY queue ASC, created_at DESC");
    }

    if ($housesRaw) {
        $houseImgIds = array_values(array_filter(array_map(function ($h) {
            return (int) $h['img'];
        }, $housesRaw)));

        $houseImages = [];
        if ($houseImgIds) {
            $whereHouseImgs = implode(',', $houseImgIds);
            $houseImgRows = DatabaseManager::selectSql("SELECT id, name FROM images WHERE id IN ($whereHouseImgs)");
            if ($houseImgRows) {
                foreach ($houseImgRows as $img) {
                    $houseImages[(int) $img['id']] = $img['name'];
                }
            }
        }

        foreach ($housesRaw as $house) {
            $imgId = (int) ($house['img'] ?? 0);
            $house['img_name'] = $houseImages[$imgId] ?? '';
            $categoryHouses[] = $house;
        }
    }
}

$smarty->assign('category_houses', $categoryHouses);
$smarty->assign('active_category_name', $activeCategoryName);
$smarty->assign('category_img_name', $categoryImgName);
$smarty->assign('category_description', $categoryDescription);

$categoryIcons = [];
if ($categoryFilter > 0 && $dbName) {
    $dbNameSafe3 = isset($dbNameSafe) ? $dbNameSafe : addslashes($dbName);
    $iconsTableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe3' AND TABLE_NAME = 'realestate_category_icons' LIMIT 1");
    if (!empty($iconsTableCheck[0]['qty'])) {
        $categoryIcons = DatabaseManager::selectSql("SELECT rci.image_id, rci.description, i.name AS img_name FROM realestate_category_icons rci LEFT JOIN images i ON i.id = rci.image_id WHERE rci.category_id = {$categoryFilter} ORDER BY rci.sort_order ASC, rci.id ASC") ?: [];
    }
}
$smarty->assign('category_icons', $categoryIcons);

// SVG property map — loaded only when viewing a specific category
// Configurable heights (px, vw, or vh — set as CSS value string)
$svgMapHeightDesktop = '600px';
$svgMapHeightMobile  = '380px'; // applied below 991px with horizontal scroll

$categorySvgMap = null;
if ($categoryFilter > 0 && $dbName) {
    $dbNameSafe4 = isset($dbNameSafe) ? $dbNameSafe : addslashes($dbName);
    $svgMapTableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe4' AND TABLE_NAME = 'realestate_category_svg_maps' LIMIT 1");
    if (!empty($svgMapTableCheck[0]['qty'])) {
        $svgMapRow = DatabaseManager::selectSql("SELECT image_id, image_name, image_width, image_height, shapes FROM realestate_category_svg_maps WHERE category_id = {$categoryFilter} LIMIT 1");
        if (!empty($svgMapRow) && !empty($svgMapRow[0]['shapes'])) {
            $shapesDecoded = json_decode($svgMapRow[0]['shapes'], true);
            if (is_array($shapesDecoded) && count($shapesDecoded) > 0) {
                $imgW = (int)($svgMapRow[0]['image_width']  ?? 0);
                $imgH = (int)($svgMapRow[0]['image_height'] ?? 0);
                $categorySvgMap = [
                    'image_name'   => $svgMapRow[0]['image_name'] ?? '',
                    'image_width'  => $imgW,
                    'image_height' => $imgH,
                    'padding_top'  => ($imgW > 0) ? round($imgH / $imgW * 100, 4) : 56.25,
                    'shapes'       => $shapesDecoded,
                ];
            }
        }
    }
}
$smarty->assign('category_svg_map', $categorySvgMap);
$smarty->assign('svg_map_height_desktop', $svgMapHeightDesktop);
$smarty->assign('svg_map_height_mobile',  $svgMapHeightMobile);

// #1: Category grid for /inwestycje main page (no filter active)
$categories_in_progress = [];
$categories_completed   = [];

if ($categoryFilter == 0 && $dbName) {
    $dbNameSafe2 = isset($dbNameSafe) ? $dbNameSafe : addslashes($dbName);

    $catTableCheck2 = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe2' AND TABLE_NAME = 'realestate_categories' LIMIT 1");
    if (!empty($catTableCheck2[0]['qty'])) {
        // Ensure needed columns exist
        if (function_exists('realestate_ensure_category_status_column')) {
            realestate_ensure_category_status_column();
        }
        if (function_exists('realestate_ensure_category_img_desc_columns')) {
            realestate_ensure_category_img_desc_columns();
        }

        $catStatusExists  = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe2' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'status' LIMIT 1")[0]['qty']);
        $catImgCol        = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe2' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'img' LIMIT 1")[0]['qty']);
        $catHomepageImgCol = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe2' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'homepage_img' LIMIT 1")[0]['qty']);
        $catUrlCol         = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe2' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'url' LIMIT 1")[0]['qty']);

        $catSelectCols2 = 'id, name';
        if ($catStatusExists)   $catSelectCols2 .= ', status';
        if ($catImgCol)         $catSelectCols2 .= ', img';
        if ($catHomepageImgCol) $catSelectCols2 .= ', homepage_img';
        if ($catUrlCol)         $catSelectCols2 .= ', url';

        $allCats = DatabaseManager::selectSql("SELECT {$catSelectCols2} FROM realestate_categories rc WHERE EXISTS (SELECT 1 FROM pages p WHERE p.type = 'realestate' AND p.category = rc.id AND COALESCE(p.is_hide, 0) = 0) ORDER BY rc.queue ASC, rc.id ASC");

        if ($allCats) {
            // Collect all relevant image IDs: prefer homepage_img, fall back to img
            $catImgIds2 = [];
            foreach ($allCats as $cat) {
                $hpImg = (int)($cat['homepage_img'] ?? 0);
                $fallback = (int)($cat['img'] ?? 0);
                $pick = $hpImg > 0 ? $hpImg : $fallback;
                if ($pick > 0) $catImgIds2[] = $pick;
            }
            $catImgIds2 = array_values(array_unique($catImgIds2));

            $catImgMap2 = [];
            if ($catImgIds2) {
                $whereImgs2 = implode(',', $catImgIds2);
                $catImgRows2 = DatabaseManager::selectSql("SELECT id, name FROM images WHERE id IN ($whereImgs2)");
                if ($catImgRows2) {
                    foreach ($catImgRows2 as $r) {
                        $catImgMap2[(int)$r['id']] = $r['name'];
                    }
                }
            }

            foreach ($allCats as $cat) {
                $hpImg   = (int)($cat['homepage_img'] ?? 0);
                $fallback = (int)($cat['img'] ?? 0);
                $pickedId = $hpImg > 0 ? $hpImg : $fallback;
                $cat['img_name'] = $catImgMap2[$pickedId] ?? '';
                $cat['slug']     = !empty($cat['url']) ? $cat['url'] : categorySlug($cat['name']);
                if ((int)($cat['status'] ?? 0) === 1) {
                    $categories_completed[]   = $cat;
                } else {
                    $categories_in_progress[] = $cat;
                }
            }
        }
    }
}

$smarty->assign('categories_in_progress', $categories_in_progress);
$smarty->assign('categories_completed',   $categories_completed);

$smarty->display('nieruchomosci.tpl');
