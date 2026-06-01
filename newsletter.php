<?php
require_once './env.php';
require_once './CLASS/DatabaseManager.class.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $status = 'error';
    if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $exists = DatabaseManager::selectSql("SELECT id FROM newsletter_subscribers WHERE email = '".$email."'");
        if (!$exists) {
            $token = bin2hex(random_bytes(16));
            DatabaseManager::insertSql('newsletter_subscribers', [
                'name' => $name,
                'email' => $email,
                'token' => $token
            ]);
            $link = 'https://'.$_SERVER['HTTP_HOST'].'/newsletter.php?unsubscribe='.$token;
          
            $template = DatabaseManager::selectSql("SELECT subject, body FROM newsletter_emails WHERE type='subscribe'");
            if ($template) {
                $subject = $template[0]['subject'];
                $body = str_replace(['{{name}}','{{unsubscribe_link}}'], [$name, $link], $template[0]['body']);
            } else {
                $subject = 'Potwierdzenie zapisu do newslettera';
                $body = "Dziękujemy za zapis do newslettera.<br/>Możesz zrezygnować klikając w poniższy link:<br/>".$link;
            }
            require_once './utils/php/helpers.php';
            sendEmail($email, $subject, $body);			
			
            $status = 'ok';
        } else {
            $status = 'exists';
        }
    } else {
        $status = 'invalid';
    }

    $isAjax = !empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest';
    if ($isAjax) {
        header('Content-Type: application/json');
        echo json_encode(['status' => $status]);
    } else {
        $param = $status === 'ok' ? 'ok' : 'err';
        header('Location: /?newsletter=' . $param);
    }
    exit;
}

if (isset($_GET['unsubscribe'])) {
    $token = $_GET['unsubscribe'];
	
    $subscriber = DatabaseManager::selectSql("SELECT email, name FROM newsletter_subscribers WHERE token = '".$token."'");
        $template = DatabaseManager::selectSql("SELECT subject, body FROM newsletter_emails WHERE type='unsubscribe'");
        if ($template) {
            $subject = $template[0]['subject'];
            $body = str_replace('{{name}}', $subscriber[0]['name'], $template[0]['body']);
            require_once './utils/php/helpers.php';
            sendEmail($subscriber[0]['email'], $subject, $body);
        }
	
    if ($subscriber) {
        DatabaseManager::deleteSql('newsletter_subscribers', "token='".$token."'");
        echo 'Zostałeś wypisany z newslettera.';
    } else {
        echo 'Nieprawidłowy link.';
    }
    exit;
}

echo 'Błąd zapytania.';