<?php
$smarty = new Smarty();
require_once('./utils/php/functions.php');

if(isset($_POST['toggle_hide'])){
    $id_page = (int)$_POST['id_page'];
    $is_hide = (int)$_POST['is_hide'];

    DatabaseManager::updateSql("pages", array('is_hide' => $is_hide), "id={$id_page} AND type = 'news'");

    $_SESSION['msg_success'] = "Edycja aktualności wykonana pomyślnie";
    $redirect = '/admin/aktualnosci';
    if(!empty($_GET['category'])) {
        $redirect .= '?category=' . (int)$_GET['category'];
    }
    header("Location: {$redirect}");
    exit;
}

if(isset($_POST['toggle_publish'])){
    $id_page = (int)$_POST['id_page'];
    $is_published = (int)$_POST['is_published'];

    DatabaseManager::updateSql("pages", array('is_published' => $is_published), "id={$id_page} AND type = 'news'");

    $_SESSION['msg_success'] = "Edycja aktualności wykonana pomyślnie";
    $redirect = '/admin/aktualnosci';
    if(!empty($_GET['category'])) {
        $redirect .= '?category=' . (int)$_GET['category'];
    }
    header("Location: {$redirect}");
    exit;
}

$categoryFilter = isset($_GET['category']) ? (int)$_GET['category'] : 0;
$sql = "SELECT p.*, c.name AS category_name, l.name AS lang_name FROM pages p LEFT JOIN news_categories c ON p.category = c.id LEFT JOIN pages_langs l ON p.lang = l.id WHERE p.type = 'news'";
if($categoryFilter > 0) {
    $sql .= " AND p.category = {$categoryFilter}";
}
$sql .= " ORDER BY p.queue ASC, p.created_at DESC";
$news = DatabaseManager::selectSql($sql);
$news = array_map(function($item) {
    if (!empty($item['img'])) {
        $item['img_thumb_path'] = resolveNewsImagePath($item['img'], true);
    } else {
        $item['img_thumb_path'] = '';
    }
    return $item;
}, $news);
$categories = DatabaseManager::selectSql('SELECT id, name FROM news_categories ORDER BY id ASC');
$users = DatabaseManager::selectSqlGroup('SELECT id, login FROM users ORDER BY id DESC');

$smarty->assign('users', $users);
$smarty->assign('news', $news);
$smarty->assign('categories', $categories);
$smarty->assign('selected_category', $categoryFilter);

$smarty->display('aktualnosci.tpl');
