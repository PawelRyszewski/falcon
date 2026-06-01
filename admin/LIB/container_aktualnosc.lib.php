<?php
require("./utils/php/helpers.php");

$smarty = new Smarty();
$currentLang = $_SESSION['lang'] ?? getDefaultLang();
$langId = getLangId($currentLang);
$id_cat = $_GET['par2'];

if (isset($_GET['par3'])) {
    $url = $_GET['par3'];
    $news = DatabaseManager::selectSql("SELECT id, title, title_seo, content, created_at, img, img_title, content_short FROM pages WHERE url = '$url' AND lang = {$langId} ");
} else {
    $news = DatabaseManager::selectSql("SELECT id, title, title_seo,content, created_at, img, img_title, content_short FROM pages WHERE category = $id_cat AND lang = {$langId} ORDER BY id DESC LIMIT 1");
}

$news_id = $news[0]['id'];

$prev_news = DatabaseManager::selectSql("SELECT title, title_seo,url FROM pages WHERE id > $news_id AND type = 'news' AND category = $id_cat AND lang = {$langId} ORDER BY id ASC LIMIT 1");
$next_news = DatabaseManager::selectSql("SELECT title, title_seo,url FROM pages WHERE id < $news_id AND type = 'news' AND category = $id_cat AND lang = {$langId} ORDER BY id DESC LIMIT 1");

if (isset($prev_news[0])){
	$smarty->assign('prev_news', $prev_news[0]);
} else {
	$smarty->assign('prev_news', $prev_news);
}

if (isset($next_news[0])){
	$smarty->assign('next_news', $next_news[0]);
} else {
	$smarty->assign('next_news', $next_news);
}

$smarty->assign('news', $news[0]);
$smarty->assign('id_cat', $id_cat);
$smarty->display('container_aktualnosc.tpl');