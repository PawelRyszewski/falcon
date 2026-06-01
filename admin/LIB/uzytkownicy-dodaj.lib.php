<?php
$smarty = new Smarty();

if (isset($_POST['add_user'])) {
    $login = $_POST['login'];
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

    DatabaseManager::insertSql("users", array('login' => $login, 'password' => $password));
    $_SESSION['msg_success'] = "Użytkownik dodany pomyślnie";
    header("Location: /admin/uzytkownicy");
}

$smarty->display('uzytkownicy-dodaj.tpl');
