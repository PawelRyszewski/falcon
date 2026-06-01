<?php
$smarty = new Smarty();
$page = DatabaseManager::selectSql("SELECT title, content, category, id FROM pages WHERE url = '$url' ");
$smarty->assign('page', $page[0]);
$smarty->display('footer_global_test.tpl');
