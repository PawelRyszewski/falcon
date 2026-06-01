<?php
require("./utils/php/helpers.php");

$smarty = new Smarty();
$id_cat = $_GET['par2'];

$category = DatabaseManager::selectSql("SELECT name FROM news_categories WHERE id = $id_cat LIMIT 1");
$category_name = $category ? $category[0]['name'] : null;

if (isset($_GET['par3'])) {
    $url = $_GET['par3'];
    $news = DatabaseManager::selectSql("SELECT id, title, title_seo, content, created_at, img, img_title, content_short FROM pages WHERE url = '$url' ");
} else {
    $news = DatabaseManager::selectSql("SELECT id, title, title_seo,content, created_at, img, img_title, content_short FROM pages WHERE category = $id_cat ORDER BY id DESC LIMIT 1");
}

$news_id = $news[0]['id'];
if (!empty($news[0]['img'])) {
    $news[0]['img_path'] = resolveNewsImagePath($news[0]['img']);
	$news[0]['img_thumb_path'] = resolveNewsImagePath($news[0]['img'], true);
}

$prev_news = DatabaseManager::selectSql("SELECT title, title_seo,url FROM pages WHERE id > $news_id AND type = 'news' AND category = $id_cat ORDER BY id ASC LIMIT 1");
$next_news = DatabaseManager::selectSql("SELECT title, title_seo,url FROM pages WHERE id < $news_id AND type = 'news' AND category = $id_cat ORDER BY id DESC LIMIT 1");

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
if ($category_name) {
    $smarty->assign('category_name', $category_name);
}
$smarty->display('container_aktualnosc.tpl');