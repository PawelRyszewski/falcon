<?php
$smarty = new Smarty();
$id_gallery = $_GET['par3'];

$uploadsDir = './../uploads';
$thumbDir = './../uploads/thumb';
if ($id_gallery == 111) {
    $uploadsDir = './../ai-materials/uploads';
    $thumbDir = './../ai-materials/uploads/thumb';
}

if (isset($_POST['confirm_delete'])) {
    $images = DatabaseManager::selectSql("SELECT name FROM images WHERE id_gallery = $id_gallery");
    foreach ($images as $image) {
        $file_directory = $uploadsDir.'/'.$image['name'];
        $file_directory_thumb = $thumbDir.'/'.$image['name'];

        unlink($file_directory);
        unlink($file_directory_thumb);
    }

    DatabaseManager::deleteSql('pages', "id = $id_gallery AND type = 'gallery'");

    $_SESSION['msg_success'] = "Galeria usunięta pomyślnie";

    header("Location: /admin/galeria-zdjec");
}


$gallery = DatabaseManager::selectSql("SELECT title FROM pages WHERE id = $id_gallery AND type = 'gallery'");

$smarty->assign("title", $gallery[0]['title']);
$smarty->display('galeria-usun.tpl');
