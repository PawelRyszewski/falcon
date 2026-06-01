<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_edit'])) {
    $name = $_POST['name'];
    DatabaseManager::updateSql("news_categories", array('name' => $name), "id={$id}");
    $_SESSION['msg_success'] = "Edycja wykonana pomyślnie";
    header("Location: /admin/aktualnosci/kategorie");
}


$name = DatabaseManager::selectSql("SELECT name FROM news_categories WHERE id = $id");

$smarty->assign('name', $name[0]['name']);
$smarty->display('aktualnosci-kategorie-edytuj.tpl');
