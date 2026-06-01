<?php
require_once('./utils/php/sendMailRestartPassword.php');

$smarty = new Smarty();

if (isset($_SESSION['new_password_send'])) {
  $smarty->assign("new_password_send", $_SESSION['new_password_send']);
  unset($_SESSION['new_password_send']);
}


if (isset($_POST['new_password'])){
  $login = $_POST['login'];
  $bytes = random_bytes(32);
  $password_hash_link = bin2hex($bytes);
  $start = date('Y-m-d H:i');
  $hash_expire = date('Y-m-d H:i',strtotime('+20 minutes',strtotime($start)));;

  DatabaseManager::updateSql(
    "users",
    array(
      'password_hash_link' => $password_hash_link,
      'hash_expire' => $hash_expire,
  ),
  "login='{$login}'");
  $_SESSION['new_password_send'] = 'true';
  sendMail($login, $password_hash_link);
  header("Location: /admin/przypomnij-haslo");
}

$smarty->display('przypomnij-haslo.tpl');
