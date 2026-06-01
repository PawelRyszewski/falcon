<?php
require_once("./../../env.php");
require_once("./../../CLASS/DatabaseManager.class.php");

header('Content-Type: application/json; charset=utf-8');

$title = $_POST['title'] ?? '';
$type = $_POST['type'] ?? 'all';
$modelId = isset($_POST['model_id']) ? (int)$_POST['model_id'] : 0;
if (!$title) {
    echo json_encode(['success' => false, 'error' => 'Brak tytułu']);
    exit;
}

$settings = DatabaseManager::selectSql('SELECT * FROM api_settings LIMIT 1');
if (!$settings) {
    echo json_encode(['success' => false, 'error' => 'Brak ustawień API']);
    exit;
}
$settings = $settings[0];

$searchService = $settings['search_service'] ?? 'brave';
$genService = $settings['gen_service'] ?? 'deepseek';
$systemPrompt = $settings['system_prompt'] ?? '';

$snippets = [];

if (($searchService == 'brave' || $searchService == 'both') && !empty($settings['brave_key'])) {
    $url = 'https://api.search.brave.com/res/v1/web/search?q=' . urlencode($title);
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => ['Accept: application/json', 'X-Subscription-Token: ' . $settings['brave_key']]
    ]);
    $resp = curl_exec($ch);
    curl_close($ch);
    $data = json_decode($resp, true);
    if (isset($data['web']['results'])) {
        foreach ($data['web']['results'] as $res) {
            $snippets[] = $res['title'] . ' - ' . ($res['snippet'] ?? '');
        }
    }
}

if (($searchService == 'jina' || $searchService == 'both') && !empty($settings['jina_key'])) {
    $url = 'https://api.jina.ai/search?q=' . urlencode($title);
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => ['Authorization: Bearer ' . $settings['jina_key']]
    ]);
    $resp = curl_exec($ch);
    curl_close($ch);
    $data = json_decode($resp, true);
    if (isset($data['data'])) {
        foreach ($data['data'] as $res) {
            $snippets[] = ($res['title'] ?? '') . ' - ' . ($res['snippet'] ?? '');
        }
    }
}

$context = implode("\n", array_slice($snippets, 0, 5));

$messages = [
    ['role' => 'system', 'content' => $systemPrompt],
    ['role' => 'user', 'content' => "Nazwa modelu: $title\n\nInformacje:\n$context\n\n Dla klucza 'description' w formacie JSON wygenerowana treść powinna być w formie struktury HTML, dozwolone tagi: p,h2,h3,h4,h5,strong,ol,ul,li,a,em. Zabronione jest używanie znaczników ```html HTML ma nie posiadać żadnych dodatkowych znaczników. Prócz tego należy wygenerować meta tytuł, meta opis i meta słowa kluczowe po polsku. Zwróć wynik w formacie JSON z kluczami: description, meta_title, meta_description, meta_keywords."]
];

$result = [];

if ($genService == 'deepseek' && !empty($settings['deepseek_key'])) {
    $payload = ['model' => 'deepseek-chat', 'messages' => $messages];
    $ch = curl_init('https://api.deepseek.com/v1/chat/completions');
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => ['Authorization: Bearer ' . $settings['deepseek_key'], 'Content-Type: application/json'],
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode($payload)
    ]);
    $resp = curl_exec($ch);
    curl_close($ch);
    $data = json_decode($resp, true);
    $content = $data['choices'][0]['message']['content'] ?? '';
    $content = trim(preg_replace('/^```json\s*|\s*```$/', '', $content));
    $result = json_decode($content, true) ?? [];
} elseif ($genService == 'gpt-4.1-mini' && !empty($settings['gpt41_key'])) {
    $payload = ['model' => 'gpt-4.1-mini', 'messages' => $messages];
    $ch = curl_init('https://api.openai.com/v1/chat/completions');
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => ['Authorization: Bearer ' . $settings['gpt41_key'], 'Content-Type: application/json'],
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => json_encode($payload)
    ]);
    $resp = curl_exec($ch);
    curl_close($ch);
    $data = json_decode($resp, true);
    $content = $data['choices'][0]['message']['content'] ?? '';
    $content = trim(preg_replace('/^```json\s*|\s*```$/', '', $content));
    $result = json_decode($content, true) ?? [];
}

if ($result) {
    $response = ['success' => true];
    if ($type === 'description' || $type === 'all') {
        $response['description'] = $result['description'] ?? '';
    }
    if ($type === 'meta' || $type === 'all') {
        $response['meta_title'] = $result['meta_title'] ?? '';
        $response['meta_description'] = $result['meta_description'] ?? '';
        $response['meta_keywords'] = $result['meta_keywords'] ?? '';
    }
    if ($modelId > 0) {
        $updateData = [];
        if ($type === 'description' || $type === 'all') {
            $updateData['description'] = $response['description'];
        }
        if ($type === 'meta' || $type === 'all') {
            $updateData['meta_title'] = $response['meta_title'];
            $updateData['meta_description'] = $response['meta_description'];
            $updateData['meta_keywords'] = $response['meta_keywords'];
        }
        if ($updateData) {
            DatabaseManager::updateSql('ai_models', $updateData, 'id=' . $modelId);
        }
    }	
    echo json_encode($response);
} else {
    echo json_encode(['success' => false, 'error' => 'Nie udało się wygenerować danych']);
}