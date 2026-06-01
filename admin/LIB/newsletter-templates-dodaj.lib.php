<?php
$smarty = new Smarty();
if (isset($_POST['add_template'])) {
    $name = trim($_POST['name']);
    $subject = trim($_POST['subject']);
    $body = $_POST['body'];
    if ($name && $subject && $body) {
        DatabaseManager::insertSql('newsletter_templates', [
            'name' => $name,
            'subject' => $subject,
            'body' => $body
        ]);
        $_SESSION['msg_success'] = 'Szablon dodany pomyślnie';
        header('Location: /admin/newsletter/templates');
    }
}
$smarty->display('newsletter-templates-dodaj.tpl');
?>