<?php
$smarty = new Smarty();
$id = $_GET["par3"];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('pages', "id=$id");
    $_SESSION['msg_success'] = "Podstrona usunięta pomyślnie";
    header("Location: /admin/podstrony");
}

$page = DatabaseManager::selectSql("SELECT title FROM pages WHERE id = $id");

$smarty->assign("title", $page[0]['title']);
$smarty->display('podstrony-usun.tpl');
