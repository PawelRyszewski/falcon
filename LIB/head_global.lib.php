<?php
$smarty = new Smarty();

$url = "";
$description = "";
$title = "";
$title_seo = "";
$keywords = "";
$ogImage = "/utils/images/404b.png";
$themeColor = "#091423";
$currentDate = date("d-m-Y");
$day = date("d");
$month = date("m");
$year = date("Y");
$views = 1;
$par1 = isset($_GET['par1']) ? $_GET['par1'] : "";

if (isset($_GET['par2'])) {
    $url = $_GET['par2'];
} elseif (isset($_GET['par1'])) {
    $url = $_GET['par1'];
}

$modelMeta = [];
if ($par1 === 'model' && $url) {
    require_once __DIR__ . '/../CLASS/VoteManager.class.php';
    $modelMeta = VoteManager::getModelBySlug($url) ?: [];
}

// Homepage SEO always comes from the dedicated page record with id=0
if ($par1 === 'start') {
    $metaData = DatabaseManager::selectSql("SELECT title, title_seo, description, keywords FROM pages WHERE id = 0 LIMIT 1");
} else {
    $metaData = DatabaseManager::selectSql("SELECT title, title_seo, description, keywords FROM pages WHERE url = '$url'");
}

// /inwestycje/{slug} — when no property page matches, fall back to category SEO
if (empty($metaData) && $par1 === 'inwestycje' && !empty($_GET['par2'])) {
    $dbNameCat = getenv('DB_NAME');
    if ($dbNameCat) {
        $dbNameCatSafe = addslashes($dbNameCat);
        $catTableExists = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{$dbNameCatSafe}' AND TABLE_NAME = 'realestate_categories' LIMIT 1");
        if (!empty($catTableExists[0]['qty'])) {
            $catSeoCols = ['name'];
            foreach (['title_seo', 'meta_description', 'keywords', 'url'] as $col) {
                $colSafe = addslashes($col);
                $colCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameCatSafe}' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = '{$colSafe}' LIMIT 1");
                if (!empty($colCheck[0]['qty'])) {
                    $catSeoCols[] = $col;
                }
            }
            $allCatsForSeo = DatabaseManager::selectSql("SELECT " . implode(',', $catSeoCols) . " FROM realestate_categories");
            if ($allCatsForSeo) {
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
                $matchedCatSeo = null;
                foreach ($allCatsForSeo as $catSeoRow) {
                    if (!empty($catSeoRow['url']) && $catSeoRow['url'] === $_GET['par2']) {
                        $matchedCatSeo = $catSeoRow;
                        break;
                    }
                }
                if ($matchedCatSeo === null) {
                    foreach ($allCatsForSeo as $catSeoRow) {
                        if (categorySlug($catSeoRow['name']) === $_GET['par2']) {
                            $matchedCatSeo = $catSeoRow;
                            break;
                        }
                    }
                }
                if ($matchedCatSeo !== null) {
                    $metaData = [[
                        'title'       => $matchedCatSeo['name'],
                        'title_seo'   => $matchedCatSeo['title_seo'] ?? '',
                        'description' => $matchedCatSeo['meta_description'] ?? '',
                        'keywords'    => $matchedCatSeo['keywords'] ?? '',
                    ]];
                }
            }
        }
    }
}

$url = strlen($url) == 0 ? "/" : $url;

if ($par1 != "/admin" && $metaData) {
    DatabaseManager::insertSql("daily_views", array(
        'id' => $currentDate,
        'day' => $day,
        'month' => $month,
        'year' => $year,
        'views' => 1,
    ), "ON DUPLICATE KEY UPDATE views=views+1");


    DatabaseManager::insertSql("monthly_views", array(
        'date' => $year."-".$month,      
        'month' => $month,
        'year' => $year,
        'url' => $url,
        'views' => 1,
    ), "ON DUPLICATE KEY UPDATE views=views+1");
}

DatabaseManager::incrementValue("pages", "visit = visit + 1", "url = '{$url}'");

if ($metaData && $metaData[0]) {
    $description = $metaData[0]['description'];
    $title = $metaData[0]['title'];
    $title_seo = $metaData[0]['title_seo'];		
    $keywords = $metaData[0]['keywords'];
} elseif ($modelMeta) {
	$description = $modelMeta['meta_description'] ?? '';
    $title = $modelMeta['meta_title'] ?: ($modelMeta['name'] ?? '');
    $title_seo = $title;
    $keywords = $modelMeta['meta_keywords'] ?? '';
}

if (strlen($description) == 0) {
    $description = "EKO-DOM realizuje inwestycje mieszkaniowe premium: domy i mieszkania w zielonych lokalizacjach, z dopracowanym standardem i funkcjonalnymi układami.";
}

if (strlen($title) == 0) {
    $title = "EKO-DOM – inwestycje mieszkaniowe i nowoczesne osiedla";
}

if (strlen($keywords) == 0) {
    $keywords = "EKO-DOM, inwestycje EKO-DOM, inwestycje mieszkaniowe, deweloper, nowe domy, nowe mieszkania, nieruchomości";
}

if(strlen($title_seo) == 0) {
    $title_seo = $title;
}

if ($par1 === 'blog' && isset($_GET['par2']) && !isset($_GET['par3'])) {
    $categoryId = (int)$_GET['par2'];
    $category = DatabaseManager::selectSql("SELECT name FROM news_categories WHERE id = {$categoryId} LIMIT 1");
    if ($category && isset($category[0]['name'])) {
        $title = $title_seo = $title . ' - ' . $category[0]['name'];
    }
}

$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$host = $_SERVER['HTTP_HOST'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$canonical = $scheme . '://' . $host . $path;
$pageParam = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
if ($pageParam > 1) {
    $canonical .= '?page=' . $pageParam;
}

$requestUri = $_SERVER['REQUEST_URI'] ?? '/';
$ogUrl = $scheme . '://' . $host . $requestUri;

if ($par1 === 'inwestycje' && isset($_GET['par2']) && !empty($_GET['par2'])) {
    $dbName = getenv('DB_NAME');
    $imagesForeignKey = null;
    if ($dbName) {
        $dbNameSafe = addslashes($dbName);
        foreach (['id_realestate', 'id_page', 'id_gallery'] as $candidateColumn) {
            $candidateColumnSafe = addslashes($candidateColumn);
            $columnCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = 'images' AND COLUMN_NAME = '{$candidateColumnSafe}' LIMIT 1");
            if (!empty($columnCheck[0]['qty'])) {
                $imagesForeignKey = $candidateColumn;
                break;
            }
        }
    }

    $investmentSlug = addslashes($_GET['par2']);
    $investmentData = DatabaseManager::selectSql("SELECT id, img FROM pages WHERE type = 'realestate' AND url = '{$investmentSlug}' LIMIT 1");

    if ($investmentData && isset($investmentData[0]['id'])) {
        $investmentId = (int)$investmentData[0]['id'];
        $mainImageId = isset($investmentData[0]['img']) ? (int)$investmentData[0]['img'] : 0;

        if ($mainImageId > 0) {
            $mainImage = DatabaseManager::selectSql("SELECT name FROM images WHERE id = {$mainImageId} LIMIT 1");
            if ($mainImage && !empty($mainImage[0]['name'])) {
                $ogImage = '/uploads/' . $mainImage[0]['name'];
            }
        }

        if ($ogImage === "/utils/images/404b.png" && $imagesForeignKey) {
            $fallbackImage = DatabaseManager::selectSql("SELECT name FROM images WHERE {$imagesForeignKey} = {$investmentId} ORDER BY queue ASC, id ASC LIMIT 1");
            if ($fallbackImage && !empty($fallbackImage[0]['name'])) {
                $ogImage = '/uploads/' . $fallbackImage[0]['name'];
            }
        }
    }
}

if (strpos($ogImage, 'http://') !== 0 && strpos($ogImage, 'https://') !== 0) {
    $ogImage = $scheme . '://' . $host . $ogImage;
}

$prevUrl = null;
$nextUrl = null;
if ($par1 === 'blog') {
    $catId = null;
    if (isset($_GET['par2']) && !isset($_GET['par3'])) {
        $catId = (int)$_GET['par2'];
    }
    $perPage = 15;
    $countSql = "SELECT COUNT(*) as cnt FROM pages WHERE type = 'news'";
    if ($catId) {
        $countSql .= " AND category = {$catId}";
    }
    $totalRes = DatabaseManager::selectSql($countSql);
    $total = $totalRes ? (int)$totalRes[0]['cnt'] : 0;
    $totalPages = $total > 0 ? (int)ceil($total / $perPage) : 1;

    $baseUrl = '/' . $par1;
    if ($catId) {
        $baseUrl .= '/' . $catId;
    }

    if ($pageParam > 1) {
        $prevPage = $pageParam - 1;
        $prevUrl = $baseUrl;
        if ($prevPage > 1) {
            $prevUrl .= '?page=' . $prevPage;
        }
    }
    if ($pageParam < $totalPages) {
        $nextPage = $pageParam + 1;
        $nextUrl = $baseUrl . '?page=' . $nextPage;
    }
}


$smarty->assign('description', $description);
$smarty->assign('title', $title);
$smarty->assign('title_seo', $title_seo);
$smarty->assign('keywords', $keywords);
$smarty->assign('canonical_url', $canonical);
$smarty->assign('og_url', $ogUrl);
$smarty->assign('og_image', $ogImage);
$smarty->assign('theme_color', $themeColor);
if ($prevUrl) {
    $smarty->assign('prev_url', $prevUrl);
}
if ($nextUrl) {
    $smarty->assign('next_url', $nextUrl);
}
$smarty->display('head_global.tpl');
