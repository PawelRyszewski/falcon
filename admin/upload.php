<?php
if (!ini_set('upload_max_filesize', '100M')) {
    die('Failed to set upload_max_filesize.');
}

$target_dir = "./../ai-materials/uploads/";
$target_file = $target_dir . basename($_FILES["upload_image"]["name"]);

// Check if file already exists
if (file_exists($target_file)) {
    echo "Sorry, file already exists.";
    exit;
}

// Allow certain file formats
$imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif"  && $imageFileType != "webp" ) {
    echo "Sorry, only JPG, JPEG, PNG, WEBP & GIF files are allowed.";
    exit;
}

if (move_uploaded_file($_FILES["upload_image"]["tmp_name"], $target_file)) {
    header("Content-Type:application/json");
    echo json_encode(
        array(
            "status" => 1,
            "message" => "The file " . $target_file . " has been uploaded."
        )
    );
} else {
    header("Content-Type:application/json");
    echo json_encode(
        array(
            "status" => 0,
            "message" => "Sorry, there was an error uploading your file."
        )
    );
}
?>
