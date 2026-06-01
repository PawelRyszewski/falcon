<?php
$id = (int)($_GET['par3'] ?? 0);
$page = DatabaseManager::selectSql("SELECT * FROM pages WHERE id = $id");
if ($page) {
    $p = $page[0];
    DatabaseManager::insertSql('pages', [
        'url' => $p['url'] . '-kopia',
        'title' => $p['title'] . ' - kopia',
        'title_seo' => $p['title_seo'],
        'img' => $p['img'],
        'img_title' => $p['img_title'],
        'content' => $p['content'],
        'content_short' => $p['content_short'],
        'description' => $p['description'],
        'keywords' => $p['keywords'],
        'show_in_menu' => $p['show_in_menu'],
        'who_fill' => $p['who_fill'],
        'visit' => 0,
        'type' => $p['type'],
        'queue' => $p['queue'],
        'queue_menu' => $p['queue_menu'],
        'category' => $p['category'],
        'is_hide' => $p['is_hide'],
        'is_published' => $p['is_published'],
        'lang' => $p['lang'],
    ]);
    $_SESSION['msg_success'] = 'Podstrona zduplikowana pomyślnie';
}
header('Location: /admin/podstrony');
exit;
?>