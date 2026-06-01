<?php
require_once __DIR__ . '/../../../utils/php/helpers.php';
function replace_extension($filename, $new_extension) {
    $info = pathinfo($filename);
    return $info['filename'] . '.' . $new_extension;
}

function get_unique_filename($path, $filename) {
    $file_parts = pathinfo($filename);
    $count = 1;
    while(file_exists($path . '/' . $file_parts['filename'] . '.' . $file_parts['extension'])) {
        $file_parts['filename'] = $file_parts['filename'] . $count;
        $count++;
    }
    return $file_parts['filename'] . '.' . $file_parts['extension'];
}

function removeDiacritics($string) {
    $unwanted_array = array(
        'ś'=>'s', 'ć'=>'c', 'ź'=>'z',
        'ż'=>'z', 'ł'=>'l', 'ę'=>'e',
        'ó'=>'o', 'ń'=>'n', 'ą'=>'a',
        'Ś'=>'S', 'Ć'=>'C', 'Ź'=>'Z',
        'Ż'=>'Z', 'Ł'=>'L', 'Ę'=>'E',
        'Ó'=>'O', 'Ń'=>'N', 'Ą'=>'A',
    );
    return strtr($string, $unwanted_array);
}

function generateFileName($title) {
	$fileName = removeDiacritics($title);
	$fileName = strtolower($fileName);
	$fileName = str_replace(' ', '-', $fileName);
	$fileName .= '-' . time();
	$fileName .= '.webp';
	return $fileName;
}

function checkIsImgExists($path, $img_name, $try = 1)
{
    $imgPathWithName = $path . pathinfo($img_name, PATHINFO_FILENAME) . '.webp';
    if (file_exists($imgPathWithName)) {
        $arrayImgName = explode(".", $img_name);
        $arrayImgName[count($arrayImgName) - 1] = $try . "." . $arrayImgName[count($arrayImgName) - 1];
        $new_img_name = implode("", $arrayImgName);
        if (file_exists($path . $new_img_name)) {
            $try++;
            return checkIsImgExists($path, $img_name, $try);
        } else {
            return $new_img_name;
        }
    }

    return $img_name;
}



/**
 * Resize image - preserve ratio of width and height.
 * @param string $sourceImage path to source JPEG image
 * @param string $targetImage path to final JPEG image file
 * @param int $maxWidth maximum width of final image (value 0 - width is optional)
 * @param int $maxHeight maximum height of final image (value 0 - height is optional)
 * @param int $quality quality of final image (0-100)
 * @return `
 */


function loadWatermarkImage() {
    $candidatePaths = array(
        getcwd() . '/watermark.png',
        __DIR__ . '/../../watermark.png',
    );

    foreach ($candidatePaths as $watermarkPath) {
        if (is_file($watermarkPath) && is_readable($watermarkPath)) {
            $watermark = @imagecreatefrompng($watermarkPath);
            if ($watermark !== false) {
                return $watermark;
            }
        }
    }

    return false;
}

function resizeImage($sourceImage, $targetImage, $maxWidth, $maxHeight, $quality = 70)
{
    list($origWidth, $origHeight, $type) = getimagesize($sourceImage);

    switch($type) {
        case IMAGETYPE_GIF:
            $image = imagecreatefromgif($sourceImage);
            break;
        case IMAGETYPE_JPEG:
            $image = imagecreatefromjpeg($sourceImage);
            break;
        case IMAGETYPE_PNG:
            $image = imagecreatefrompng($sourceImage);
            break;
        default:
            echo "Invalid image type";
            return false;
    }
    
    if ($image === false) {
        return false; 
    }

    if ($maxWidth == 0) {
        $maxWidth  = $origWidth;
    }

    if ($maxHeight == 0) {
        $maxHeight = $origHeight;
    }

    $widthRatio = $maxWidth / $origWidth;
    $heightRatio = $maxHeight / $origHeight;

    $newWidth  = (int)$origWidth  * min($widthRatio, $heightRatio);
    $newHeight = (int)$origHeight * min($widthRatio, $heightRatio);

    $newImage = imagecreatetruecolor($newWidth, $newHeight);

    $transparent = imagecolorallocatealpha($newImage, 0, 0, 0, 127);
    imagefill($newImage, 0, 0, $transparent);
    imagesavealpha($newImage, true);

    imagecopyresampled($newImage, $image, 0, 0, 0, 0, $newWidth, $newHeight, $origWidth, $origHeight);

    $watermark = loadWatermarkImage();
    if ($watermark !== false) {
        $wmWidth = imagesx($watermark);
        $wmHeight = imagesy($watermark);

        // Add watermark
        $dest_x = ($newWidth - $wmWidth) / 2; // Center watermark horizontally
        $dest_y = $newHeight - $wmHeight - 10; // 10px from bottom edge
        imagecopy($newImage, $watermark, $dest_x, $dest_y, 0, 0, $wmWidth, $wmHeight);
        imagedestroy($watermark);
    }

    imagejpeg($newImage, $targetImage, $quality);

    imagedestroy($image);
    imagedestroy($newImage);

    return true;
}

function resizeImageNoWatermark($sourceImage, $targetImage, $maxWidth, $maxHeight, $quality = 70)
{
    list($origWidth, $origHeight, $type) = getimagesize($sourceImage);

    if ($maxWidth == 0) {
        $maxWidth  = $origWidth;
    }

    if ($maxHeight == 0) {
        $maxHeight = $origHeight;
    }

    $widthRatio = $maxWidth / $origWidth;
    $heightRatio = $maxHeight / $origHeight;

    if ($widthRatio < $heightRatio) {
        $newheight = $maxHeight;
        $newwidth = $origWidth * $height_ratio;
    } else {
        $newwidth = $maxWidth;
        $newheight = $origHeight * $width_ratio;
    }

    $imagick = new Imagick($sourceImage);
    $imagick->resizeImage($newwidth, $newheight, Imagick::FILTER_LANCZOS, 1);

    $imagick->setImageFormat('webp');
    $imagick->setImageCompressionQuality($quality);

    $imagick->writeImage(preg_replace('/\\.[^.\\s]{3,4}$/', '', $targetImage) . '.webp');

    $imagick->clear();
    $imagick->destroy();

    return true;
}

function resizeAndCropImageNoWatermark($sourceImage, $targetImage, $finalWidth, $finalHeight, $quality = 80) 
{
    $imagick = new \Imagick($sourceImage);
    $origWidth = $imagick->getImageWidth();
    $origHeight = $imagick->getImageHeight();

    $newWidth = $finalWidth;
    $newHeight = $finalHeight;

    // For vertical (portrait) images
    if ($origWidth < $origHeight) {
        $newHeight = ($finalWidth / $origWidth) * $origHeight;
    } 
    // For horizontal (landscape) images
    else {
        $newWidth = ($finalHeight / $origHeight) * $origWidth;
    }

    $imagick->resizeImage($newWidth, $newHeight, \Imagick::FILTER_LANCZOS, 1);

    // Crop the image to the desired size
    $x = ($newWidth - $finalWidth) / 2;
    $y = ($newHeight - $finalHeight) / 2;
    $imagick->cropImage($finalWidth, $finalHeight, $x, $y);

    $imagick->setImageFormat('webp');
    $imagick->setImageCompressionQuality($quality);

    $imagick->writeImage(preg_replace('/\\.[^.\\s]{3,4}$/', '', $targetImage) . '.webp');

    $imagick->clear();
    $imagick->destroy();

    return true;
}



function resizeAndCropImage($sourceImage, $targetImage, $finalWidth, $finalHeight, $quality = 80) 
{
    list($origWidth, $origHeight, $type) = getimagesize($sourceImage);

    switch($type) {
        case IMAGETYPE_GIF:
            $image = imagecreatefromgif($sourceImage);
            break;
        case IMAGETYPE_JPEG:
            $image = imagecreatefromjpeg($sourceImage);
            break;
        case IMAGETYPE_PNG:
            $image = imagecreatefrompng($sourceImage);
            break;
        default:
            echo "Invalid image type";
            return false;
    }

    if ($image === false) {
        return false; 
    }

    $newWidth = $finalWidth;
    $newHeight = $finalHeight;

    // For vertical (portrait) images
    if ($origWidth < $origHeight) {
        $newHeight = ($finalWidth / $origWidth) * $origHeight;
    } 
    // For horizontal (landscape) images
    else {
        $newWidth = ($finalHeight / $origHeight) * $origWidth;
    }

    $newImage = imagecreatetruecolor($newWidth, $newHeight);
    imagecopyresampled($newImage, $image, 0, 0, 0, 0, $newWidth, $newHeight, $origWidth, $origHeight);

    // Crop the image to the desired size
    $x = ($newWidth - $finalWidth) / 2;
    $y = ($newHeight - $finalHeight) / 2;
    $finalImage = imagecreatetruecolor($finalWidth, $finalHeight);
    imagecopy($finalImage, $newImage, 0, 0, $x, $y, $finalWidth, $finalHeight);

    // Add watermark for specific gallery

    $watermark = loadWatermarkImage();
    if ($watermark !== false) {
        $wmWidth = imagesx($watermark);
        $wmHeight = imagesy($watermark);

        // Add watermark
        $dest_x = ($finalWidth - $wmWidth) / 2; // Center watermark horizontally
        $dest_y = $finalHeight - $wmHeight - 10; // 10px from bottom edge
        imagecopy($finalImage, $watermark, $dest_x, $dest_y, 0, 0, $wmWidth, $wmHeight);
        imagedestroy($watermark);
    }

    imagejpeg($finalImage, $targetImage, $quality);

    imagedestroy($image);
    imagedestroy($newImage);
    imagedestroy($finalImage);

    return true;
}



