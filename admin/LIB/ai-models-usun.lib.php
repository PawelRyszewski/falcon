<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('ai_models', "id=$id");
    $_SESSION['msg_success'] = "Model usunięty pomyślnie";
    header("Location: /admin/ai-models");
    exit;
}

$name = DatabaseManager::selectSql("SELECT name FROM ai_models WHERE id = $id");
$smarty->assign('name', $name[0]['name'] ?? '');
$smarty->display('ai-models-usun.tpl');
