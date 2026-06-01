<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('news_categories', "id=$id");

    $_SESSION['msg_success'] = "Kategoria usunięta pomyślnie";
    header("Location: /admin/aktualnosci/kategorie");
}


$name = DatabaseManager::selectSql("SELECT name FROM news_categories WHERE id = $id");

$smarty->assign('name', $name[0]['name']);
$smarty->display('aktualnosci-kategorie-usun.tpl');
