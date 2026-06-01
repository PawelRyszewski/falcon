<?php
$smarty = new Smarty();
$id = $_GET['par3'];
if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('newsletter_templates', "id=$id");
    $_SESSION['msg_success'] = 'Szablon usunięty pomyślnie';
    header('Location: /admin/newsletter/templates');
}
$template = DatabaseManager::selectSql("SELECT name FROM newsletter_templates WHERE id = $id");
$smarty->assign('name', $template ? $template[0]['name'] : '');
$smarty->display('newsletter-templates-usun.tpl');
?>