<?php
require_once('./env.php');
ini_set('session.gc_maxlifetime', 3600 * 4);
session_set_cookie_params(3600 * 4);
session_start();
ob_start();
require_once("./setup.php");
require_once(__DIR__.'/utils/php/i18n.php');

// require_once("../config.php");
header('Content-type: text/html; charset=utf-8');

// define('SERVER_ADDRESS', $NewURL);
set_include_path(get_include_path() . PATH_SEPARATOR . "CLASS");
// set_include_path(get_include_path() . PATH_SEPARATOR . "CLASS/Managers");
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
require('Smarty/Smarty.class.php');
$smarty = new Smarty();
$smarty->setTemplateDir('templates');
$smarty->setCompileDir('templates_c');
$smarty->setCacheDir('cache');
$smarty->setConfigDir('configs');
$smarty->registerPlugin('function', 't', 'smarty_t');
$smarty->registerPlugin('function', 'page_url', 'smarty_page_url');
initLang();
// if(!isset($_SESSION['code'])){
//     if(isset($_POST['chceck_code'])){
//         $code = $_POST['code'];
//         if($code =='4444'){
//             $_SESSION['code'] = true;
//             header('Location: /');
//         }
//     }
//     $smarty->display('code.tpl');
//     return null;
// }

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
