<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_edit'])) {
    $name = $_POST['name'];
    DatabaseManager::updateSql("pages_langs", array('name' => $name), "id={$id}");
    $_SESSION['msg_success'] = "Edycja wykonana pomyślnie";
    header("Location: /admin/jezyki");
}

$name = DatabaseManager::selectSql("SELECT name FROM pages_langs WHERE id = $id");

$smarty->assign('name', $name[0]['name']);
$smarty->display('jezyki-edytuj.tpl');