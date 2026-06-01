<?php
$smarty = new Smarty();

if (isset($_POST['reset_all'])) {
    DatabaseManager::deleteSql('votes', '1=1');
    $_SESSION['msg_success'] = 'Wszystkie głosy zresetowane.';
    header('Location: /admin/votes');
    exit;
}

if (isset($_POST['reset_votes'])) {
    $modelId = (int)($_POST['model_id'] ?? 0);
    $categoryId = (int)($_POST['category_id'] ?? 0);
    DatabaseManager::deleteSql('votes', "model_id={$modelId} AND category_id={$categoryId}");
    $_SESSION['msg_success'] = 'Głosy wyzerowane.';
    header('Location: /admin/votes');
    exit;
}

if (isset($_POST['update_votes'])) {
    $modelId = (int)($_POST['model_id'] ?? 0);
    $categoryId = (int)($_POST['category_id'] ?? 0);
    $count = max(0, (int)($_POST['new_count'] ?? 0));
    DatabaseManager::deleteSql('votes', "model_id={$modelId} AND category_id={$categoryId}");
    for ($i = 0; $i < $count; $i++) {
        $ip = 'manual_' . $categoryId . '_' . $modelId . '_' . $i;
        DatabaseManager::insertSql('votes', [
            'model_id' => $modelId,
            'category_id' => $categoryId,
            'user_ip' => $ip
        ]);
    }
    $_SESSION['msg_success'] = 'Liczba głosów zaktualizowana.';
    header('Location: /admin/votes');
    exit;
}

$votesCounts = DatabaseManager::selectSql('SELECT v.model_id, v.category_id, m.name AS model_name, c.name AS category_name, COUNT(v.id) AS votes FROM votes v JOIN ai_models m ON v.model_id=m.id JOIN llm_categories c ON v.category_id=c.id GROUP BY v.model_id, v.category_id ORDER BY c.name, m.name');
$models = DatabaseManager::selectSql('SELECT id, name, category_id FROM ai_models ORDER BY name ASC');
$categories = DatabaseManager::selectSql('SELECT id, name FROM llm_categories ORDER BY name ASC');

$smarty->assign('votes_counts', $votesCounts);
$smarty->assign('models', $models);
$smarty->assign('categories', $categories);
$smarty->assign('msg_success', $_SESSION['msg_success'] ?? null);
unset($_SESSION['msg_success']);

$smarty->display('votes.tpl');