<?php
$id = (int)($_GET['par3'] ?? 0);
$template = DatabaseManager::selectSql("SELECT name, subject, body FROM newsletter_templates WHERE id = $id");
if ($template) {
    $t = $template[0];
    DatabaseManager::insertSql('newsletter_templates', [
        'name' => $t['name'] . ' - kopia',
        'subject' => $t['subject'],
        'body' => $t['body']
    ]);
    $_SESSION['msg_success'] = 'Szablon zduplikowany pomyślnie';
}
header('Location: /admin/newsletter/templates');
exit;
?>