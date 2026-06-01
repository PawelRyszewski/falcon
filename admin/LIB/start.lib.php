<?php
$smarty = new Smarty();
function polishMonth()
{
    $key = date("n");
    $miesiac = array('', 'Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień');
    return $miesiac[$key];
}


/* PODSTRONY */
$pages = DatabaseManager::selectSql('SELECT * FROM pages WHERE type = "subpage" ORDER BY id DESC');
$smarty->assign('pages', $pages);

/* AKTUALNOŚCI */
$news = DatabaseManager::selectSql('SELECT * FROM pages WHERE type = "news" ORDER BY visit DESC LIMIT 4');
$smarty->assign('news', $news);


$images = DatabaseManager::selectSql("SELECT * FROM `images` ORDER BY `images`.`id` DESC LIMIT 10");
require_once('./utils/php/functions.php');
$images = array_map(function($item){
    $item['img_path'] = resolveNewsImagePath($item['name']);
    $item['thumb_path'] = resolveNewsImagePath($item['name'], true);
    return $item;
}, $images);
$smarty->assign('images', $images);


$currentMonth = date("m");
$currentYear = date("Y");

if ($currentMonth == 1) {
    $previousMonth = 12;
    $previousYear = $currentYear - 1;
} else {
    $previousMonth = $currentMonth - 1;
    $previousYear = $currentYear;
}
$views = DatabaseManager::selectSqlGroup("SELECT day,views FROM daily_views WHERE month = $currentMonth AND year = $currentYear");
$visitInPreviousMonth  = DatabaseManager::selectSql("SELECT SUM(views) FROM daily_views WHERE month = $previousMonth AND year = $previousYear");

$mainPageViewMonth = DatabaseManager::selectSql("SELECT views FROM monthly_views WHERE month = $currentMonth AND year = $currentYear AND url = '/'");

if($mainPageViewMonth) {
    $mainPageViewMonth = $mainPageViewMonth[0]['views'];
} else {
    $mainPageViewMonth = 0;
}

$smarty->assign('mainPageViewMonth', $mainPageViewMonth);

if($visitInPreviousMonth[0]["SUM(views)"]) {
    $visitInPreviousMonth = $visitInPreviousMonth[0]["SUM(views)"];
} else {
    $visitInPreviousMonth = 0;
}

$smarty->assign('views', $views);

$previousMonth = date("m-Y", strtotime("-1 months"));
$smarty->assign('visitInPreviousMonth', $visitInPreviousMonth);

$users = DatabaseManager::selectSqlGroup('SELECT id, login FROM users ORDER BY id DESC');
$smarty->assign('users', $users);

$daysInMonth = date('t');
$smarty->assign('daysInMonth', $daysInMonth);

$polishMonth = polishMonth();
$smarty->assign('polishMonth', $polishMonth);

$smarty->display('start.tpl');
