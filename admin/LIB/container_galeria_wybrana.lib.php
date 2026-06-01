<?php
$smarty = new Smarty();

$list_gallery = DatabaseManager::selectSql("SELECT url, title FROM pages WHERE is_hide = 0 AND img is not NULL AND type = 'gallery' ORDER BY queue ASC, created_at DESC");

if ($list_gallery) {
    $mainUrl = array_map(function ($page_url) {
        return ' <a href="' . $page_url['url'] . '" title="'. $page_url['title'] .'">' . $page_url['title'] . ' </a>';
    }, $list_gallery);
}

$smarty->assign('list_url', $mainUrl);


$url = $_GET['par2'];
$gallery = DatabaseManager::selectSql("SELECT id, url, content, title, img, created_at FROM pages WHERE url = '$url' AND type ='gallery'");
$id_gallery = $gallery[0]["id"];
$images = DatabaseManager::selectSql("SELECT name, title FROM images WHERE id_gallery = $id_gallery ORDER BY queue ASC");

$smarty->assign('gallery', $gallery[0]);
$smarty->assign('images', $images);

$smarty->display('container_galeria_wybrana.tpl');