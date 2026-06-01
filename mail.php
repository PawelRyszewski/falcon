<?php
require_once './env.php';
require_once './CLASS/DatabaseManager.class.php';
require_once './utils/php/helpers.php';

$name             = trim($_POST['name'] ?? '');
$email            = trim($_POST['email'] ?? '');
$phone            = trim($_POST['phone'] ?? '');
$message          = trim($_POST['message'] ?? '');
$consentMarketing = isset($_POST['consent_marketing']) ? 1 : 0;
$consentEmail     = isset($_POST['consent_email']) ? 1 : 0;
$consentPhone     = isset($_POST['consent_phone']) ? 1 : 0;

// Ensure required columns exist in newsletter_subscribers
$dbName = getenv('DB_NAME');
if ($dbName) {
    $dbNameSafe = addslashes($dbName);
    $pdo = DatabaseManager::getConnection();
    $newColumns = [
        'phone'             => "VARCHAR(50) DEFAULT NULL",
        'consent_marketing' => "TINYINT NOT NULL DEFAULT 0",
        'consent_email'     => "TINYINT NOT NULL DEFAULT 0",
        'consent_phone'     => "TINYINT NOT NULL DEFAULT 0",
        'message'           => "TEXT DEFAULT NULL",
    ];
    foreach ($newColumns as $col => $def) {
        $colSafe = addslashes($col);
        $exists = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'newsletter_subscribers' AND COLUMN_NAME = '$colSafe' LIMIT 1");
        if (empty($exists[0]['qty'])) {
            try {
                $pdo->exec("ALTER TABLE `newsletter_subscribers` ADD COLUMN `$col` $def");
            } catch (Exception $e) {
                error_log("[SCHEMA WARNING] newsletter_subscribers.$col: " . $e->getMessage());
            }
        }
    }
}

// Save contact form submission to newsletter_subscribers
try {
    DatabaseManager::insertSql('newsletter_subscribers', [
        'name'              => $name,
        'email'             => $email,
        'phone'             => $phone,
        'message'           => $message,
        'consent_marketing' => $consentMarketing,
        'consent_email'     => $consentEmail,
        'consent_phone'     => $consentPhone,
        'token'             => bin2hex(random_bytes(12)),
    ]);
} catch (Exception $e) {
    error_log('[mail.php] DB insert error: ' . $e->getMessage());
}

// Send email notification
$recipient = 'kontakt@weo.pl';
$subject   = 'Formularz kontaktowy';
$body      = '<p><strong>Od:</strong> ' . htmlspecialchars($name) . '</p>'
           . '<p><strong>Telefon:</strong> ' . htmlspecialchars($phone) . '</p>'
           . '<p><strong>Email:</strong> ' . htmlspecialchars($email) . '</p>'
           . '<p><strong>Wiadomość:</strong><br>' . nl2br(htmlspecialchars($message)) . '</p>';

sendEmail($recipient, $subject, $body);

echo "<script type='text/javascript'>window.location.href='/wiadomosc-zostala-wyslana'</script>";
