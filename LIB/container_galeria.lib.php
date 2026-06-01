<?php
$smarty = new Smarty();

$galleries = DatabaseManager::selectSql("SELECT id, url, title, img, description, content, created_at FROM pages WHERE is_hide = 0 AND img is not NULL AND type = 'gallery' ORDER BY queue ASC, created_at DESC");


if ($galleries) {
    $mainImagesId = array_map(function ($gallery) {
        return $gallery['img'];
    }, $galleries);
	
    $whereMainImages = implode(",", $mainImagesId);
	
    $mainImages = DatabaseManager::selectSqlGroup("SELECT id, name FROM images WHERE id IN ($whereMainImages)");
}

$smarty->assign('galleries', $galleries);
$smarty->assign('mainImages', $mainImages);


$smarty->display('container_galeria.tpl');
