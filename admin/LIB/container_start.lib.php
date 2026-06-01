<?php
$smarty = new Smarty();
$smarty->registerPlugin('function', 't', 'smarty_t');
$smarty->registerPlugin('function', 'page_url', 'smarty_page_url');

$cats_news = DatabaseManager::selectSql("SELECT id, name FROM news_categories WHERE id > 2 ORDER BY id ASC");

$currentLang = $_SESSION['lang'] ?? getDefaultLang();
$langId = getLangId($currentLang);

$latest_news = DatabaseManager::selectSql(
    "SELECT url, title, img, img_title, category FROM pages " .
    "WHERE type = 'news' AND category = 8 AND is_published = 1 AND lang = {$langId} " .
    "ORDER BY created_at DESC LIMIT 3"
);

require_once('./utils/php/functions.php');
$latest_news = array_map(function ($item) {
    if (!empty($item['img'])) {
        $item['img_thumb_path'] = resolveNewsImagePath($item['img'], true);
    } else {
        $item['img_thumb_path'] = '';
    }
    return $item;
}, $latest_news);

$languages = DatabaseManager::selectSql('SELECT name, is_default FROM pages_langs ORDER BY id ASC');

$smarty->assign('languages', $languages);
$smarty->assign('currentLang', $currentLang);
$smarty->assign('cats_news', $cats_news);
$smarty->assign('latest_news', $latest_news);
$smarty->display('container_start.tpl');
