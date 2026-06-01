<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['confirm_edit'])) {
    $data = [
    'name' => $_POST['name'] ?? '',
    'json_file' => ltrim($_POST['json_file'] ?? '', '/'),
    'create_missing_models' => isset($_POST['create_missing_models']) ? 1 : 0,
    'json_limit' => isset($_POST['json_limit']) ? (int)$_POST['json_limit'] : null,
    'json_top' => isset($_POST['json_top']) ? 1 : 0,
    'json_refresh_hour' => isset($_POST['json_refresh_hour']) && $_POST['json_refresh_hour'] !== '' ? (int)$_POST['json_refresh_hour'] : null,
	];
	DatabaseManager::updateSql('llm_categories', $data, "id={$id}");
    $data['id'] = $id;
    require_once '../CLASS/VoteManager.class.php';
    VoteManager::refreshCategoryFromJson($data);
    VoteManager::updateVotesSite($id);
    $_SESSION['msg_success'] = "Kategoria zaktualizowana pomyślnie";
    header("Location: /admin/categories");
    exit;
}

$category = DatabaseManager::selectSql("SELECT * FROM llm_categories WHERE id = $id");
$smarty->assign('category', $category[0] ?? []);
$smarty->display('categories-edytuj.tpl');