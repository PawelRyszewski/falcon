<?php
$smarty = new Smarty();
if (isset($_SESSION['msg_success'])) {
  $smarty->assign("msg_success", $_SESSION['msg_success']);
  unset($_SESSION['msg_success']);
}
$smarty->display('head-login.tpl');
