<?php
require_once __DIR__ . '/../env.php';
require_once __DIR__ . '/../CLASS/DatabaseManager.class.php';
require_once __DIR__ . '/../CLASS/VoteManager.class.php';

header('Content-Type: application/json');

define('API_KEY', 'SEKRET123');

if (
    !isset($_SERVER['HTTP_X_API_KEY']) ||
    $_SERVER['HTTP_X_API_KEY'] !== API_KEY
) {
    http_response_code(401);
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit;
}

$rawInput = file_get_contents('php://input');
$data     = json_decode($rawInput, true);

if (!is_array($data)) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Invalid JSON payload']);
    exit;
}

foreach ($data as $page) {
    if (
        !isset(
            $page['title'], $page['title_seo'], $page['url'],
            $page['content'], $page['description'], $page['keywords']
        )
    ) {
        continue;
    }

    DatabaseManager::insertSql('pages', [
        'title'         => $page['title'],
        'title_seo'     => $page['title_seo'],
        'content'       => $page['content'],
        'url'           => $page['url'],
        'description'   => $page['description'],
        'keywords'      => $page['keywords'],
        'show_in_menu'  => 0,
        'who_fill'      => 1,
        'type'          => $page['type']          ?? 'subpage',
        'img'           => $page['filename']      ?? null,
        'img_title'     => $page['title']         ?? null,
        'content_short' => $page['content_short'] ?? null,
        'category'      => isset($page['category']) ? (int) $page['category'] : 0,
        'is_published'  => 1,
    ]);

    if (!empty($page['filename'])) {
        DatabaseManager::insertSql('images', [
            'name'       => $page['filename'],
            'title'      => $page['title_seo'],
            'id_gallery' => 111,
        ]);
    }
}

echo json_encode(['status' => 'ok']);
