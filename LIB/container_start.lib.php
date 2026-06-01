<?php
$smarty = new Smarty();
$smarty->registerPlugin('function', 't', 'smarty_t');
$smarty->registerPlugin('function', 'page_url', 'smarty_page_url');

$cats_news = DatabaseManager::selectSql("SELECT id, name FROM news_categories WHERE id > 2 ORDER BY id ASC");

$latest_news = DatabaseManager::selectSql(
    "SELECT url, title, img, img_title, category, created_at FROM pages " .
    "WHERE type = 'news' AND is_published = 1 " .
    "ORDER BY created_at DESC LIMIT 3"
);

require_once './utils/php/helpers.php';
$latest_news = array_map(function ($item) {
    if (!empty($item['img'])) {
        $item['img_thumb_path'] = resolveNewsImagePath($item['img'], true);
    } else {
        $item['img_thumb_path'] = '';
    }
    return $item;
}, $latest_news);

$top_models_votes = [];
$top_models_score = [];

if(class_exists('VoteManager')) {
    $top_models_votes = VoteManager::getTopModelsByVotes(5);
    $top_models_score = VoteManager::getTopModelsByScore(5);
} else {
    require_once './CLASS/VoteManager.class.php';
    $top_models_votes = VoteManager::getTopModelsByVotes(5);
    $top_models_score = VoteManager::getTopModelsByScore(5);
}

$investmentsInProgress = [];
$investmentsCompleted = [];

$dbName = getenv('DB_NAME');
$categoryHomepageColsExist = false;
$firstSideInProgress = 'left';
$firstSideCompleted = 'left';
if ($dbName) {
    $dbNameSafe = addslashes($dbName);
    $colCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_categories' AND COLUMN_NAME = 'homepage_img' LIMIT 1");
    $categoryHomepageColsExist = !empty($colCheck[0]['qty']);

    $sectionTableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'realestate_homepage_section_settings' LIMIT 1");
    if (!empty($sectionTableCheck[0]['qty'])) {
        $sectionRows = DatabaseManager::selectSql("SELECT status, first_side FROM realestate_homepage_section_settings");
        if ($sectionRows) {
            foreach ($sectionRows as $row) {
                $side = ($row['first_side'] === 'right') ? 'right' : 'left';
                if ((int) $row['status'] === 1) {
                    $firstSideCompleted = $side;
                } else {
                    $firstSideInProgress = $side;
                }
            }
        }
    }
}

if ($categoryHomepageColsExist) {
    $categorySelect = "SELECT rc.id, rc.name, rc.status, rc.url, rc.homepage_img, rc.homepage_title, rc.homepage_subtitle FROM realestate_categories rc WHERE EXISTS (SELECT 1 FROM pages p WHERE p.type = 'realestate' AND p.category = rc.id AND COALESCE(p.is_hide, 0) = 0) ORDER BY rc.queue ASC, rc.id DESC";
} else {
    $categorySelect = "SELECT rc.id, rc.name, rc.status, rc.url, NULL AS homepage_img, NULL AS homepage_title, NULL AS homepage_subtitle FROM realestate_categories rc WHERE EXISTS (SELECT 1 FROM pages p WHERE p.type = 'realestate' AND p.category = rc.id AND COALESCE(p.is_hide, 0) = 0) ORDER BY rc.queue ASC, rc.id DESC";
}

$categories = DatabaseManager::selectSql($categorySelect);

if ($categories) {
    $imgIds = [];
    foreach ($categories as $cat) {
        $hpImg = (int)($cat['homepage_img'] ?? 0);
        if ($hpImg > 0) {
            $imgIds[] = $hpImg;
        }
    }
    $imgIds = array_unique(array_filter($imgIds));

    $imageMap = [];
    if ($imgIds) {
        $whereIds = implode(',', $imgIds);
        $imageRows = DatabaseManager::selectSql("SELECT id, name FROM images WHERE id IN ($whereIds)");
        foreach ($imageRows as $row) {
            $imageMap[(int)$row['id']] = $row['name'];
        }
    }

    foreach ($categories as $cat) {
        $hpImg = (int)($cat['homepage_img'] ?? 0);
        $imgName = $hpImg > 0 ? ($imageMap[$hpImg] ?? '') : '';
        $imageUrl = $imgName ? '/uploads/' . $imgName : '/utils/images/no-image.png';

        $status = (int)($cat['status'] ?? 0);
        $item = [
            'id'       => (int)$cat['id'],
            'url'      => !empty($cat['url']) ? $cat['url'] : categorySlug($cat['name'] ?? ''),
            'title'    => !empty($cat['homepage_title']) ? $cat['homepage_title'] : ($cat['name'] ?? ''),
            'subtitle' => $cat['homepage_subtitle'] ?? '',
            'image_url' => $imageUrl,
            'status'   => $status,
        ];

        if ($status === 1) {
            $investmentsCompleted[] = $item;
        } else {
            $investmentsInProgress[] = $item;
        }
    }
}

// Load homepage slider slides
$homepageSlides = [];
$sliderTableExists = false;
if ($dbName) {
    $dbNameSafe = addslashes($dbName);
    $sliderTableCheck = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '$dbNameSafe' AND TABLE_NAME = 'homepage_slider_slides' LIMIT 1");
    $sliderTableExists = !empty($sliderTableCheck[0]['qty']);
}
if ($sliderTableExists) {
    $rawSlides = DatabaseManager::selectSql(
        "SELECT hss.id, hss.slide_order, hss.text_p1, hss.text_p2, hss.text_p3,
                i.name AS img_name,
                rc.url AS category_url, rc.name AS category_name
         FROM homepage_slider_slides hss
         LEFT JOIN images i ON i.id = hss.image_id
         LEFT JOIN realestate_categories rc ON rc.id = hss.category_id
         ORDER BY hss.slide_order ASC, hss.id ASC"
    ) ?: [];
    foreach ($rawSlides as $slide) {
        $slide['image_url'] = !empty($slide['img_name']) ? '/uploads/' . $slide['img_name'] : '';
        if (empty($slide['category_url']) && !empty($slide['category_name'])) {
            $slide['category_url'] = categorySlug($slide['category_name']);
        }
        $homepageSlides[] = $slide;
    }
}
$smarty->assign('homepage_slides', $homepageSlides);

// Load homepage page data (id=0): hero image, overlay content, main content
$homepagePage = DatabaseManager::selectSql("SELECT img, content, content_short FROM pages WHERE id = 0 LIMIT 1");
$homepageContent = '';
$heroOverlayContent = '';
$heroBgImageUrl = null;

if ($homepagePage && isset($homepagePage[0])) {
    $homepageContent = $homepagePage[0]['content'] ?? '';
    $heroOverlayContent = $homepagePage[0]['content_short'] ?? '';

    $heroImgId = (int)($homepagePage[0]['img'] ?? 0);
    if ($heroImgId > 0) {
        $heroImageRow = DatabaseManager::selectSql("SELECT name FROM images WHERE id = {$heroImgId} LIMIT 1");
        if ($heroImageRow && !empty($heroImageRow[0]['name'])) {
            $heroBgImageUrl = '/uploads/' . $heroImageRow[0]['name'];
        }
    }
}

$languages = DatabaseManager::selectSql('SELECT name, is_default FROM pages_langs ORDER BY id ASC');
$currentLang = $_SESSION['lang'] ?? getDefaultLang();

$smarty->assign('languages', $languages);
$smarty->assign('currentLang', $currentLang);
$smarty->assign('cats_news', $cats_news);
$smarty->assign('latest_news', $latest_news);
$smarty->assign('top_models_votes', $top_models_votes);
$smarty->assign('top_models_score', $top_models_score);
$smarty->assign('investments_in_progress', $investmentsInProgress);
$smarty->assign('investments_completed', $investmentsCompleted);
$smarty->assign('first_side_in_progress', $firstSideInProgress);
$smarty->assign('first_side_completed', $firstSideCompleted);
$smarty->assign('homepage_content', $homepageContent);
$smarty->assign('hero_overlay_content', $heroOverlayContent);
$smarty->assign('hero_bg_image_url', $heroBgImageUrl);
$smarty->display('container_start.tpl');
