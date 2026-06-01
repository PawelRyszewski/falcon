<?php
$smarty = new Smarty();

if(isset($_POST['add_category'])){
    $name = $_POST['name'];
    if(strlen($name) == 0) {
        $_SESSION['msg_error'] = "Nazwa kategorii nie może być pusta";
    } else {
        DatabaseManager::insertSql("news_categories", array('name' => $name));
        $_SESSION['msg_success'] = "Kategoria dodana pomyślnie";
    }
    header("Location: /admin/aktualnosci/kategorie");
}

$categories = DatabaseManager::selectSql('SELECT * FROM news_categories ORDER BY id DESC');

$smarty->assign('categories', $categories);
$smarty->display('aktualnosci-kategorie.tpl');