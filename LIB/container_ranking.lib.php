<?php
$smarty = new Smarty();
require_once './CLASS/VoteManager.class.php';
$smarty->assign('message', null);

if (isset($_POST['vote'])) {
    $modelId = (int)($_POST['model_id'] ?? 0);
    $categoryId = (int)($_POST['category_id'] ?? 0);
    $captcha = $_POST['captcha'] ?? '';
    $captchaSession = $_SESSION['captcha'] ?? '';
    unset($_SESSION['captcha']);
    if ($captchaSession && strcasecmp($captchaSession, $captcha) === 0) {
        $ip = $_SERVER['REMOTE_ADDR'];
        $success = VoteManager::castVote($modelId, $categoryId, $ip);
        $smarty->assign('message', $success ? 'Dziękujemy za głos.' : 'Już głosowałeś w tej kategorii.');
    } else {
        $smarty->assign('message', 'Niepoprawna captcha.');
    }
}

$categories = VoteManager::getCategoriesWithResults();
foreach ($categories as &$cat) {
    if (isset($cat['results']) && is_array($cat['results'])) {
        foreach ($cat['results'] as &$res) {
            $res['model']['slug'] = VoteManager::slugify($res['model']['name']);
        }
    }
}
unset($res, $cat);

$smarty->assign('categories', $categories);
$smarty->display('container_ranking.tpl');