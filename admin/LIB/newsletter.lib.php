<?php
$smarty = new Smarty();

if (isset($_POST['send_template'])) {
    $templateId = (int)($_POST['template_id'] ?? 0);
    $recipients = $_POST['recipients'] ?? [];
    if ($templateId && !empty($recipients)) {
        $template = DatabaseManager::selectSql("SELECT subject, body FROM newsletter_templates WHERE id=$templateId");
        if ($template) {
            foreach ($recipients as $id) {
                $sub = DatabaseManager::selectSql("SELECT email, name FROM newsletter_subscribers WHERE id=".(int)$id);
                if ($sub) {
                    $body = str_replace('{{name}}', $sub[0]['name'], $template[0]['body']);
                    require_once '../utils/php/helpers.php';
                    sendEmail($sub[0]['email'], $template[0]['subject'], $body);
                }
            }
            $_SESSION['msg_success'] = 'Wiadomości zostały wysłane';
        }
    } else {
        $_SESSION['msg_error'] = 'Wybierz odbiorców i szablon.';
    }
    header('Location: /admin/newsletter');
}

$dbName = getenv('DB_NAME');
$hasNewCols = false;
if ($dbName) {
    $dbNameSafe = addslashes($dbName);
    $colCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'newsletter_subscribers' AND COLUMN_NAME = 'phone' LIMIT 1");
    $hasNewCols = !empty($colCheck[0]['qty']);
}
if ($hasNewCols) {
    $subscribers = DatabaseManager::selectSql('SELECT id, name, email, phone, consent_marketing, consent_email, consent_phone, message, created_at FROM newsletter_subscribers ORDER BY created_at DESC');
} else {
    $subscribers = DatabaseManager::selectSql("SELECT id, name, email, '' AS phone, 0 AS consent_marketing, 0 AS consent_email, 0 AS consent_phone, '' AS message, created_at FROM newsletter_subscribers ORDER BY created_at DESC");
}
$templates = DatabaseManager::selectSql('SELECT id, name, subject, body FROM newsletter_templates ORDER BY id DESC');

$smarty->assign('subscribers', $subscribers);
$smarty->assign('templates', $templates);
$smarty->display('newsletter.tpl');