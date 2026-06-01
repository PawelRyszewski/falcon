<?php
$smarty = new Smarty();

if (isset($_SESSION['msg_success'])) {
    $smarty->assign("msg_success", $_SESSION['msg_success']);
    unset($_SESSION['msg_success']);
}

if (isset($_SESSION['msg_error'])) {
    $smarty->assign("msg_error", $_SESSION['msg_error']);
    unset($_SESSION['msg_error']);
}

if (isset($_POST['logout'])) {
    unset($_SESSION['login']);
    unset($_SESSION['logged_in']);

    header("Location: /admin");
}

$smarty->assign('user',$_SESSION['login']);
$smarty->display('head.tpl');
