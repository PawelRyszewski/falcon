<?php
// Tutaj przykład jak robic cononicale
// 1. Sprawdzamy najpierw czy jest strona w bazie po id oraz/lub url
// 2. Jeżeli nie ma strony to sprawdzamy czy jest strona z id
// 3. Czyli jeżeli strona to /oferta/91 sprawdzamy czy jest strona z id = 91 AND url = 'oferta'
// 4. Jeżeli nie ma to sprawdzamy czy jest jakiś page z id 91
// 5. Jeżeli jest strona z id 91 budujemy URL i robimy przkierowanie  header("Location: /".$pageById[0]['url']."/$id");
// 6. Tutaj przykład
$id = $_GET['par2'];
$url = $_GET['par1'];

if (isset($_GET['par2'])) {
    $page = DatabaseManager::selectSql("SELECT title, content FROM pages WHERE id = $id AND url = '$url'");
} else {
    $page = DatabaseManager::selectSql("SELECT title, content FROM pages WHERE url = '$url' ");
}

if ($page) {
    $smarty->assign('page', $page[0]);
    $smarty->display('subpages.tpl');
} else {
    if ($id) {
        $pageById = DatabaseManager::selectSql("SELECT url FROM pages WHERE  id = $id ");
        if ($pageById && $id && $url) {
            header("Location: /".$pageById[0]['url']."/$id");
        }
    }

    $smarty->display('404.tpl');
}
