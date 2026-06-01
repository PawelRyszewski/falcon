<?php
$smarty = new Smarty();
$realestateSchemaPath = __DIR__ . '/realestate_schema.lib.php';
if (file_exists($realestateSchemaPath)) {
    require_once $realestateSchemaPath;
}
$id_realestate = (int) $_GET['par3'];

// Ensure floor columns exist
if (function_exists('realestate_ensure_floor_columns')) {
    realestate_ensure_floor_columns();
}
// Ensure images.hide_from_slider column exists
if (function_exists('realestate_ensure_images_hide_from_slider')) {
    realestate_ensure_images_hide_from_slider();
}
// Drop FK constraint on investment_files so pages.id can be used as investment_id
if (function_exists('realestate_drop_investment_files_fk')) {
    realestate_drop_investment_files_fk();
}

// Use pages.id as investment_id (FK dropped above, investments table may be empty)
$id_investment = $id_realestate;

if (!function_exists('realestate_db_name')) {
    function realestate_db_name()
    {
        return (string) getenv('DB_NAME');
    }
}

if (!function_exists('realestate_table_exists')) {
    function realestate_table_exists($tableName)
    {
        $dbName = realestate_db_name();
        if ($dbName === '') {
            return false;
        }

        $dbNameSafe = addslashes($dbName);
        $tableSafe = addslashes($tableName);
        $result = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = '{$tableSafe}' LIMIT 1");

        return !empty($result[0]['qty']);
    }
}

if (!function_exists('realestate_column_exists')) {
    function realestate_column_exists($tableName, $columnName)
    {
        $dbName = realestate_db_name();
        if ($dbName === '') {
            return false;
        }

        $dbNameSafe = addslashes($dbName);
        $tableSafe = addslashes($tableName);
        $columnSafe = addslashes($columnName);
        $result = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = '{$tableSafe}' AND COLUMN_NAME = '{$columnSafe}' LIMIT 1");

        return !empty($result[0]['qty']);
    }
}

if (!function_exists('admin_realestate_status_labels')) {
    function admin_realestate_status_labels()
    {
        return [
            0 => 'W realizacji',
            1 => 'Zrealizowane',
        ];
    }
}

$imagesForeignKey = null;
if (realestate_column_exists('images', 'id_realestate')) {
    $imagesForeignKey = 'id_realestate';
} elseif (realestate_column_exists('images', 'id_page')) {
    $imagesForeignKey = 'id_page';
} elseif (realestate_column_exists('images', 'id_gallery')) {
    $imagesForeignKey = 'id_gallery';
}

if (isset($_POST['delete_selected_images'])) {
    if (!$imagesForeignKey) {
        $_SESSION['msg_error'] = 'Nie udało się usunąć zdjęć: brak kolumny powiązania nieruchomości w tabeli images (id_realestate/id_page/id_gallery).';
        header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
        exit;
    }

    $idImagesToDelete = $_POST['images_to_delete'];

    $imagesToDelete = DatabaseManager::selectSql("SELECT id, name FROM images WHERE {$imagesForeignKey} = $id_realestate AND id IN ($idImagesToDelete)");

    foreach ($imagesToDelete as $img) {
        unlink("./../uploads/" . $img['name']);
        unlink("./../uploads/thumb/" . $img['name']);

        $imgId = $img['id'];
        DatabaseManager::deleteSql('images', "id = $imgId");
        $_SESSION['msg_success'] = "Zdjęcia usunięto pomyślnie";

        header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
    }
}

if (isset($_POST['edit_realestate'])) {
    $url = $_POST['url'];
    $title = $_POST['title'];
    $title_seo = $_POST['title_seo'] ?? '';
    $description = $_POST['description'];
    $realestate_status = isset($_POST['realestate_status']) ? (int) $_POST['realestate_status'] : 0;
    $category = (int)($_POST['category'] ?? 0);
    $keywords = $_POST['keywords'];
    $content = $_POST['content'];


    $validStatuses = ['wolne', 'rezerwacja', 'niedostepne'];
    $house_status = in_array($_POST['house_status'] ?? '', $validStatuses) ? $_POST['house_status'] : 'wolne';
    $plot_area = trim($_POST['plot_area'] ?? '');
    $usable_area = trim($_POST['usable_area'] ?? '');
    $house_price = trim($_POST['house_price'] ?? '');

    $updateData = array(
        'title' => $title,
        'title_seo' => $title_seo,
        'url' => $url,
        'description' => $description,
        'keywords' => $keywords,
        'content' => $content,
    );

    if (realestate_column_exists('pages', 'realestate_status')) {
        $updateData['realestate_status'] = $realestate_status;
    }
    if (realestate_column_exists('pages', 'category')) {
        $updateData['category'] = $category;
    }
    if (realestate_column_exists('pages', 'house_status')) {
        $updateData['house_status'] = $house_status;
    }
    if (realestate_column_exists('pages', 'plot_area')) {
        $updateData['plot_area'] = $plot_area;
    }
    if (realestate_column_exists('pages', 'usable_area')) {
        $updateData['usable_area'] = $usable_area;
    }
    if (realestate_column_exists('pages', 'house_price')) {
        $updateData['house_price'] = $house_price;
    }

    // #5: Floor sections (Parter / Piętro)
    if (realestate_column_exists('pages', 'has_parter')) {
        $updateData['has_parter']     = isset($_POST['has_parter']) ? 1 : 0;
        $rawParterImgId               = (int) ($_POST['parter_img_id'] ?? 0);
        $updateData['parter_img_id']  = $rawParterImgId > 0 ? $rawParterImgId : "NULL";
        $updateData['parter_content'] = $_POST['parter_content'] ?? '';
    }
    if (realestate_column_exists('pages', 'has_pietro')) {
        $updateData['has_pietro']     = isset($_POST['has_pietro']) ? 1 : 0;
        $rawPietroImgId               = (int) ($_POST['pietro_img_id'] ?? 0);
        $updateData['pietro_img_id']  = $rawPietroImgId > 0 ? $rawPietroImgId : "NULL";
        $updateData['pietro_content'] = $_POST['pietro_content'] ?? '';
    }
    if (realestate_column_exists('pages', 'has_poddasze')) {
        $updateData['has_poddasze']     = isset($_POST['has_poddasze']) ? 1 : 0;
        $rawPoddaszaImgId               = (int) ($_POST['poddasze_img_id'] ?? 0);
        $updateData['poddasze_img_id']  = $rawPoddaszaImgId > 0 ? $rawPoddaszaImgId : "NULL";
        $updateData['poddasze_content'] = $_POST['poddasze_content'] ?? '';
    }

    DatabaseManager::updateSql("pages", $updateData, "id={$id_realestate} AND type = 'realestate'");

    $_SESSION['msg_success'] = "Edycja nieruchomości wykonana pomyślnie";
    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
}

if (isset($_POST['add_images'])) {
    if (!$imagesForeignKey) {
        $_SESSION['msg_error'] = 'Nie udało się dodać zdjęć: brak kolumny powiązania nieruchomości w tabeli images (id_realestate/id_page/id_gallery).';
        header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
        exit;
    }

    //check folder to upload exists
    $urlToUploadsFolder = "./../uploads";
    if (!file_exists($urlToUploadsFolder)) {
        mkdir($urlToUploadsFolder, 0777, true);
        mkdir($urlToUploadsFolder . "/thumb", 0777, true);
    }

    require_once('./utils/php/functions.php');

    $total = count($_FILES['upload']['name']);
    // Loop through each file
    for ($i = 0; $i < $total; $i++) {
        sleep(0.3);
        //Get the temp file path
        $tmpFilePath = $_FILES['upload']['tmp_name'][$i];

        //Make sure we have a file path
        if ($tmpFilePath != "") {
            //Setup our new file path
            $original_img_name = $_FILES['upload']['name'][$i];
            $img_name = pathinfo($original_img_name, PATHINFO_FILENAME) . '.webp';

            if (isset($_POST['img_name_' . $i])) {
                if (strlen($_POST['img_name_' . $i]) > 2) {
                    $img_name = $_POST['img_name_' . $i] . ".webp";
                }
            }

            if (file_exists("./../uploads/" . $img_name)) {
            }
            $img_name = checkIsImgExists("./../uploads/", $img_name);

            $newFilePath = "./../uploads/" . $img_name;

            //Upload the file into the temp dir
            if (move_uploaded_file($tmpFilePath, $newFilePath)) {
                resizeImageNoWatermark($newFilePath, $newFilePath, 1500, 1200);
                resizeAndCropImageNoWatermark($newFilePath, "./../uploads/thumb/" . $img_name, 400, 400);
                $title = $_POST['img_title_' . $i];
                $id_img =  DatabaseManager::insertSql("images", array('name' => $img_name, 'title' => $title, $imagesForeignKey => $id_realestate));

                $main_img = DatabaseManager::selectSql("SELECT img FROM pages WHERE id = $id_realestate AND type = 'realestate'");

                if (is_null($main_img[0]['img'])) {
                    DatabaseManager::updateSql("pages", array('img' => $id_img), "id={$id_realestate} AND type = 'realestate'");
                }
                $_SESSION['msg_success'] = "Zdjęcia dodane pomyślnie";
            }
        }
    }
    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
}

if (isset($_POST['edit_title'])) {
    $id_img = $_POST['img_id'];
    $title = $_POST['img_title'];

    DatabaseManager::updateSql("images", array('title' => $title), "id={$id_img}");
    $_SESSION['msg_success'] = "Edycja tytułu zdjęcia wykonana pomyślnie";

    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
}

if (isset($_POST['del_img'])) {
    $img_name = $_POST['img_name'];
    $id_img = $_POST['img_id'];

    unlink("./../uploads/" . $img_name);
    unlink("./../uploads/thumb/" . $img_name);

    DatabaseManager::deleteSql('images', "id=$id_img");
    $_SESSION['msg_success'] = "Zdjęcie usunięto pomyślnie";

    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
}

if (isset($_POST['set_main'])) {
    $id_img = $_POST['img_id'];

    DatabaseManager::updateSql("pages", array('img' => $id_img), "id={$id_realestate} AND type = 'realestate'");

    $_SESSION['msg_success'] = "Zdjęcie główne ustawiono pomyślnie";
    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
}

// #7: Investment file upload
if (isset($_POST['add_investment_file'])) {
    require_once('./utils/php/functions.php');

    $fileTitle    = trim($_POST['file_title'] ?? '');
    $uploadedFile = $_FILES['investment_file'] ?? null;

    if ($uploadedFile && $uploadedFile['error'] === UPLOAD_ERR_OK) {
        $origName    = $uploadedFile['name'];
        $tmpPath     = $uploadedFile['tmp_name'];
        $ext         = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
        $allowedExts = ['pdf', 'jpg', 'jpeg', 'png', 'webp'];

        if (in_array($ext, $allowedExts)) {
            $baseName  = $fileTitle !== '' ? $fileTitle : pathinfo($origName, PATHINFO_FILENAME);
            $baseName  = preg_replace('/[^a-zA-Z0-9_-]/', '-', strtolower($baseName));
            $baseName .= '-' . time();

            if ($ext === 'pdf') {
                $fileName = $baseName . '.pdf';
                $fileName = checkIsImgExists('./../uploads/', $fileName);
                $destPath = './../uploads/' . $fileName;
                move_uploaded_file($tmpPath, $destPath);
                $fileType = 'pdf';
                $filePath = '/uploads/' . $fileName;
            } else {
                $fileName = $baseName . '.webp';
                $fileName = checkIsImgExists('./../uploads/', $fileName);
                $destPath = './../uploads/' . $fileName;
                move_uploaded_file($tmpPath, $destPath);
                resizeImageNoWatermark($destPath, $destPath, 1500, 1200);
                resizeAndCropImageNoWatermark($destPath, './../uploads/thumb/' . $fileName, 400, 400);
                $fileType = 'image';
                $filePath = '/uploads/' . $fileName;
            }

            DatabaseManager::insertSql('investment_files', [
                'investment_id' => $id_investment,
                'title'         => $fileTitle,
                'file_path'     => $filePath,
                'file_type'     => $fileType,
                'sort_order'    => 0,
                'is_active'     => 1,
            ]);
            $_SESSION['msg_success'] = 'Plik dodano pomyślnie';
        } else {
            $_SESSION['msg_error'] = 'Niedozwolony format. Dozwolone: PDF, JPG, PNG, WebP.';
        }
    } else {
        $_SESSION['msg_error'] = 'Nie wybrano pliku lub błąd przesyłania.';
    }

    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
    exit;
}

// #7: Investment file delete
if (isset($_POST['delete_investment_file'])) {
    $fileId = (int) ($_POST['file_id'] ?? 0);
    if ($fileId > 0) {
        $fileRow = DatabaseManager::selectSql("SELECT file_path, file_type FROM investment_files WHERE id = {$fileId} AND investment_id = {$id_investment} LIMIT 1");
        if (!empty($fileRow[0])) {
            $relPath = ltrim($fileRow[0]['file_path'], '/');
            if (file_exists('./../' . $relPath)) {
                unlink('./../' . $relPath);
            }
            if ($fileRow[0]['file_type'] === 'image') {
                $thumbPath = './../uploads/thumb/' . basename($relPath);
                if (file_exists($thumbPath)) {
                    unlink($thumbPath);
                }
            }
            DatabaseManager::deleteSql('investment_files', "id = {$fileId}");
            $_SESSION['msg_success'] = 'Plik usunięto pomyślnie';
        }
    }
    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
    exit;
}

// #7: Investment file title update
if (isset($_POST['update_investment_file_title'])) {
    $fileId    = (int) ($_POST['file_id'] ?? 0);
    $fileTitle = trim($_POST['file_title'] ?? '');
    if ($fileId > 0) {
        DatabaseManager::updateSql('investment_files', ['title' => $fileTitle], "id = {$fileId} AND investment_id = {$id_investment}");
        $_SESSION['msg_success'] = 'Tytuł pliku zaktualizowany';
    }
    header("Location: /admin/nieruchomosci/edytuj/{$id_realestate}");
    exit;
}

$realestate = DatabaseManager::selectSql("SELECT * FROM pages WHERE id = $id_realestate AND type = 'realestate'");
$images = [];
if ($imagesForeignKey) {
    $hasHideCol = realestate_column_exists('images', 'hide_from_slider');
    $hideSelect = $hasHideCol ? ', hide_from_slider' : ', 0 AS hide_from_slider';
    $images = DatabaseManager::selectSql("SELECT id, name, title, queue{$hideSelect} FROM images WHERE {$imagesForeignKey} = $id_realestate ORDER BY queue ASC");
} else {
    error_log('[SCHEMA WARNING] Missing images relation column for realestate (expected id_realestate, id_page or id_gallery). Image gallery is disabled in admin edit form.');
}
$categories = [];
if (realestate_table_exists('realestate_categories')) {
    $categories = DatabaseManager::selectSql('SELECT id, name FROM realestate_categories ORDER BY queue ASC, id DESC');
} else {
    error_log('[SCHEMA WARNING] Missing table realestate_categories. Category selector is disabled in admin edit form.');
}

if (!isset($realestate[0]['realestate_status'])) {
    $realestate[0]['realestate_status'] = 0;
}
if (!isset($realestate[0]['category'])) {
    $realestate[0]['category'] = 0;
}
if (!isset($realestate[0]['house_status'])) {
    $realestate[0]['house_status'] = 'wolne';
}
if (!isset($realestate[0]['plot_area'])) {
    $realestate[0]['plot_area'] = '';
}
if (!isset($realestate[0]['usable_area'])) {
    $realestate[0]['usable_area'] = '';
}
if (!isset($realestate[0]['house_price'])) {
    $realestate[0]['house_price'] = '';
}

// #5: Floor section defaults
$realestate[0]['has_parter']     = (int) ($realestate[0]['has_parter'] ?? 0);
$realestate[0]['parter_img_id']  = (int) ($realestate[0]['parter_img_id'] ?? 0);
$realestate[0]['parter_content'] = $realestate[0]['parter_content'] ?? '';
$realestate[0]['has_pietro']       = (int) ($realestate[0]['has_pietro'] ?? 0);
$realestate[0]['pietro_img_id']    = (int) ($realestate[0]['pietro_img_id'] ?? 0);
$realestate[0]['pietro_content']   = $realestate[0]['pietro_content'] ?? '';
$realestate[0]['has_poddasze']     = (int) ($realestate[0]['has_poddasze'] ?? 0);
$realestate[0]['poddasze_img_id']  = (int) ($realestate[0]['poddasze_img_id'] ?? 0);
$realestate[0]['poddasze_content'] = $realestate[0]['poddasze_content'] ?? '';

// #7: Investment files for tab 4
$investment_files_admin = [];
if (realestate_table_exists('investment_files')) {
    $investment_files_admin = DatabaseManager::selectSql("SELECT id, title, file_path, file_type, sort_order FROM investment_files WHERE investment_id = {$id_investment} AND is_active = 1 ORDER BY sort_order ASC, id ASC");
}

$smarty->assign("realestate", $realestate[0]);
$smarty->assign("images", $images);
$smarty->assign("categories", $categories);
$smarty->assign("realestate_status_labels", admin_realestate_status_labels());
$smarty->assign("investment_files_admin", $investment_files_admin ?: []);
$smarty->display('nieruchomosci-edytuj.tpl');
