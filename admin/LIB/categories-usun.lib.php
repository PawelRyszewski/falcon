<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('llm_categories', "id=$id");
    $_SESSION['msg_success'] = "Kategoria usunięta pomyślnie";
    header("Location: /admin/categories");
    exit;
}

$name = DatabaseManager::selectSql("SELECT name FROM llm_categories WHERE id = $id");
$smarty->assign('name', $name[0]['name'] ?? '');
$smarty->display('categories-usun.tpl');