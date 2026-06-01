<?php
$smarty = new Smarty();

$url = $_GET['par1'] ?? '';
$id = $_GET['par2'] ?? null;

if ($id !== null) {
    $page = DatabaseManager::selectSql("SELECT title, content FROM pages WHERE id = '$id' AND url = '$url'");
} else {
    $page = DatabaseManager::selectSql("SELECT title, content FROM pages WHERE url = '$url'");
}

if ($page) {
    $smarty->assign('page', $page[0]);
    $smarty->display('container_developer.tpl');
    return;
}

$smarty->display('404.tpl');
