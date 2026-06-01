<?php
$specialChars = "";
$url_seo = "";
$smarty = new Smarty();
$categoryId = null;
$url = $_GET['par1'];
if (isset($_GET['par2']) && !isset($_GET['par3'])) {
    $categoryId = (int)$_GET['par2'];
}

$currentLang = $_SESSION['lang'] ?? getDefaultLang();
$langId = getLangId($currentLang);

$sql = "SELECT url, title, content, created_at, img, img_title, content_short, category " .
       "FROM pages WHERE type = 'news' AND lang = {$langId}";
if ($categoryId) {
    $sql .= " AND category = {$categoryId}";
}
$sql .= " ORDER BY queue ASC, created_at DESC";

$news = DatabaseManager::selectSql($sql);
$cats_news = DatabaseManager::selectSql("SELECT * FROM `news_categories`");

foreach ($cats_news as $key => $value) {
    //$url_seo = str_replace(array_keys($specialChars), $specialChars, $value['name']);
    $url_seo = str_replace(' ', '-', $url_seo);
    $url_seo = preg_replace('/[^A-Za-z0-9\-]/', '', $url_seo);
    $cats_news[$key]["url_seo"] = strtolower($url_seo);
}

$smarty->assign('news', $news);
$smarty->assign('cats_news', $cats_news);
$smarty->assign('selected_category', $categoryId);

$smarty->display('container_aktualnosci.tpl');