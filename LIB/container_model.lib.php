<?php
$smarty = new Smarty();
require_once './CLASS/VoteManager.class.php';

$modelSlug = $_GET['par2'] ?? '';
$model = VoteManager::getModelBySlug($modelSlug);
$modelId = $model['id'] ?? 0;

if ($model && isset($_POST['vote'])) {
    $captcha = $_POST['captcha'] ?? '';
    $captchaSession = $_SESSION['captcha'] ?? '';
    unset($_SESSION['captcha']);
    if ($captchaSession && strcasecmp($captchaSession, $captcha) === 0) {
        $ip = $_SERVER['REMOTE_ADDR'];
        $success = VoteManager::castVote($modelId, $model['category_id'], $ip);
        $smarty->assign('message', $success ? 'Dziękujemy za głos.' : 'Już głosowałeś na ten model.');
    } else {
        $smarty->assign('message', 'Niepoprawna captcha.');
    }
}

$categoryName = $model ? VoteManager::getCategoryName($model['category_id']) : '';

$smarty->assign('model', $model);
$smarty->assign('categoryName', $categoryName);
$smarty->display('container_model.tpl');