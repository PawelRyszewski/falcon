<?php
$smarty = new Smarty();
$smarty->display('redirect.tpl');
header('Location: https://www.folpol.pl/');
exit;