<?php
$smarty = new Smarty();
$hash = $_GET['par2'];
$now = date('Y-m-d H:i');

if (isset($_POST['new_password'])) {
  $password = password_hash($_POST['password'], PASSWORD_BCRYPT);
  DatabaseManager::updateSql("users", array('password' => $password), "password_hash_link = '$hash' AND `hash_expire` >= '$now'");
  $_SESSION['msg_success'] = "Hasło zmienione pomyślnie";
  header("Location: /admin");
}
$user = DatabaseManager::selectSql("SELECT * FROM users WHERE password_hash_link = '$hash' AND `hash_expire` >= '$now'");
var_dump(isset($user[0]));
$smarty->assign('isUser', isset($user[0]));
$smarty->display('zmien-haslo.tpl');
