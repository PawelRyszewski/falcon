<?php
$smarty = new Smarty();
$id = (int)($_GET['par3'] ?? 0);
$cat = DatabaseManager::selectSql("SELECT * FROM llm_categories WHERE id = {$id} LIMIT 1");
if ($cat) {
    require_once '../CLASS/VoteManager.class.php';
    VoteManager::refreshCategoryFromJson($cat[0], true);
    VoteManager::updateVotesSite($id);
    $_SESSION['msg_success'] = 'JSON przeładowany.';
}
header('Location: /admin/categories');
exit;