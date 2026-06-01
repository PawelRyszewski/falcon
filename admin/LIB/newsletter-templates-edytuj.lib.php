<?php
$smarty = new Smarty();
$id = (int)($_GET['par3'] ?? 0);
$template = DatabaseManager::selectSql("SELECT * FROM newsletter_templates WHERE id = $id");
if (!$template) {
    header('Location: /admin/newsletter/templates');
    exit;
}
$template = $template[0];
if (isset($_POST['edit_template'])) {
    $name = trim($_POST['name']);
    $subject = trim($_POST['subject']);
    $body = $_POST['body'];
    if ($name && $subject && $body) {
        DatabaseManager::updateSql('newsletter_templates', [
            'name' => $name,
            'subject' => $subject,
            'body' => $body
        ], "id=$id");
        $_SESSION['msg_success'] = 'Szablon zaktualizowany pomyślnie';
        header('Location: /admin/newsletter/templates');
        exit;
    }
}
$smarty->assign('template', $template);
$smarty->display('newsletter-templates-edytuj.tpl');
?>