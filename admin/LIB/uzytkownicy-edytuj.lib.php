<?php
$smarty = new Smarty();
$id = $_GET["par3"];

$user = DatabaseManager::selectSql("SELECT * FROM users WHERE id = $id");

if (isset($_POST['edit_user'])) {
    DatabaseManager::updateSql("users", array('login' => $_POST['login']), "id={$id}");

    $_SESSION['msg_success'] = "Edycja loginu wykonana pomyślnie";
    header("Location: /admin/uzytkownicy/edytuj/{$id}");
}

if (isset($_POST['edit_password'])) {
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT);
    DatabaseManager::updateSql("users", array('password' => $password), "id={$id}");

    $_SESSION['msg_success'] = "Edycja hasła wykonana pomyślnie";
    header("Location: /admin/uzytkownicy/edytuj/{$id}");
}

$smarty->assign("user", $user[0]);
$smarty->display('uzytkownicy-edytuj.tpl');
