<?php
$smarty = new Smarty();
$smarty->registerPlugin('function', 't', 'smarty_t');
$page = DatabaseManager::selectSql("SELECT title, content, category, id FROM pages WHERE url = '$url' ");
if ($page && isset($page[0])) {
    $smarty->assign('page', $page[0]);
} else {
    $smarty->assign('page', []);
}
$smarty->display('footer_global.tpl');
