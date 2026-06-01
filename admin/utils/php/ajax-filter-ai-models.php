<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");
require_once("./../../../CLASS/VoteManager.class.php");

$category = isset($_GET['category']) ? (int)$_GET['category'] : 0;
$where = $category > 0 ? "WHERE m.category_id={$category}" : '';
$models = DatabaseManager::selectSql("SELECT m.*, c.name AS category_name FROM ai_models m LEFT JOIN llm_categories c ON m.category_id=c.id {$where} ORDER BY m.id DESC");
if (!$models) {
    $models = [];
}

$catMap = [];
if ($category > 0) {
    $cats = DatabaseManager::selectSql("SELECT * FROM llm_categories WHERE id={$category}");
} else {
    $cats = DatabaseManager::selectSql('SELECT * FROM llm_categories');
}
foreach ($cats as $cat) {
    $catMap[$cat['id']] = $cat;
}
$scoresByCategory = [];
foreach ($models as &$m) {
    $catId = $m['category_id'];
    if (!isset($scoresByCategory[$catId]) && isset($catMap[$catId])) {
        $scoresByCategory[$catId] = VoteManager::refreshCategoryFromJson($catMap[$catId]);
    }
    $m['score'] = $scoresByCategory[$catId][$m['id']] ?? 0;
    $plain = html_entity_decode(strip_tags($m['description']), ENT_QUOTES, 'UTF-8');
    $m['char_count'] = mb_strlen($plain, 'UTF-8');
}
unset($m);

ob_start();
foreach ($models as $m) {
    $id = (int)$m['id'];
    $name = htmlspecialchars($m['name']);
    $categoryName = htmlspecialchars($m['category_name'] ?? '-');
    $organization = htmlspecialchars($m['organization']);
    $license = htmlspecialchars($m['license']);
    $votesJson = (int)$m['votes_json'];
    $votesSite = (int)$m['votes_site'];
    $score = (int)$m['score'];
	$charCount = (int)$m['char_count'];
    echo "<tr>";
	echo "<td class=\"text-center\"><input type=\"checkbox\" class=\"model-checkbox\" value=\"{$id}\" data-name=\"{$name}\"></td>";
    echo "<td class=\"text-center\">{$id}</td>";
    echo "<td>{$name}</td>";
    echo "<td>{$categoryName}</td>";
    echo "<td>{$organization}</td>";
    echo "<td>{$license}</td>";
    echo "<td class=\"text-center\">{$votesJson}</td>";
    echo "<td class=\"text-center\">{$votesSite}</td>";
    echo "<td class=\"text-center\">{$score}</td>";
	echo "<td class=\"text-center\">{$charCount}</td>";
    echo "<td class=\"text-center\">";
    echo "<a href=\"/admin/ai-models/edytuj/{$id}\" class=\"orange hover-opacity\" title=\"Edytuj\"><span class=\"icon-content-edit\"></span></a>";
    echo "<a href=\"/admin/ai-models/usun/{$id}\" class=\"red hover-opacity ml-3\" title=\"Usuń\"><span class=\"icon-content-delete\"></span></a>";
    echo "</td>";
    echo "</tr>";
}
$html = ob_get_clean();
header('Content-Type: text/html; charset=utf-8');
echo $html;
exit;