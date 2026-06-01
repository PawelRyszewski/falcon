<?php
$smarty = new Smarty();
$record = DatabaseManager::selectSql('SELECT * FROM menu_snippets LIMIT 1');
if (isset($_POST["save_snippets"])) {
    $before = $_POST["html_before"];
    $after = $_POST["html_after"];
    if ($record) {
        DatabaseManager::updateSql('menu_snippets', ['html_before'=>$before,'html_after'=>$after], 'id=' . $record[0]['id']);
    } else {
        DatabaseManager::insertSql('menu_snippets', ['html_before'=>$before,'html_after'=>$after]);
    }
    $_SESSION['msg_success'] = 'Zapisano zmiany';
    header('Location: /admin/menu-html');
}
$record = DatabaseManager::selectSql('SELECT * FROM menu_snippets LIMIT 1');
$before = $record ? $record[0]['html_before'] : '';
$after = $record ? $record[0]['html_after'] : '';
$smarty->assign('before', $before);
$smarty->assign('after', $after);
$smarty->display('menu-html.tpl');
