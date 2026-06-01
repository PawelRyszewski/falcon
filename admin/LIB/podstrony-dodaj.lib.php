<?php
$smarty = new Smarty();

if (isset($_POST['add_page_and_show']) || isset($_POST['add_page'])) {
    $title = $_POST['title'];
    $title_seo = $_POST['title_seo'];
    $content = $_POST['content'];
    $url = $_POST['url'];
    $description = $_POST['description'];
    $keywords = $_POST['keywords'];
    $show_in_menu = $_POST['show_in_main_menu'];
    $lang = $_POST['lang'];
    $category = $_POST['category'];
    $who_fill = 1;
    $is_published = isset($_POST['add_page_and_show']) ? 1 : 0;

    DatabaseManager::insertSql("pages", array(
        'title' => $title,
        'title_seo' => $title_seo,
        'content' => $content,
        'url' => $url,
        'description' => $description,
        'keywords' => $keywords,
        'show_in_menu' => $show_in_menu,
        "who_fill" => $who_fill,
		"lang" => $lang,
        "category" => $category,
        "is_published" => $is_published,
    ));
    $_SESSION['msg_success'] = "Podstrona dodana pomyślnie";
    header("Location: /admin/podstrony");
}

$languages = DatabaseManager::selectSql("SELECT * FROM pages_langs");
$categories = DatabaseManager::selectSql('SELECT * FROM pages_categories ORDER BY id DESC');

$smarty->assign('languages', $languages);
$smarty->assign('categories', $categories);
$smarty->display('podstrony-dodaj.tpl');