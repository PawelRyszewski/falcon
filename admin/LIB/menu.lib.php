<?php
$smarty = new Smarty();

$menuPages = DatabaseManager::selectSql("SELECT * FROM `pages` WHERE `show_in_menu` = 1 ORDER BY `id` ASC");

$smarty->assign('menuPages', $menuPages);
$smarty->display('menu.tpl');