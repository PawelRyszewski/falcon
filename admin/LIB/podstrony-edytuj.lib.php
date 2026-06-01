<?php
$smarty = new Smarty();
$id = (int)$_GET["par3"];

// Ensure homepage page (id=0) exists in the database
if ($id === 0) {
    $existing = DatabaseManager::selectSql("SELECT id FROM pages WHERE id = 0 LIMIT 1");
    if (!$existing) {
        $pdo = DatabaseManager::getConnection();
        $pdo->exec("SET SESSION sql_mode = concat(@@sql_mode, ',NO_AUTO_VALUE_ON_ZERO')");
        $stmt = $pdo->prepare(
            "INSERT IGNORE INTO pages (id, title, type, content, content_short, title_seo, description, keywords, url, show_in_menu, is_published, who_fill) " .
            "VALUES (0, 'Strona Główna', 'subpage', '', '', '', '', '', '', 0, 1, 1)"
        );
        $stmt->execute();
    }
}

if (isset($_POST['edit_page'])) {
    $title = $_POST['title'];
    $title_seo = $_POST['title_seo'];
    $content = $_POST['content'];
    $description = $_POST['description'];
    $keywords = $_POST['keywords'];
    $who_fill = 1;
    $category = $_POST['category'];
	$lang = $_POST['lang'];
    $is_published = $_POST['is_published'];

    $updateData = array(
        'title' => $title,
        'title_seo' => $title_seo,
        'content' => $content,
        'description' => $description,
        'keywords' => $keywords,
        "who_fill" => $who_fill,
        "category" => $category,
		"lang" => $lang,
        "is_published" => $is_published,
    );

    if ($id === 0) {
        // Homepage: save hero image (0 = none) and overlay content; skip url and show_in_menu
        // Use 0 instead of null for img to avoid PDO::PARAM_NULL HY093 binding errors
        $heroImgId = (isset($_POST['hero_image_id']) && $_POST['hero_image_id'] !== '' && (int)$_POST['hero_image_id'] > 0)
            ? (int)$_POST['hero_image_id']
            : 0;
        $updateData['img'] = $heroImgId;
        $updateData['content_short'] = isset($_POST['content_short']) ? $_POST['content_short'] : '';
    } else {
        $updateData['url'] = $_POST['url'];
        $updateData['show_in_menu'] = $_POST['show_in_main_menu'];
    }

    DatabaseManager::updateSql(
        "pages",
        $updateData,
        "id={$id}"
    );

    $_SESSION['msg_success'] = "Edycja wykonana pomyślnie";
    header("Location: /admin/podstrony/edytuj/" . $id);
    exit;
}


$languages = DatabaseManager::selectSql("SELECT * FROM pages_langs");
$categories = DatabaseManager::selectSql('SELECT * FROM pages_categories ORDER BY id DESC');
$page = DatabaseManager::selectSql("SELECT * FROM pages WHERE id = $id");

$galleryImages = [];
if ($id === 0) {
    $galleryImages = DatabaseManager::selectSql("SELECT id, name, title FROM images WHERE id_gallery = 60 ORDER BY queue ASC, id ASC");
}

$smarty->assign('languages', $languages);
$smarty->assign('categories', $categories);
$smarty->assign("page", $page ? $page[0] : array());
$smarty->assign('gallery_images', $galleryImages);
$smarty->assign('is_homepage', $id === 0);
$smarty->display('podstrony-edytuj.tpl');
