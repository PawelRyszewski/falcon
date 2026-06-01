<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");
require_once('./functions.php');

$category = isset($_GET['category']) ? (int)$_GET['category'] : 0;

$sql = "SELECT p.*, c.name AS category_name, u.login FROM pages p " .
       "LEFT JOIN news_categories c ON p.category = c.id " .
       "LEFT JOIN users u ON p.who_fill = u.id " .
       "WHERE p.type = 'news'";
if ($category > 0) {
    $sql .= " AND p.category = {$category}";
}
$sql .= " ORDER BY p.queue ASC, p.created_at DESC";

$news = DatabaseManager::selectSql($sql);
if (!$news) {
    $news = [];
}

ob_start();
foreach ($news as $index => $item) {
    $id = (int)$item['id'];
    $title = htmlspecialchars($item['title']);
    $img = htmlspecialchars($item['img']);
    $imgTag = $img ? "<img src=\"./../uploads/thumb/{$img}\" style=\"max-height: 60px; max-width: 60px;\" />" : "Brak";
    if ($img) {
        $imgThumbPath = resolveNewsImagePath($img, true);
        $imgTag = "<img src=\"{$imgThumbPath}\" style=\"max-height: 60px; max-width: 60px;\" />";
    } else {
        $imgTag = "Brak";
    }	
    $user = isset($item['login']) ? htmlspecialchars($item['login']) : 'Brak użytkownika';
    $categoryName = htmlspecialchars($item['category_name']);
    $visit = (int)$item['visit'];
    $isPublished = (int)$item['is_published'];
    $isHide = (int)$item['is_hide'];
    echo "<tr class=\"d-flex\">";
    echo "<td class=\"col-1 text-center\">" . ($index + 1) . ".</td>";
    echo "<td class=\"col-1 text-center\">{$imgTag}</td>";
    echo "<td class=\"col-2\"><a href=\"/admin/aktualnosci/edytuj/{$id}\" target=\"blank\">{$title}</a></td>";
    echo "<td class=\"col-1 text-center\">{$user}</td>";
    echo "<td class=\"col-2 text-center\">{$categoryName}</td>";
    echo "<td class=\"col-1 text-center\">{$visit}</td>";
    echo "<td class=\"col-1 text-center\">";
    echo "<form method=\"POST\">";
    echo "<button type=\"submit\" name=\"toggle_publish\" class=\"blue hover-opacity\" style=\"background: unset; border: none;\">";
    if ($isPublished === 0) {
        echo '<svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-eye-slash-fill" fill="#3f9cff" xmlns="http://www.w3.org/2000/svg">';
        echo '<path d="M10.79 12.912l-1.614-1.615a3.5 3.5 0 0 1-4.474-4.474l-2.06-2.06C.938 6.278 0 8 0 8s3 5.5 8 5.5a7.029 7.029 0 0 0 2.79-.588zM5.21 3.088A7.028 7.028 0 0 1 8 2.5c5 0 8 5.5 8 5.5s-.939 1.721-2.641 3.238l-2.062-2.062a3.5 3.5 0 0 0-4.474-4.474L5.21 3.089z" />';
        echo '<path d="M5.525 7.646a2.5 2.5 0 0 0 2.829 2.829l-2.83-2.829zm4.95.708l-2.829-2.83a2.5 2.5 0 0 1 2.829 2.829z" />';
        echo '<path fill-rule="evenodd" d="M13.646 14.354l-12-12 .708-.708 12 12-.708.708z" />';
        echo '</svg>';
    } else {
        echo '<svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-eye-fill" fill="#3f9cff" xmlns="http://www.w3.org/2000/svg">';
        echo '<path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z" />';
        echo '<path fill-rule="evenodd" d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z" />';
        echo '</svg>';
    }
    echo '</button>';
    echo '<input type="hidden" name="is_published" value="' . ($isPublished === 1 ? 0 : 1) . '" />';
    echo '<input type="hidden" name="id_page" value="' . $id . '" />';
    echo '</form>';
    echo '</td>';
    echo '<td class="col-1 text-center "><a href="/admin/aktualnosci/edytuj/' . $id . '" class="orange hover-opacity"><span class="icon-content-edit"></span></a></td>';
    echo '<td class="col-1 text-center"><a href="/admin/aktualnosci/usun/' . $id . '" class="red hover-opacity"><span class="icon-content-delete"></span></a></td>';
    echo '</tr>';
}
$html = ob_get_clean();
header('Content-Type: text/html; charset=utf-8');
echo $html;
