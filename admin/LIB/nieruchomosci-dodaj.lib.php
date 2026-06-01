<?php
$smarty = new Smarty();

$realestateSchemaPath = __DIR__ . '/realestate_schema.lib.php';
if (file_exists($realestateSchemaPath)) {
    require_once $realestateSchemaPath;
}

if (isset($_POST['add_realestate'])) {
    $url = $_POST['url'];
    $title = $_POST['title'];
    $title_seo = $_POST['title_seo'] ?? '';
    $content = $_POST['content'];
    $description = $_POST['description'];
    $keywords = $_POST['keywords'];
    $category = (int)($_POST['category'] ?? 0);

    $insertData = array(
        'title' => $title,
        'title_seo' => $title_seo,
        'url' => $url,
        'content' => $content,
        'description' => $description,
        'keywords' => $keywords,
        'category' => $category,
        'type' => "realestate",
        "is_published" => 1,
    );

    if (function_exists('realestate_column_exists')) {
        $validStatuses = ['wolne', 'rezerwacja', 'niedostepne'];
        $houseStatus = in_array($_POST['house_status'] ?? '', $validStatuses) ? $_POST['house_status'] : 'wolne';
        if (realestate_column_exists('pages', 'house_status')) {
            $insertData['house_status'] = $houseStatus;
        }
        if (realestate_column_exists('pages', 'plot_area')) {
            $insertData['plot_area'] = trim($_POST['plot_area'] ?? '');
        }
        if (realestate_column_exists('pages', 'usable_area')) {
            $insertData['usable_area'] = trim($_POST['usable_area'] ?? '');
        }
        if (realestate_column_exists('pages', 'house_price')) {
            $insertData['house_price'] = trim($_POST['house_price'] ?? '');
        }

        // #5: Floor sections (Parter / Piętro)
        if (function_exists('realestate_ensure_floor_columns')) {
            realestate_ensure_floor_columns();
        }
        if (realestate_column_exists('pages', 'has_parter')) {
            $insertData['has_parter']     = isset($_POST['has_parter']) ? 1 : 0;
            $insertData['parter_content'] = $_POST['parter_content'] ?? '';
            // parter_img_id omitted — no gallery images at add time
        }
        if (realestate_column_exists('pages', 'has_pietro')) {
            $insertData['has_pietro']     = isset($_POST['has_pietro']) ? 1 : 0;
            $insertData['pietro_content'] = $_POST['pietro_content'] ?? '';
        }
        if (realestate_column_exists('pages', 'has_poddasze')) {
            $insertData['has_poddasze']     = isset($_POST['has_poddasze']) ? 1 : 0;
            $insertData['poddasze_content'] = $_POST['poddasze_content'] ?? '';
        }
    }

    DatabaseManager::insertSql("pages", $insertData);

    $_SESSION['msg_success'] = "Nieruchomość dodana pomyślnie";
    header("Location: /admin/nieruchomosci");
}

$categories = DatabaseManager::selectSql('SELECT id, name FROM realestate_categories ORDER BY queue ASC, id DESC');
$smarty->assign('categories', $categories);

$smarty->display('nieruchomosci-dodaj.tpl');
