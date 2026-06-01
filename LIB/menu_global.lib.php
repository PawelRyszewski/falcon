<?php
$smarty = new Smarty();

$menuPages = DatabaseManager::selectSql("SELECT * FROM `pages` WHERE `show_in_menu` = 1 ORDER BY queue_menu ASC");

$smarty->assign('menuPages', $menuPages);
$smarty->display('menu_global.tpl');