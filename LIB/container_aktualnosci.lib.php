<?php
$specialChars = "";
$url_seo = "";
$smarty = new Smarty();
$smarty->registerPlugin('function', 't', 'smarty_t');
require_once("./utils/php/helpers.php");

$categoryId = null;
$url = $_GET['par1'];

if (isset($_GET['par2']) && !isset($_GET['par3'])) {
    $categoryId = (int)$_GET['par2'];
}

$perPage = 15;
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$offset = ($page - 1) * $perPage;

$categoryName = null;
if ($categoryId) {
    $category = DatabaseManager::selectSql("SELECT name FROM news_categories WHERE id = {$categoryId} LIMIT 1");
    if ($category && isset($category[0]['name'])) {
        $categoryName = $category[0]['name'];
    }
}

$countSql = "SELECT COUNT(*) as cnt FROM pages WHERE type = 'news' AND is_published = 1";
if ($categoryId) {
    $countSql .= " AND category = {$categoryId}";
}

$totalRes = DatabaseManager::selectSql($countSql);
$total = $totalRes ? (int)$totalRes[0]['cnt'] : 0;
$totalPages = $total > 0 ? (int)ceil($total / $perPage) : 1;

if ($page > $totalPages) {
    $page = $totalPages;
    $offset = ($page - 1) * $perPage;
}

$sql = "SELECT url, title, content, created_at, img, img_title, content_short, category
        FROM pages
        WHERE type = 'news' AND is_published = 1";
if ($categoryId) {
    $sql .= " AND category = {$categoryId}";
}

$sql .= " ORDER BY queue ASC, created_at DESC";
$sql .= " LIMIT {$perPage} OFFSET {$offset}";

$news = DatabaseManager::selectSql($sql);
if (!$news) {
    $news = [];
}

$news = array_map(function ($item) {
    if (!empty($item['img'])) {
        $item['img_thumb_path'] = resolveNewsImagePath($item['img'], true);
    } else {
        $item['img_thumb_path'] = '';
    }
    return $item;
}, $news);

$cats_news = DatabaseManager::selectSql("SELECT * FROM `news_categories`");
if (!$cats_news) {
    $cats_news = [];
}

foreach ($cats_news as $key => $value) {
    //$url_seo = str_replace(array_keys($specialChars), $specialChars, $value['name']);
    $url_seo = str_replace(' ', '-', $url_seo);
    $url_seo = preg_replace('/[^A-Za-z0-9\-]/', '', $url_seo);
    $cats_news[$key]["url_seo"] = strtolower($url_seo);
}

$smarty->assign('news', $news);
$smarty->assign('cats_news', $cats_news);
$smarty->assign('selected_category', $categoryId);

$baseUrl = '/' . $url;
if ($categoryId) {
    $baseUrl .= '/' . $categoryId;
}
$smarty->assign('pagination_base_url', $baseUrl);
$smarty->assign('current_page', $page);
$smarty->assign('total_pages', $totalPages);
$smarty->assign('pages', range(1, $totalPages));

if ($categoryName) {
    $smarty->assign('category_name', $categoryName);
}

$smarty->display('container_aktualnosci.tpl');