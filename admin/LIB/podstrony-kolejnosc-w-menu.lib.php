<?php
$smarty = new Smarty();

$pages = DatabaseManager::selectSql('SELECT * FROM pages WHERE show_in_menu = 1 ORDER BY queue_menu ASC');

$smarty->assign('pages', $pages);
$smarty->display('podstrony-kolejnosc-w-menu.tpl');
