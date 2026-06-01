<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('pages_categories', "id=$id");

    $_SESSION['msg_success'] = "Kategoria usunięta pomyślnie";
    header("Location: /admin/podstrony/kategorie");
}


$name = DatabaseManager::selectSql("SELECT name FROM pages_categories WHERE id = $id");

$smarty->assign('name', $name[0]['name']);
$smarty->display('podstrony-kategorie-usun.tpl');
