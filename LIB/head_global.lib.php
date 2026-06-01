<?php
$smarty = new Smarty();

$url = "";
$description = "";
$title = "";
$title_seo = "";
$keywords = "";
$currentDate = date("d-m-Y");
$day = date("d");
$month = date("m");
$year = date("Y");
$views = 1;
$par1 = isset($_GET['par1']) ? $_GET['par1'] : "";

if (isset($_GET['par2'])) {
    $url = $_GET['par2'];
} elseif (isset($_GET['par1'])) {
    $url = $_GET['par1'];
}


$metaData = DatabaseManager::selectSql("SELECT title, title_seo, description, keywords FROM pages WHERE url = '$url'");
$url = strlen($url) == 0 ? "/" : $url;

if ($par1 != "/admin" && $metaData) {
    DatabaseManager::insertSql("daily_views", array(
        'id' => $currentDate,
        'day' => $day,
        'month' => $month,
        'year' => $year,
        'views' => 1,
    ), "ON DUPLICATE KEY UPDATE views=views+1");


    DatabaseManager::insertSql("monthly_views", array(
        'date' => $year."-".$month,      
        'month' => $month,
        'year' => $year,
        'url' => $url,
        'views' => 1,
    ), "ON DUPLICATE KEY UPDATE views=views+1");
}

DatabaseManager::incrementValue("pages", "visit = visit + 1", "url = '{$url}'");

if ($metaData && $metaData[0]) {
    $description = $metaData[0]['description'];
    $title = $metaData[0]['title'];
    $title_seo = $metaData[0]['title_seo'];		
    $keywords = $metaData[0]['keywords'];
}

if (strlen($description) == 0) {
    $description = "Falcon Nest Poland organizuje luksusowe, muslim-friendly podróże do Polski dla gości z Bliskiego Wschodu: hotele 5★, prywatni kierowcy, kuchnia halal, concierge i program szyty na miarę.";
}

if (strlen($title) == 0) {
    $title = "Falcon Nest Poland - luksusowe podróże do Polski dla gości z Bliskiego Wschodu";
}

if (strlen($keywords) == 0) {
    $keywords = "Falcon Nest Poland, luksusowe podróże do Polski, wycieczki premium Polska, muslim friendly travel Poland, halal travel Poland, podróże dla gości z Bliskiego Wschodu, prywatny kierowca Polska, hotele 5 gwiazdek Polska, concierge Polska, bespoke tours Poland";
}

if(strlen($title_seo) == 0) {
    $title_seo = $title;
}


$smarty->assign('description', $description);
$smarty->assign('title', $title);
$smarty->assign('title_seo', $title_seo);
$smarty->assign('keywords', $keywords);
$smarty->display('head_global.tpl');


