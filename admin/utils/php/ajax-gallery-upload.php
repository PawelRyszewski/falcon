<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");
require_once(__DIR__ . "/functions.php");

header('Content-Type: application/json; charset=utf-8');
while (ob_get_level() > 0) { ob_end_clean(); }

function gallery_upload_fail($msg, $code = 400)
{
    http_response_code($code);
    echo json_encode(['ok' => false, 'error' => $msg]);
    exit;
}

$idGallery = isset($_POST['id_gallery']) ? (int) $_POST['id_gallery'] : 0;
if ($idGallery <= 0) {
    gallery_upload_fail('Brak id galerii');
}

if (empty($_FILES['upload']) || !isset($_FILES['upload']['tmp_name'])) {
    gallery_upload_fail('Nie wybrano pliku');
}

$err = $_FILES['upload']['error'] ?? UPLOAD_ERR_NO_FILE;
if ($err !== UPLOAD_ERR_OK) {
    gallery_upload_fail('Błąd przesyłania pliku (' . (int) $err . ')');
}

$origName = (string) $_FILES['upload']['name'];
$tmpPath  = (string) $_FILES['upload']['tmp_name'];
$ext      = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
$allowed  = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
if (!in_array($ext, $allowed, true)) {
    gallery_upload_fail('Niedozwolony format. Dozwolone: ' . implode(', ', $allowed));
}

$uploadsDir = './../uploads';
$thumbDir   = './../uploads/thumb';
if ((int) $idGallery === 111) {
    $uploadsDir = './../ai-materials/uploads';
    $thumbDir   = './../ai-materials/uploads/thumb';
}
if (!file_exists($uploadsDir)) { mkdir($uploadsDir, 0777, true); }
if (!file_exists($thumbDir))   { mkdir($thumbDir, 0777, true); }

$rawTitle = trim((string) ($_POST['img_title'] ?? ''));
$baseName = $rawTitle !== '' ? $rawTitle : pathinfo($origName, PATHINFO_FILENAME);
$baseName = removeDiacritics($baseName);
$baseName = preg_replace('/[^a-zA-Z0-9_-]+/', '-', strtolower($baseName));
$baseName = trim($baseName, '-');
if ($baseName === '') {
    $baseName = 'img-' . date('YmdHis') . '-' . mt_rand(1000, 9999);
}

$webpName = get_unique_filename($uploadsDir, $baseName . '.webp');
$destPath = $uploadsDir . '/' . $webpName;

if (!move_uploaded_file($tmpPath, $destPath)) {
    gallery_upload_fail('Nie udało się zapisać pliku');
}

if (function_exists('resizeImageNoWatermark')) {
    resizeImageNoWatermark($destPath, $destPath, 1500, 1200);
}
$thumbName = get_unique_filename($thumbDir, $webpName);
$thumbPath = $thumbDir . '/' . $thumbName;
if (function_exists('resizeAndCropImageNoWatermark')) {
    resizeAndCropImageNoWatermark($destPath, $thumbPath, 400, 400);
}

$insertTitle = $rawTitle !== '' ? $rawTitle : pathinfo($origName, PATHINFO_FILENAME);
$idImg = DatabaseManager::insertSql('images', [
    'name'       => $webpName,
    'title'      => $insertTitle,
    'id_gallery' => $idGallery,
]);

echo json_encode([
    'ok'    => true,
    'id'    => (int) $idImg,
    'name'  => $webpName,
    'title' => $insertTitle,
]);
