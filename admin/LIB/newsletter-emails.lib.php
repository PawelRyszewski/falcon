<?php
$smarty = new Smarty();

$types = [
    'subscribe' => 'Po zapisie do newslettera',
    'unsubscribe' => 'Rezygnacja przez użytkownika',
    'admin_delete' => 'Usunięcie przez administratora'
];

if (isset($_POST['save_emails'])) {
    foreach ($types as $type => $label) {
        $subject = trim($_POST['subject'][$type] ?? '');
        $body = $_POST['body'][$type] ?? '';
        if ($subject && $body) {
            $exists = DatabaseManager::selectSql("SELECT id FROM newsletter_emails WHERE type='$type'");
            if ($exists) {
                DatabaseManager::updateSql('newsletter_emails', ['subject' => $subject, 'body' => $body], "type='$type'");
            } else {
                DatabaseManager::insertSql('newsletter_emails', ['type' => $type, 'subject' => $subject, 'body' => $body]);
            }
        }
    }
    $_SESSION['msg_success'] = 'Zapisano treści wiadomości';
    header('Location: /admin/newsletter/emails');
}

$emails = [];
foreach ($types as $type => $label) {
    $row = DatabaseManager::selectSql("SELECT subject, body FROM newsletter_emails WHERE type='$type'");
    $emails[] = [
        'type' => $type,
        'label' => $label,
        'subject' => $row ? $row[0]['subject'] : '',
        'body' => $row ? $row[0]['body'] : ''
    ];
}

$smarty->assign('emails', $emails);
$smarty->display('newsletter-emails.tpl');
?>