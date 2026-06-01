<?php
$smarty = new Smarty();

$users = DatabaseManager::selectSql('SELECT * FROM users ORDER BY id DESC');

$smarty->assign('users', $users);
$smarty->display('uzytkownicy.tpl');
