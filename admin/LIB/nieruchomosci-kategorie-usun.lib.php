<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('realestate_categories', "id=$id");

    $_SESSION['msg_success'] = "Kategoria usunięta pomyślnie";
    header("Location: /admin/nieruchomosci/kategorie");
}

$name = DatabaseManager::selectSql("SELECT name FROM realestate_categories WHERE id = $id");

$smarty->assign('name', $name[0]['name']);
$smarty->display('nieruchomosci-kategorie-usun.tpl');
