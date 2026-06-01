<?php
require_once './env.php';
require_once 'CLASS/DatabaseManager.class.php';
session_start();
if (!isset($_SESSION['logged_in'])) {
    http_response_code(403);
    exit('Access denied');
}
$rows = DatabaseManager::selectSql('SELECT email, confirmed, created_at FROM newsletter_subscribers ORDER BY created_at DESC');
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="newsletter.csv"');
$out = fopen('php://output', 'w');
fputcsv($out, ['email','confirmed','created_at']);
foreach ($rows as $r) {
    fputcsv($out, [$r['email'], $r['confirmed'], $r['created_at']]);
}
exit;
