<?php
$smarty = new Smarty();

if (isset($_POST['check_code'])) {
    $code = $_POST['code'];
    if ($code === "2323") {
        $_SESSION['code_status'] = true;
        header("Location: /home");
    }
}

$smarty->display('env_test.tpl');
