<?php
$smarty = new Smarty();
$id = $_GET["par3"];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('pages', "id=$id");
    $_SESSION['msg_success'] = "Aktualność usunięta pomyślnie";
    header("Location: /admin/aktualnosci");
}

$page = DatabaseManager::selectSql("SELECT title FROM pages WHERE id = $id");

$smarty->assign("title", $page[0]['title']);
$smarty->display('aktualnosci-usun.tpl');
