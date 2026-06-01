<?php
header('Content-Type: application/json');

$root = realpath(__DIR__ . '/../../../');
$dirs = [
    '/ai-materials/uploads',
    '/uploads'
];
$allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
$images = [];

foreach ($dirs as $base) {
    $thumbDir = $root . $base . '/thumb';
    if (!is_dir($thumbDir)) {
        continue;
    }
    if ($handle = opendir($thumbDir)) {
        while (($file = readdir($handle)) !== false) {
            if ($file === '.' || $file === '..') {
                continue;
            }
			$ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
            if (!in_array($ext, $allowedExtensions)) {
                continue;
            }
            $images[] = [
                'thumb' => $base . '/thumb/' . $file,
                'full' => $base . '/' . $file,
            ];
        }
        closedir($handle);
    }
}	
echo json_encode(['images' => $images]);
exit;