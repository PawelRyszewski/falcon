<?php
$smarty = new Smarty();
if (isset($_POST['sign_in'])) {
    $captchaSession = $_SESSION['captcha'];
    $captchaPost = $_POST['captcha'];

    if ($captchaSession !== $captchaPost) {
        $smarty->assign('captcha_error', true);
    } else {
        $login = $_POST['login'];
        $password = $_POST['password'];

        $user = DatabaseManager::selectSql("SELECT password FROM users WHERE login = '$login'");

        if (is_null($user)) {
            $smarty->assign('auth_error', true);
        } else {
            if (!password_verify($password, $user[0]['password'])) {
                $smarty->assign('auth_error', true);
            } else {
                $_SESSION['login'] = $login;
                $_SESSION['logged_in'] = true;

                $_SESSION['msg_success'] = "Zalogowano pomyślnie";
                header("Location: /admin");
            }
        }
    }
}


$smarty->display('login.tpl');
