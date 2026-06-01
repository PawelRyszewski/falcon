<?php
$smarty = new Smarty();
$templates = DatabaseManager::selectSql('SELECT * FROM newsletter_templates ORDER BY id DESC');
$smarty->assign('templates', $templates);
$smarty->display('newsletter-templates.tpl');
?>