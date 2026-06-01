<?php
$smarty = new Smarty();
$id = $_GET["par3"];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('users', "id=$id");
    $_SESSION['msg_success'] = "Użytkownik usunięty pomyślnie";
    header("Location: /admin/uzytkownicy");
}

$user = DatabaseManager::selectSql("SELECT login FROM users WHERE id = $id");

$smarty->assign("login", $user[0]['login']);
$smarty->display('uzytkownicy-usun.tpl');
