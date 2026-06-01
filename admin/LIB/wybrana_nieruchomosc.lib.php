<?php
$smarty = new Smarty();

$list_realestate = DatabaseManager::selectSql("SELECT url, title, realestate_status FROM pages WHERE is_hide = 0 AND img is not NULL AND type = 'realestate' ORDER BY queue ASC, created_at DESC");

if ($list_realestate) {
    $mainUrl = array_map(function ($page_url) {
        return ' <a class="type'. $page_url['realestate_status'] .'" href="' . $page_url['url'] . '" title="'. $page_url['title'] .'">' . $page_url['title'] . ' </a>';
    }, $list_realestate);
}

$smarty->assign('list_url', $mainUrl);


$url = $_GET['par2'];
$realestate = DatabaseManager::selectSql("SELECT id, url, content, title, img, created_at, realestate_status FROM pages WHERE url = '$url' AND type ='realestate'");
$id_realestate = $realestate[0]["id"];
$images = DatabaseManager::selectSql("SELECT name, title FROM images WHERE id_realestate = $id_realestate ORDER BY queue ASC");

$smarty->assign('realestate', $realestate[0]);
$smarty->assign('images', $images);

$smarty->display('wybrana_nieruchomosc.tpl');


