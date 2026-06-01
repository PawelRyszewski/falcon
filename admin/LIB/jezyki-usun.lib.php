<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_delete'])) {
    $lang = DatabaseManager::selectSql("SELECT name, is_default FROM pages_langs WHERE id = $id");
    if ($lang && $lang[0]['is_default'] == 1) {
        $_SESSION['msg_error'] = "Nie można usunąć języka domyślnego";
    } else {
        DatabaseManager::deleteSql('pages_langs', "id=$id");
        if ($lang) {
            $path = dirname(__DIR__,2) . '/langs/' . $lang[0]['name'] . '.php';
            if (file_exists($path)) {
                unlink($path);
            }
        }
        $_SESSION['msg_success'] = "Język usunięty pomyślnie";
    }
    header("Location: /admin/jezyki");
}

$name = DatabaseManager::selectSql("SELECT name FROM pages_langs WHERE id = $id");

$smarty->assign('name', $name[0]['name']);
$smarty->display('jezyki-usun.tpl');