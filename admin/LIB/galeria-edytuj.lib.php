<?php
$smarty = new Smarty();
require_once('./utils/php/functions.php');
$id_gallery = $_GET['par3'];

$uploadsDir = './../uploads';
$thumbDir = './../uploads/thumb';
if ($id_gallery == 111) {
    $uploadsDir = './../ai-materials/uploads';
    $thumbDir = './../ai-materials/uploads/thumb';
}

if (isset($_POST['delete_selected_images'])) {
    $idImagesToDelete = $_POST['images_to_delete'];

    $imagesToDelete = DatabaseManager::selectSql("SELECT id, name FROM images WHERE id_gallery = $id_gallery AND id IN ($idImagesToDelete)");

	foreach ($imagesToDelete as $img) {
			$file1 = "$uploadsDir/" . $img['name'];
			$file2 = "$thumbDir/" . $img['name'];

		if (file_exists($file1)) {
			if (!unlink($file1)) {
				echo "Błąd: Nie można usunąć pliku $file1";
			}
		} else {
			echo "Błąd: Plik $file1 nie istnieje";
		}

		if (file_exists($file2)) {
			if (!unlink($file2)) {
				echo "Błąd: Nie można usunąć pliku $file2";
			}
		} else {
			echo "Błąd: Plik $file2 nie istnieje";
		}

		$imgId = $img['id'];
		
		if (isset($id_img) && !empty($id_img)) {
			DatabaseManager::updateSql("images", array('name' => replace_extension($img_name, "webp")), "id={$id_img}");
		} else {
			// Handle error: $id_img is not set or is empty
		}
		
		DatabaseManager::deleteSql('images', "id = $imgId");
		$_SESSION['msg_success'] = "Zdjęcia usunięto pomyślnie";

		header("Location: /admin/galeria-zdjec/edytuj/{$id_gallery}");
	}
}

if (isset($_POST['edit_gallery'])) {
    $url = $_POST['url'];
    $title = $_POST['title'];
    $title_seo = $_POST['title_seo'];
    $description = $_POST['description'];
    $keywords = $_POST['keywords'];
    $content = $_POST['content'];
    $event_date = $_POST['event_date'];	


    DatabaseManager::updateSql("pages", array(
        'title' => $title,
        'title_seo' => $title_seo,
        'url' => $url,
        'description' => $description,
        'keywords' => $keywords,
        'event_date' => $event_date,		
        'content' => $content,
    ), "id={$id_gallery} AND type = 'gallery'");

    $_SESSION['msg_success'] = "Edycja galerii wykonana pomyślnie";
    header("Location: /admin/galeria-zdjec/edytuj/{$id_gallery}");
}

if (isset($_POST['add_images'])) {
    //check folder to upload exists
    $urlToUploadsFolder = $uploadsDir;
    if (!file_exists($urlToUploadsFolder)) {
        mkdir($urlToUploadsFolder, 0777, true);
        mkdir($thumbDir, 0777, true);
    }
    
    require_once('./utils/php/functions.php');

    $total = count($_FILES['upload']['name']);
	$img_name = pathinfo($img_name, PATHINFO_FILENAME) . '.webp';
	
    // Loop through each file
    for ($i = 0; $i < $total; $i++) {
        sleep(0.3);
        //Get the temp file path
        $tmpFilePath = $_FILES['upload']['tmp_name'][$i];
		
		
        $title = $_POST['img_title_' . $i] ?? 'Image_' . date("YmdHis") . '_' . rand(1000, 9999);
		
		if (!empty($_POST['img_title_' . $i])) {
			if ($id_gallery == 40) {
				$existingImage = DatabaseManager::selectSql("SELECT id FROM images WHERE title = '$title' AND id_gallery = 40");
			} else if ($id_gallery == 41) {
				$existingImage = DatabaseManager::selectSql("SELECT id FROM images WHERE title = '$title' AND id_gallery = 41");
			} else {
				$existingImage = DatabaseManager::selectSql("SELECT id FROM images WHERE title = '$title' AND id_gallery NOT IN (40, 41)");
			}

			if (!empty($existingImage)) {
				$_SESSION['msg_error'] = "Obrazek o tytule '$title' już istnieje. Wybierz inny tytuł.";
				header("Location: /admin/galeria-zdjec/edytuj/{$id_gallery}");
				exit;
			}
		}		

        //Make sure we have a file path
        if ($tmpFilePath != "") {
            //Setup our new file path
			$original_img_name = $_FILES['upload']['name'][$i];
			$img_name = pathinfo($original_img_name, PATHINFO_FILENAME) . '.webp';
			
			if (isset($_POST['img_name_' . $i])) {
				if (strlen($_POST['img_name_' . $i]) > 2) {
					$ext = $_POST['img_ext_' . $i];
					$img_name = $_POST['img_name_' . $i] . ".webp";
				}
			}

            if (file_exists("$uploadsDir/" . $img_name)) {
            }
			
			$newFilePath = "$uploadsDir/" . get_unique_filename($uploadsDir, $img_name);
			$newThumbPath = "$thumbDir/" . get_unique_filename($thumbDir, $img_name);

            //Upload the file into the temp dir
            if (move_uploaded_file($tmpFilePath, $newFilePath)) {
				
				/*if ($id_gallery == 40) {} else {}*/
				resizeImageNoWatermark($newFilePath, $newFilePath, 1500, 1200);
				$newThumbPath = "$thumbDir/" . get_unique_filename($thumbDir, $img_name);
				resizeAndCropImageNoWatermark($newFilePath, $newThumbPath, 400, 400);
				
				$title = $_POST['img_title_' . $i];
                $id_img = DatabaseManager::insertSql("images", array('name' => replace_extension(basename($newFilePath), "webp"), 'title' => $title, 'id_gallery' => $id_gallery));
                $main_img = DatabaseManager::selectSql("SELECT img FROM pages WHERE id = $id_gallery AND type = 'gallery'");

                if (is_null($main_img[0]['img'])) {
                    DatabaseManager::updateSql("pages", array('img' => $id_img), "id={$id_gallery} AND type = 'gallery'");
                }
				
				
                $_SESSION['msg_success'] = "Zdjęcia dodane pomyślnie";
            }
        }
    }
    header("Location: /admin/galeria-zdjec/edytuj/{$id_gallery}");
}

if (isset($_POST['edit_title'])) {
    $id_img = $_POST['img_id'];
    $title = $_POST['img_title'];

    // Get the current file name from the database
    $currentImage = DatabaseManager::selectSql("SELECT name FROM images WHERE id={$id_img}");

    if (!empty($currentImage)) {
        $currentFileName = $currentImage[0]['name'];

        // Generate the new file name
        $newFileName = generateFileName($title);

        // Rename the file on disk
        rename("$uploadsDir/" . $currentFileName, "$uploadsDir/" . $newFileName);
        rename("$thumbDir/" . $currentFileName, "$thumbDir/" . $newFileName);

        // Update the file name in the database
        DatabaseManager::updateSql("images", array('name' => $newFileName, 'title' => $title), "id={$id_img}");

        $_SESSION['msg_success'] = "Edycja tytułu zdjęcia wykonana pomyślnie";
    } else {
        // Handle error: image not found in the database
    }

    header("Location: /admin/galeria-zdjec/edytuj/{$id_gallery}");
}

if (isset($_POST['del_img'])) {
    $img_name = $_POST['img_name'];
    $id_img = $_POST['img_id'];

    unlink("$uploadsDir/" . replace_extension($img_name, "webp"));
    unlink("$thumbDir/" . replace_extension($img_name, "webp"));

	DatabaseManager::updateSql("images", array('name' => replace_extension($img_name, "webp")), "id={$id_img}");
    DatabaseManager::deleteSql('images', "id=$id_img");
    $_SESSION['msg_success'] = "Zdjęcie usunięto pomyślnie";

    header("Location: /admin/galeria-zdjec/edytuj/{$id_gallery}");
}

if (isset($_POST['set_main'])) {
    $id_img = $_POST['img_id'];

    DatabaseManager::updateSql("pages", array('img' => $id_img), "id={$id_gallery} AND type = 'gallery'");

    $_SESSION['msg_success'] = "Zdjęcie główne ustawiono pomyślnie";
    header("Location: /admin/galeria-zdjec/edytuj/{$id_gallery}");
}

$gallery = DatabaseManager::selectSql("SELECT * FROM pages WHERE id = $id_gallery AND type = 'gallery'");
$images = DatabaseManager::selectSql("SELECT * FROM images WHERE id_gallery = $id_gallery ORDER BY queue ASC");

$smarty->assign("gallery", $gallery[0]);
$smarty->assign("images", $images);
$smarty->display('galeria-edytuj.tpl');
