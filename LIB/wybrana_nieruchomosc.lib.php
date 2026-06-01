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

// If par2 matches a category slug, delegate to nieruchomosci.lib.php with category filter set
$_par2ForCategory = $_GET['par2'] ?? '';
if ($_par2ForCategory !== '') {
    $catDbName = getenv('DB_NAME');
    if ($catDbName) {
        $catDbNameSafe = addslashes($catDbName);
        $catTableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$catDbNameSafe' AND TABLE_NAME = 'realestate_categories' LIMIT 1");
        if (!empty($catTableCheck[0]['qty'])) {
            $catUrlColExists = !empty(DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$catDbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'url' LIMIT 1")[0]['qty']);
            $catLookupCols = $catUrlColExists ? 'id, name, url' : 'id, name';
            $allCategories = DatabaseManager::selectSql("SELECT {$catLookupCols} FROM realestate_categories");
            if ($allCategories) {
                $matchedCategoryId = 0;
                foreach ($allCategories as $_cat) {
                    if (!empty($_cat['url']) && $_cat['url'] === $_par2ForCategory) {
                        $matchedCategoryId = (int) $_cat['id'];
                        break;
                    }
                }
                if ($matchedCategoryId === 0) {
                    foreach ($allCategories as $_cat) {
                        if (categorySlug($_cat['name']) === $_par2ForCategory) {
                            $matchedCategoryId = (int) $_cat['id'];
                            break;
                        }
                    }
                }
                if ($matchedCategoryId > 0) {
                    $_GET['kategoria'] = $matchedCategoryId;
                    require_once 'nieruchomosci.lib.php';
                    return;
                }
            }
        }
    }
}

$smarty = new Smarty();

$dbName = getenv('DB_NAME');

$columnExists = function ($tableName, $columnName) use ($dbName) {
    if (!$dbName) {
        return false;
    }
    $tableName = addslashes($tableName);
    $columnName = addslashes($columnName);
    $dbNameSafe = addslashes($dbName);
    $res = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = '$tableName' AND COLUMN_NAME = '$columnName' LIMIT 1");
    return !empty($res[0]['qty']);
};

$pagesRealestateStatusExists = $columnExists('pages', 'realestate_status');
$imagesForeignKey = null;
foreach (['id_realestate', 'id_page', 'id_gallery'] as $candidateColumn) {
    if ($columnExists('images', $candidateColumn)) {
        $imagesForeignKey = $candidateColumn;
        break;
    }
}

if ($pagesRealestateStatusExists) {
    $list_realestate = DatabaseManager::selectSql("SELECT url, title, realestate_status FROM pages WHERE is_hide = 0 AND img is not NULL AND type = 'realestate' ORDER BY queue ASC, created_at DESC");
} else {
    error_log("[SCHEMA WARNING] Missing pages.realestate_status column. Falling back to default status=0 in wybrana_nieruchomosc.lib.php (list)");
    $list_realestate = DatabaseManager::selectSql("SELECT url, title FROM pages WHERE is_hide = 0 AND img is not NULL AND type = 'realestate' ORDER BY queue ASC, created_at DESC");
}

$mainUrl = [];
if ($list_realestate) {
    $mainUrl = array_map(function ($page_url) {
        return [
            'url' => '/inwestycje/' . $page_url['url'],
            'title' => $page_url['title'],
            'status' => (int) ($page_url['realestate_status'] ?? 0),
        ];
    }, $list_realestate);
}

$url = $_GET['par2'] ?? '';
$url = addslashes($url);
if ($pagesRealestateStatusExists) {
    $realestate = DatabaseManager::selectSql("SELECT id, url, content, title, img, created_at, realestate_status, category FROM pages WHERE url = '$url' AND type ='realestate'");
} else {
    error_log("[SCHEMA WARNING] Missing pages.realestate_status column. Falling back to default status=0 in wybrana_nieruchomosc.lib.php (details)");
    $realestate = DatabaseManager::selectSql("SELECT id, url, content, title, img, created_at, category FROM pages WHERE url = '$url' AND type ='realestate'");
}

if (!$realestate) {
    $smarty->display('404.tpl');
    return;
}

if (!isset($realestate[0]['realestate_status'])) {
    $realestate[0]['realestate_status'] = 0;
}

$id_realestate = (int) $realestate[0]['id'];

// #2: Fetch category name for composite title
$categoryName = '';
$categoryId   = (int) ($realestate[0]['category'] ?? 0);
if ($categoryId > 0 && $dbName) {
    $dbNameSafe4 = addslashes($dbName);
    $catTableCheck4 = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe4' AND TABLE_NAME = 'realestate_categories' LIMIT 1");
    if (!empty($catTableCheck4[0]['qty'])) {
        $catRow4 = DatabaseManager::selectSql("SELECT name FROM realestate_categories WHERE id = {$categoryId} LIMIT 1");
        $categoryName = $catRow4[0]['name'] ?? '';
    }
}
$smarty->assign('category_name', $categoryName);

$images = [];
if ($imagesForeignKey) {
    $dbNameFront = (string) getenv('DB_NAME');
    $hideFilter  = '';
    if ($dbNameFront !== '') {
        $dbNSafe    = addslashes($dbNameFront);
        $colExists  = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNSafe}' AND TABLE_NAME = 'images' AND COLUMN_NAME = 'hide_from_slider' LIMIT 1");
        if (!empty($colExists[0]['qty'])) {
            $hideFilter = ' AND COALESCE(hide_from_slider, 0) = 0';
        }
    }
    $images = DatabaseManager::selectSql("SELECT name, title FROM images WHERE {$imagesForeignKey} = $id_realestate{$hideFilter} ORDER BY queue ASC");
} else {
    error_log("[SCHEMA WARNING] Missing images relation column for realestate details (expected id_realestate, id_page or id_gallery).");
}

$houseStatuses = [
    0 => 'Dostępny',
    1 => 'Sprzedany',
    2 => 'Rezerwacja',
];

$tableExists = function ($tableName) use ($dbName) {
    if (!$dbName) {
        return false;
    }
    $tableName = addslashes($tableName);
    $dbNameSafe = addslashes($dbName);
    $res = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = '$tableName' LIMIT 1");
    return !empty($res[0]['qty']);
};

$id_investment = $id_realestate;
if ($tableExists('investments')) {
    $investment = DatabaseManager::selectSql("SELECT id, slug, status FROM investments WHERE slug = '$url' LIMIT 1");
    if (!empty($investment)) {
        $id_investment = (int) $investment[0]['id'];
    }
}

$houses = [];
if ($tableExists('investment_units')) {
    $housesRaw = DatabaseManager::selectSql("SELECT id, unit_name, area_m2, price, status FROM investment_units WHERE investment_id = $id_investment ORDER BY id ASC");
    foreach ($housesRaw as $houseRow) {
        $statusRaw = trim((string) ($houseRow['status'] ?? 'Rezerwacja'));
        $statusMap = [
            'dostępny' => 0,
            'dostepny' => 0,
            'sprzedany' => 1,
            'rezerwacja' => 2,
        ];
        $statusKey = mb_strtolower($statusRaw);
        $statusId = isset($statusMap[$statusKey]) ? $statusMap[$statusKey] : 2;

        $areaHouse = (float) ($houseRow['area_m2'] ?? 0);
        $price = (float) ($houseRow['price'] ?? 0);

        $houses[] = [
            'id' => (int) $houseRow['id'],
            'symbol' => $houseRow['unit_name'] ?: ('DOM-' . (int) $houseRow['id']),
            'powierzchnia' => $areaHouse > 0 ? number_format($areaHouse, 1, ',', ' ') . ' m²' : '—',
            'dzialka' => '—',
            'cena' => $price > 0 ? number_format($price, 0, ',', ' ') . ' zł' : 'Zapytaj o cenę',
            'status' => $houseStatuses[$statusId],
            'status_id' => $statusId,
            'plot_number' => '',
            'hotspot_x' => null,
            'hotspot_y' => null,
        ];
    }
}

$infrastructure = [];
if ($tableExists('realestate_infrastructure')) {
    $infraRows = DatabaseManager::selectSql("SELECT name, distance_label, icon, queue FROM realestate_infrastructure WHERE id_realestate = $id_realestate ORDER BY queue ASC, id ASC");
    foreach ($infraRows as $infra) {
        $infrastructure[] = [
            'name' => $infra['name'] ?? '',
            'distance' => $infra['distance_label'] ?? '',
            'icon' => $infra['icon'] ?? '',
        ];
    }
}

$floorplans = [];
if ($tableExists('realestate_floorplans')) {
    $planRows = DatabaseManager::selectSql("SELECT floor_key, floor_name, room_name, area, queue FROM realestate_floorplans WHERE id_realestate = $id_realestate ORDER BY floor_key ASC, queue ASC, id ASC");
    foreach ($planRows as $row) {
        $floorKey = trim((string) ($row['floor_key'] ?? 'parter'));
        if ($floorKey === '') {
            $floorKey = 'parter';
        }
        if (!isset($floorplans[$floorKey])) {
            $floorplans[$floorKey] = [
                'key' => $floorKey,
                'name' => $row['floor_name'] ?: ucfirst($floorKey),
                'rooms' => [],
                'total_area' => 0,
            ];
        }

        $roomArea = (float) ($row['area'] ?? 0);
        $floorplans[$floorKey]['rooms'][] = [
            'name' => $row['room_name'] ?: 'Pomieszczenie',
            'area' => $roomArea > 0 ? number_format($roomArea, 2, ',', ' ') . ' m²' : '—',
        ];
        $floorplans[$floorKey]['total_area'] += $roomArea;
    }

    foreach ($floorplans as $k => $plan) {
        $floorplans[$k]['total_area_label'] = $plan['total_area'] > 0 ? number_format($plan['total_area'], 2, ',', ' ') . ' m²' : '—';
    }
}

$downloads = [];
if ($tableExists('investment_files')) {
    $fileRows = DatabaseManager::selectSql("SELECT title, file_path, file_type, sort_order FROM investment_files WHERE investment_id = $id_investment AND is_active = 1 ORDER BY sort_order ASC, id ASC");
    foreach ($fileRows as $row) {
        if (empty($row['file_path'])) {
            continue;
        }
        $downloads[] = [
            'title' => $row['title'] ?: 'Plik do pobrania',
            'path' => $row['file_path'],
            'type' => strtolower((string) ($row['file_type'] ?? '')), 
        ];
    }
}

$cmsFrontendMap = [
    'houses' => [
        'table' => 'investment_units',
        'cms_fields' => ['unit_name', 'unit_number', 'area_m2', 'rooms', 'price', 'status', 'floorplan_file'],
        'frontend' => ['Tabela domów', 'Hotspoty planu osiedla', 'Statusy i metraże'],
    ],
    'infrastructure' => [
        'table' => 'realestate_infrastructure',
        'cms_fields' => ['name', 'distance_label', 'icon', 'queue'],
        'frontend' => ['Pasek ikon i odległości'],
    ],
    'floorplans' => [
        'table' => 'realestate_floorplans',
        'cms_fields' => ['floor_key', 'floor_name', 'room_name', 'area', 'queue'],
        'frontend' => ['Rzuty: parter/piętro z listą pomieszczeń'],
    ],
    'files' => [
        'table' => 'investment_files',
        'cms_fields' => ['title', 'file_path', 'file_type', 'published_at', 'sort_order', 'is_active'],
        'frontend' => ['Sekcja plików do pobrania'],
    ],
];

// #5: Floor sections data (Parter / Piętro / Poddasze)
$floorData = [
    'has_parter'       => 0,
    'parter_img_id'    => 0,
    'parter_content'   => '',
    'has_pietro'       => 0,
    'pietro_img_id'    => 0,
    'pietro_content'   => '',
    'has_poddasze'     => 0,
    'poddasze_img_id'  => 0,
    'poddasze_content' => '',
];
$parterImgName   = '';
$pietroImgName   = '';
$poddaszeImgName = '';

if ($columnExists('pages', 'has_parter')) {
    $selectCols = "has_parter, parter_img_id, parter_content, has_pietro, pietro_img_id, pietro_content";
    if ($columnExists('pages', 'has_poddasze')) {
        $selectCols .= ", has_poddasze, poddasze_img_id, poddasze_content";
    }
    $floorRow = DatabaseManager::selectSql("SELECT {$selectCols} FROM pages WHERE id = {$id_realestate} LIMIT 1");
    if (!empty($floorRow[0])) {
        $floorData = array_merge($floorData, $floorRow[0]);
    }
}
if ((int) $floorData['parter_img_id'] > 0) {
    $r = DatabaseManager::selectSql("SELECT name FROM images WHERE id = " . (int) $floorData['parter_img_id'] . " LIMIT 1");
    $parterImgName = $r[0]['name'] ?? '';
}
if ((int) $floorData['pietro_img_id'] > 0) {
    $r = DatabaseManager::selectSql("SELECT name FROM images WHERE id = " . (int) $floorData['pietro_img_id'] . " LIMIT 1");
    $pietroImgName = $r[0]['name'] ?? '';
}
if ((int) $floorData['poddasze_img_id'] > 0) {
    $r = DatabaseManager::selectSql("SELECT name FROM images WHERE id = " . (int) $floorData['poddasze_img_id'] . " LIMIT 1");
    $poddaszeImgName = $r[0]['name'] ?? '';
}
$smarty->assign('floor', $floorData);
$smarty->assign('parter_img_name', $parterImgName);
$smarty->assign('pietro_img_name', $pietroImgName);
$smarty->assign('poddasze_img_name', $poddaszeImgName);

$smarty->assign('list_url', $mainUrl);
$smarty->assign('realestate', $realestate[0]);
$smarty->assign('images', $images ?: []);
$smarty->assign('houses', $houses);
$smarty->assign('status_labels', $houseStatuses);
$smarty->assign('infrastructure', $infrastructure);
$smarty->assign('floorplans', $floorplans);
$smarty->assign('downloads', $downloads);
$smarty->assign('cms_frontend_map', $cmsFrontendMap);
$smarty->display('wybrana_nieruchomosc.tpl');
