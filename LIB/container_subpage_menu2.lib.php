<?php
$smarty = new Smarty();
if (isset($_GET['par2'])) {
	$url = $_GET['par1'];
	$id = $_GET['par2'];
    $page = DatabaseManager::selectSql("SELECT title, content, category FROM pages WHERE id = $id AND url = '$url'");
} else {
	$url = $_GET['par1'];
    $page = DatabaseManager::selectSql("SELECT title, content, category FROM pages WHERE url = '$url' ");
}

if ($page) {
    $smarty->assign('page', $page[0]);
    $smarty->display('container_subpage_menu2.tpl');
	
} else {
    if ($id) {
        $pageById = DatabaseManager::selectSql("SELECT url FROM pages WHERE  id = $id ");
        if ($pageById && $id && $url) {
            header("Location: /".$pageById[0]['url']."/$id");
        }
    }
	
    $smarty->display('404.tpl');
}
