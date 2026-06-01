<?php
$schemaPath = __DIR__ . '/realestate_schema.lib.php';
if (file_exists($schemaPath)) {
    require_once $schemaPath;
}

$sourceId = (int) ($_GET['par3'] ?? 0);
if ($sourceId <= 0) {
    header('Location: /admin/nieruchomosci');
    exit;
}

$source = DatabaseManager::selectSql("SELECT * FROM pages WHERE id = {$sourceId} AND type = 'realestate' LIMIT 1");
if (!$source) {
    $_SESSION['msg_error'] = 'Nieruchomość nie istnieje.';
    header('Location: /admin/nieruchomosci');
    exit;
}
$p = $source[0];

// Unique URL
$baseUrl = rtrim($p['url'], '/') . '-kopia';
$url = $baseUrl;
$n = 1;
while (DatabaseManager::selectSql("SELECT id FROM pages WHERE url = '" . addslashes($url) . "' LIMIT 1")) {
    $url = $baseUrl . '-' . $n;
    $n++;
}

// Build new page data — copy all relevant columns, reset visibility
$pageData = [
    'url'         => $url,
    'title'       => $p['title'] . ' - kopia',
    'content'     => $p['content'] ?? '',
    'description' => $p['description'] ?? '',
    'keywords'    => $p['keywords'] ?? '',
    'type'        => 'realestate',
    'is_published' => 1,
    'is_hide'     => 0,
    'queue'       => $p['queue'] ?? 0,
];

$optionalCols = ['category', 'house_status', 'plot_area', 'usable_area', 'house_price',
                 'has_parter', 'parter_content', 'has_pietro', 'pietro_content'];
foreach ($optionalCols as $col) {
    if (isset($p[$col]) && realestate_column_exists('pages', $col)) {
        $pageData[$col] = $p[$col];
    }
}

// Insert new page (img / parter_img_id / pietro_img_id set after image copy)
$newPageId = (int) DatabaseManager::insertSql('pages', $pageData);
if (!$newPageId) {
    $_SESSION['msg_error'] = 'Nie udało się skopiować nieruchomości.';
    header('Location: /admin/nieruchomosci');
    exit;
}

// Determine images FK column
$imagesForeignKey = null;
if (function_exists('realestate_column_exists')) {
    if (realestate_column_exists('images', 'id_realestate'))  $imagesForeignKey = 'id_realestate';
    elseif (realestate_column_exists('images', 'id_page'))    $imagesForeignKey = 'id_page';
    elseif (realestate_column_exists('images', 'id_gallery')) $imagesForeignKey = 'id_gallery';
}

// Copy images — build old→new ID map
$imgIdMap = [];
if ($imagesForeignKey) {
    $images = DatabaseManager::selectSql("SELECT * FROM images WHERE {$imagesForeignKey} = {$sourceId} ORDER BY queue ASC");
    foreach ((array) $images as $img) {
        $origName = $img['name'];
        $ext  = pathinfo($origName, PATHINFO_EXTENSION);
        $base = pathinfo($origName, PATHINFO_FILENAME);
        $newName = $base . '-kopia.' . $ext;
        $n = 1;
        while (file_exists("./../uploads/" . $newName)) {
            $newName = $base . '-kopia-' . $n . '.' . $ext;
            $n++;
        }
        if (file_exists("./../uploads/" . $origName)) {
            copy("./../uploads/" . $origName, "./../uploads/" . $newName);
        }
        if (file_exists("./../uploads/thumb/" . $origName)) {
            copy("./../uploads/thumb/" . $origName, "./../uploads/thumb/" . $newName);
        }
        $imgData = array_filter($img, 'is_string', ARRAY_FILTER_USE_KEY);
        unset($imgData['id']);
        $imgData['name']              = $newName;
        $imgData[$imagesForeignKey]   = $newPageId;
        $newImgId = (int) DatabaseManager::insertSql('images', $imgData);
        $imgIdMap[(int) $img['id']] = $newImgId;
    }
}

// Update img / parter_img_id / pietro_img_id using mapped IDs
$imgUpdate = [];
$sourceImgId = (int) ($p['img'] ?? 0);
if ($sourceImgId && isset($imgIdMap[$sourceImgId])) {
    $imgUpdate['img'] = $imgIdMap[$sourceImgId];
}
if (realestate_column_exists('pages', 'parter_img_id')) {
    $srcParter = (int) ($p['parter_img_id'] ?? 0);
    $imgUpdate['parter_img_id'] = ($srcParter && isset($imgIdMap[$srcParter])) ? $imgIdMap[$srcParter] : null;
}
if (realestate_column_exists('pages', 'pietro_img_id')) {
    $srcPietro = (int) ($p['pietro_img_id'] ?? 0);
    $imgUpdate['pietro_img_id'] = ($srcPietro && isset($imgIdMap[$srcPietro])) ? $imgIdMap[$srcPietro] : null;
}
if ($imgUpdate) {
    DatabaseManager::updateSql('pages', $imgUpdate, "id = {$newPageId}");
}

// Copy investment_files
if (function_exists('realestate_table_exists') && realestate_table_exists('investment_files')) {
    $files = DatabaseManager::selectSql("SELECT * FROM investment_files WHERE investment_id = {$sourceId} AND is_active = 1 ORDER BY sort_order ASC, id ASC");
    foreach ((array) $files as $file) {
        $origPath = ltrim($file['file_path'], '/');  // e.g. uploads/somefile.pdf
        $filename = basename($origPath);
        $ext  = pathinfo($filename, PATHINFO_EXTENSION);
        $base = pathinfo($filename, PATHINFO_FILENAME);
        $newFilename = $base . '-kopia.' . $ext;
        $n = 1;
        while (file_exists('./../' . dirname($origPath) . '/' . $newFilename)) {
            $newFilename = $base . '-kopia-' . $n . '.' . $ext;
            $n++;
        }
        if (file_exists('./../' . $origPath)) {
            copy('./../' . $origPath, './../uploads/' . $newFilename);
        }
        $fileData = array_filter($file, 'is_string', ARRAY_FILTER_USE_KEY);
        unset($fileData['id']);
        $fileData['investment_id'] = $newPageId;
        $fileData['file_path']     = '/uploads/' . $newFilename;
        DatabaseManager::insertSql('investment_files', $fileData);
    }
}

$_SESSION['msg_success'] = 'Nieruchomość skopiowana pomyślnie.';
header('Location: /admin/nieruchomosci');
exit;
