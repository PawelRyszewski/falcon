<?php
$smarty = new Smarty();
    require_once('./utils/php/functions.php');
$id = $_GET["par3"];

if(isset($_POST['edit_news_save'])) {
    $is_published = 0;
}

if(isset($_POST['edit_news'])) {
    $is_published = 1;
}

if (isset($_POST['edit_news']) || isset($_POST['edit_news_save'])) {

    $title = $_POST['title'];
    $title_seo = $_POST['title_seo'];
    $content = $_POST['content'];
    $content_short = $_POST['content_short'];
    $url = $_POST['url'];
    $description = $_POST['description'];
    $keywords = $_POST['keywords'];
    $show_in_menu = $_POST['show_in_main_menu'];
    $who_fill = 1;
    $img_name = "";
    $img_title = "";
    $category = $_POST['category'];
	$lang = $_POST['lang'];


    //Get the temp file path
    $tmpFilePath = $_FILES['img']['tmp_name'];
    //Make sure we have a file path
    if ($tmpFilePath != "") {
        //check folder to upload exists
        $urlToUploadsFolder = "./../ai-materials/uploads";
        if (!file_exists($urlToUploadsFolder)) {
            mkdir($urlToUploadsFolder, 0777, true);
            mkdir($urlToUploadsFolder . "/thumb", 0777, true);
        }
        //Setup our new file path
        $img_name = $_FILES['img']['name'];

        if (isset($_POST['img_name_0'])) {
            if (strlen($_POST['img_name_0']) > 2) {
                $ext = $_POST['img_ext_0'];
                $img_name = $_POST['img_name_0'] . "." . $ext;
            }
        }

		$img_name_base = pathinfo($img_name, PATHINFO_FILENAME);
		$img_name = $img_name_base . '.webp';	
		$img_name = checkIsImgExists("./../ai-materials/uploads/", $img_name);
        $newFilePath = "./../ai-materials/uploads/" . $img_name;

        //Upload the file into the temp dir
        if (move_uploaded_file($tmpFilePath, $newFilePath)) {
                resizeImageNoWatermark($newFilePath, $newFilePath, 1500, 1200);
                resizeAndCropImageNoWatermark($newFilePath, "./../ai-materials/uploads/thumb/" . $img_name, 400, 400);
            $img_title = $_POST['img_title_0'];

            DatabaseManager::updateSql(
                "pages",
                array("img" => $img_name),
                "id={$id}"
            );
        }
    } elseif (!empty($_POST['img_from_gallery'])) {
        $img_name = $_POST['img_from_gallery'];
        $imgData = DatabaseManager::selectSql("SELECT title FROM images WHERE name='".$img_name."'");
        if (!empty($imgData)) {
            $img_title = $imgData[0]['title'];
        }
        DatabaseManager::updateSql(
            "pages",
            array("img" => $img_name),
            "id={$id}"
        );	
    } else {
        if (isset($_POST['img_title_old'])) {
            $img_title = $_POST['img_title_old'];
        }
    }

    DatabaseManager::updateSql(
        "pages",
        array(
            'title' => $title,
            'title_seo' => $title_seo,
            'content' => $content,
            'url' => $url,
            'description' => $description,
            'keywords' => $keywords,
            'show_in_menu' => $show_in_menu,
            "who_fill" => $who_fill,
            "img_title" => $img_title,
            "content_short" => $content_short,
            "is_published" => $is_published,
            "category" => $category,
			"lang" => $lang,
        ),
        "id={$id}"
    );

    $_SESSION['msg_success'] = "Edycja wykonana pomyślnie";
    header("Location: /admin/aktualnosci/edytuj/" . $id);
}


$page = DatabaseManager::selectSql("SELECT * FROM pages WHERE id = $id");
$categories = DatabaseManager::selectSql("SELECT * FROM news_categories");
$galleryImages = DatabaseManager::selectSql("SELECT i.name, i.title, i.id_gallery, p.title AS gallery_title FROM images i LEFT JOIN pages p ON i.id_gallery = p.id ORDER BY p.title, i.created_at DESC");
$galleryImagesGrouped = [];
foreach ($galleryImages as $img) {
    $img['thumb'] = resolveNewsImagePath($img['name'], true);
    $group = $img['gallery_title'] ?? 'Brak galerii';
    $galleryImagesGrouped[$group][] = $img;
}
if (!empty($page[0]['img'])) {
    $page[0]['img_thumb_path'] = resolveNewsImagePath($page[0]['img'], true);
}
$languages = DatabaseManager::selectSql("SELECT * FROM pages_langs");
$smarty->assign('categories', $categories);
$smarty->assign('languages', $languages);
$smarty->assign('gallery_images', $galleryImagesGrouped);
$smarty->assign("page", $page[0]);
$smarty->assign("id_page", $id);
$smarty->display('aktualnosci-edytuj.tpl');
