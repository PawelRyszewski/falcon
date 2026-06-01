<?php
$smarty = new Smarty();

if(isset($_POST['add_lang'])){
    $name = $_POST['name'];
    if(strlen($name) == 0) {
        $_SESSION['msg_error'] = "Nazwa języka nie może być pusta";
    } else {
        DatabaseManager::insertSql("pages_langs", array('name' => $name));
        $path = dirname(__DIR__,2) . '/langs/' . $name . '.php';
        if(!file_exists($path)) {
            file_put_contents($path, "<?php\n$LM = [];\nreturn $LM;\n");
        }
        $_SESSION['msg_success'] = "Język dodany pomyślnie";
    }
    header("Location: /admin/jezyki");
}

if(isset($_POST['set_default'])) {
    $id = (int)$_POST['set_default'];
    DatabaseManager::updateSql('pages_langs', array('is_default' => 0), '1');
    DatabaseManager::updateSql('pages_langs', array('is_default' => 1), "id={$id}");
    $_SESSION['msg_success'] = "Zmieniono język domyślny";
    header("Location: /admin/jezyki");
}

$languages = DatabaseManager::selectSql('SELECT * FROM pages_langs ORDER BY id DESC');

$smarty->assign('languages', $languages);
$smarty->display('jezyki.tpl');
