<?php
$smarty = new Smarty();

if(isset($_POST['toggle_publish'])){
    $id_page = (int)$_POST['id_page'];
    $is_published = (int)$_POST['is_published'];
    DatabaseManager::updateSql("pages", array('is_published' => $is_published), "id={$id_page} AND type = 'subpage'");
    $_SESSION['msg_success'] = "Edycja podstrony wykonana pomyślnie";
    header("Location: /admin/podstrony");
    exit;
}

$pages = DatabaseManager::selectSql('SELECT p.*, l.name AS lang_name, c.name AS category_name FROM pages p LEFT JOIN pages_langs l ON p.lang = l.id LEFT JOIN pages_categories c ON p.category = c.id WHERE p.type = "subpage" ORDER BY p.id DESC');
$users = DatabaseManager::selectSqlGroup('SELECT id, login FROM users ORDER BY id DESC');

$smarty->assign('pages', $pages);
$smarty->assign('users', $users);

$smarty->display('podstrony.tpl');
