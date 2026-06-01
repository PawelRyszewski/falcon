<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");
require_once('./../../utils/php/functions.php');

$tmpFilePath = $_FILES['img']['tmp_name'];

if ($tmpFilePath != "") {
    //check folder to upload exists
    $urlToUploadsFolder = "./../../../ai-materials/uploads/";
    if (!file_exists($urlToUploadsFolder)) {
        mkdir($urlToUploadsFolder, 0777, true);
        mkdir($urlToUploadsFolder . "/thumb", 0777, true);
    }
    $img_name = $_FILES['img']['name'];
    $img_title = $_POST['img_title'];

    if (isset($_POST['img_name'])) { // to zrobic
        if (strlen($_POST['img_name']) > 2) {
            $ext = explode(".", $img_name);
            $splitedImgName = count($ext);
            $ext = $ext[$splitedImgName - 1];
            $img_name = $_POST['img_name'] . "." . $ext;
        }
    }

    $img_name = checkIsImgExists("./../../../ai-materials/uploads/", $img_name);
    $newFilePath = "./../../../ai-materials/uploads/" . $img_name;
	
    if (move_uploaded_file($tmpFilePath, $newFilePath)) {
        resizeImage($newFilePath, $newFilePath, 1500, 1200);
        resizeImage($newFilePath, "./../../../ai-materials/uploads/thumb/" . $img_name, 400, 400);
    }
    $img = array('img_name' => $img_name, 'img_title' => $img_title);
    echo json_encode($img);
}
