<?php
$smarty = new Smarty();
$id = $_GET['par3'];

if (isset($_POST['save_model'])) {
    $image = $_POST['img_from_gallery'] ?? $_POST['image'] ?? '';
    $category = (int)($_POST['category_id'] ?? 0);
    DatabaseManager::updateSql('ai_models', [
        'name' => $_POST['name'] ?? '',
        'description' => $_POST['description'] ?? '',
        'image' => $image,
        'organization' => $_POST['organization'] ?? '',
        'license' => $_POST['license'] ?? '',
        'model_link' => $_POST['model_link'] ?? '',
        'meta_title' => $_POST['meta_title'] ?? '',
        'meta_description' => $_POST['meta_description'] ?? '',
        'meta_keywords' => $_POST['meta_keywords'] ?? '',
        'category_id' => $category
    ], "id={$id}");
    $_SESSION['msg_success'] = 'Model zaktualizowany.';
    header('Location: /admin/ai-models');
    exit;
}

$model = DatabaseManager::selectSql("SELECT * FROM ai_models WHERE id = $id");
$categories = DatabaseManager::selectSql('SELECT * FROM llm_categories ORDER BY name ASC');
$galleryImages = DatabaseManager::selectSql("SELECT i.name, i.title, i.id_gallery, p.title AS gallery_title FROM images i LEFT JOIN pages p ON i.id_gallery = p.id ORDER BY p.title, i.created_at DESC");
require_once('./utils/php/functions.php');
$galleryImagesGrouped = [];
foreach ($galleryImages as $img) {
    $img['thumb'] = resolveNewsImagePath($img['name'], true);
    $group = $img['gallery_title'] ?? 'Brak galerii';
    $galleryImagesGrouped[$group][] = $img;
}
$smarty->assign('model', $model[0] ?? []);
$smarty->assign('categories', $categories);
$smarty->assign('gallery_images', $galleryImagesGrouped);
$smarty->display('ai-models-edytuj.tpl');