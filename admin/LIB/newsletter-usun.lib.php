<?php
$smarty = new Smarty();
$id = $_GET['par3'];
$subscriber = DatabaseManager::selectSql("SELECT email, name FROM newsletter_subscribers WHERE id = $id");

if (isset($_POST['confirm_delete'])) {
    DatabaseManager::deleteSql('newsletter_subscribers', "id=$id");
    if ($subscriber) {
        $to = $subscriber[0]['email'];
        $name = $subscriber[0]['name'];
        $template = DatabaseManager::selectSql("SELECT subject, body FROM newsletter_emails WHERE type='admin_delete'");
        if ($template) {
            $subject = $template[0]['subject'];
            $body = str_replace('{{name}}', $name, $template[0]['body']);
        } else {
            $subject = 'Usunięto z newslettera';
            $body = "Użytkowniku $name, zostałeś wypisany z newslettera.";
        }
		
        require_once '../utils/php/helpers.php';
        sendEmail($to, $subject, $body);
    }
    $_SESSION['msg_success'] = 'Subskrybent usunięty pomyślnie';
    header('Location: /admin/newsletter');
}

$smarty->assign('subscriber', $subscriber ? $subscriber[0] : null);
$smarty->display('newsletter-usun.tpl');