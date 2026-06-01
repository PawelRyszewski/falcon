<?php
$smarty = new Smarty();

if (isset($_POST['toggle_hide'])) {
    $id_gallery = $_POST['id_gallery'];
    $is_hide = $_POST['is_hide'];

    DatabaseManager::updateSql("pages", array('is_hide' => $is_hide), "id={$id_gallery} AND type = 'gallery'");

    $_SESSION['msg_success'] = "Edycja galerii wykonana pomyślnie";
    header("Location: /admin/galeria-zdjec");
}

if (isset($_POST['watermark'])) {
    if ($_FILES['watermark']) {
        unlink("watermark.png");
        $filename = $_FILES['watermark']['tmp_name'];
        imagepng(imagecreatefromstring(file_get_contents($filename)), "watermark.png");
        header('Content-Type: image/png');
        imagepng($filename);
        imagedestroy($filename);
    }
    print_r($_FILES['watermark']);
    $_SESSION['msg_success'] = "Znak wodny dodano pomyślnie";
    header("Location: /admin/galeria-zdjec");
}

if (isset($_POST['del_watermark'])) {
    unlink("watermark.png");
    $_SESSION['msg_success'] = "Znak wodny usunięto pomyślnie";
    header("Location: /admin/galeria-zdjec");
}

$imgCount = DatabaseManager::selectSqlGroupAndCountRows("SELECT id_gallery, count(*) FROM images GROUP BY id_gallery");
$galeries = DatabaseManager::selectSql('SELECT * FROM pages WHERE type = "gallery" ORDER BY queue ASC, created_at DESC');

$smarty->assign('galeries', $galeries);
$smarty->assign('imgCount', $imgCount);
$smarty->assign('isWetmarkAdded', is_file("watermark.png") && file_exists("watermark.png"));

$smarty->display('galeria.tpl');
