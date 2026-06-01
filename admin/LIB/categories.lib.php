<?php
$smarty = new Smarty();

if (isset($_POST['add_category'])) {
    $data = [
        'name' => $_POST['name'] ?? '',
        'json_file' => ltrim($_POST['json_file'] ?? '', '/'),
        'create_missing_models' => isset($_POST['create_missing_models']) ? 1 : 0,
        'json_limit' => isset($_POST['json_limit']) ? (int)$_POST['json_limit'] : null,
		'json_top' => isset($_POST['json_top']) ? 1 : 0,
        'json_refresh_hour' => isset($_POST['json_refresh_hour']) && $_POST['json_refresh_hour'] !== '' ? (int)$_POST['json_refresh_hour'] : null
    ];
    $id = DatabaseManager::insertSql('llm_categories', $data);
    $data['id'] = $id;
    require_once '../CLASS/VoteManager.class.php';
    VoteManager::refreshCategoryFromJson($data);
    VoteManager::updateVotesSite($id);
    $_SESSION['msg_success'] = 'Kategoria dodana.';
    header('Location: /admin/categories');
    exit;
}

$categories = DatabaseManager::selectSql('SELECT * FROM llm_categories ORDER BY id DESC');
$smarty->assign('categories', $categories);
$smarty->assign('msg_success', $_SESSION['msg_success'] ?? null);
unset($_SESSION['msg_success']);
$smarty->display('categories.tpl');