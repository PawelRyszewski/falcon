<?php
require_once('./env.php');
session_start();
ob_start();
require('Smarty/Smarty.class.php');
require_once(__DIR__.'/utils/php/i18n.php');

$ENV = getenv("ENVIRONMENT");
if($ENV === "test" && !isset($_SESSION['code_status'])) {
	return require_once './LIB/test_env.lib.php';
}
// require_once("../config.php");
header('Content-type: text/html; charset=utf-8');

// define('SERVER_ADDRESS', $NewURL);
set_include_path(get_include_path() . PATH_SEPARATOR . "CLASS");
set_include_path(get_include_path() . PATH_SEPARATOR . "CLASS/Managers");
set_include_path(get_include_path() . PATH_SEPARATOR . "LIB");
// Magiczna funkcja automatycznie ładująca klasy wg. zapotrzebowania

function Autoloader($className)
{
	$path = 'CLASS/' . $className . '.class.php';

	if (file_exists($path)) {
		include_once($className . ".class.php");
	} else {
		return false;
	}
}


spl_autoload_register('Autoloader');

$smarty = new Smarty();
$smarty->setTemplateDir('templates');
$smarty->setCompileDir('templates_c');
$smarty->setCacheDir('cache');
$smarty->setConfigDir('configs');
$smarty->registerPlugin('function', 't', 'smarty_t');
$smarty->registerPlugin('function', 'page_url', 'smarty_page_url');
initLang();

if (isset($_GET['par1'])) {
	$par2 = false;
	if (isset($_GET['par2'])) {
		$par2 = $_GET['par2'];
	}
	$par3 = false;
	if (isset($_GET['par3'])) {
		$par3 = $_GET['par3'];
	}
	$mp = new MainPage($_GET['par1'], $par2, $par3);
} else {
	$mp = new MainPage('start', false);
}
