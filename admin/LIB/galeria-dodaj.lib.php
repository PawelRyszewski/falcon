<?php
$smarty = new Smarty();

if (isset($_POST['add_gallery'])) {
    $url = $_POST['url'];
    $title = $_POST['title'];
    $title_seo = $_POST['title_seo'];
    $content = $_POST['content'];
    $description = $_POST['description'];
    $keywords = $_POST['keywords'];

    DatabaseManager::insertSql("pages", array(
        'title' => $title,
        'title_seo' => $title_seo,
        'url' => $url,
        'content' => $content,
        'description' => $description,
        'keywords' => $keywords,
        'type' => "gallery",
        "is_published" => 1,
    ));

    $_SESSION['msg_success'] = "Galeria dodana pomyślnie";
    header("Location: /admin/galeria-zdjec");
}

$smarty->display('galeria-dodaj.tpl');
