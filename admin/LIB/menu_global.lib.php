<?php
$smarty = new Smarty();
$smarty->registerPlugin('function', 't', 'smarty_t');
$smarty->registerPlugin('function', 'page_url', 'smarty_page_url');

$menuPages = DatabaseManager::selectSql(
    "SELECT * FROM `pages` WHERE `show_in_menu` = 1 AND `is_published` = 1 ORDER BY queue_menu ASC"
);

$languages = DatabaseManager::selectSql('SELECT name, is_default FROM pages_langs ORDER BY id ASC');
$currentLang = $_SESSION['lang'] ?? getDefaultLang();

$smarty->assign('menuPages', $menuPages);
$smarty->assign('languages', $languages);
$smarty->assign('currentLang', $currentLang);
$smarty->display('menu_global.tpl');