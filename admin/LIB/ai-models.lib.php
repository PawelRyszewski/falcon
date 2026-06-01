<?php
$smarty = new Smarty();

if (isset($_POST['add_model'])) {
	$image = $_POST['img_from_gallery'] ?? $_POST['image'] ?? '';
    $category = (int)($_POST['category_id'] ?? 0);
    DatabaseManager::insertSql('ai_models', [
        'name' => $_POST['name'] ?? '',
        'description' => $_POST['description'] ?? '',
        'image' => $image,
        'organization' => $_POST['organization'] ?? '',
        'license' => $_POST['license'] ?? '',
		'model_link' => $_POST['model_link'] ?? '',
        'category_id' => $category,
        'votes_json' => 0,
        'votes_site' => 0
    ]);
    $_SESSION['msg_success'] = 'Model dodany.';
    header('Location: /admin/ai-models');
    exit;
}

$selectedCategory = isset($_GET['category']) ? (int)$_GET['category'] : 0;
$where = $selectedCategory > 0 ? 'WHERE m.category_id=' . $selectedCategory : '';
$models = DatabaseManager::selectSql("SELECT m.*, c.name AS category_name FROM ai_models m LEFT JOIN llm_categories c ON m.category_id=c.id {$where} ORDER BY m.id DESC");
$categories = DatabaseManager::selectSql('SELECT * FROM llm_categories ORDER BY name ASC');
require_once('../CLASS/VoteManager.class.php');
$catMap = [];
foreach ($categories as $c) {
    $catMap[$c['id']] = $c;
}
$scoresByCategory = [];
foreach ($models as &$m) {
    $catId = $m['category_id'];
    if (!isset($scoresByCategory[$catId]) && isset($catMap[$catId])) {
        $scoresByCategory[$catId] = VoteManager::refreshCategoryFromJson($catMap[$catId]);
    }
    $m['score'] = $scoresByCategory[$catId][$m['id']] ?? 0;
	$plain = html_entity_decode(strip_tags($m['description']), ENT_QUOTES, 'UTF-8');
    $m['char_count'] = mb_strlen($plain, 'UTF-8');
}
unset($m);
$galleryImages = DatabaseManager::selectSql("SELECT i.name, i.title, i.id_gallery, p.title AS gallery_title FROM images i LEFT JOIN pages p ON i.id_gallery = p.id ORDER BY p.title, i.created_at DESC");
require_once('./utils/php/functions.php');
$galleryImagesGrouped = [];
foreach ($galleryImages as $img) {
    $img['thumb'] = resolveNewsImagePath($img['name'], true);
    $group = $img['gallery_title'] ?? 'Brak galerii';
    $galleryImagesGrouped[$group][] = $img;
}
$smarty->assign('models', $models);
$smarty->assign('categories', $categories);
$smarty->assign('selected_category', $selectedCategory);
$smarty->assign('gallery_images', $galleryImagesGrouped);
$smarty->assign('msg_success', $_SESSION['msg_success'] ?? null);
unset($_SESSION['msg_success']);
$smarty->display('ai-models.tpl');