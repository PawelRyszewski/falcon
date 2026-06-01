<?php
$smarty = new Smarty();

$record = DatabaseManager::selectSql('SELECT * FROM api_settings LIMIT 1');
if (isset($_POST['save_api_settings'])) {
    $data = [
        'brave_key' => $_POST['brave_key'] ?? '',
        'jina_key' => $_POST['jina_key'] ?? '',
        'deepseek_key' => $_POST['deepseek_key'] ?? '',
        'gpt41_key' => $_POST['gpt41_key'] ?? '',
        'search_service' => $_POST['search_service'] ?? 'brave',
        'gen_service' => $_POST['gen_service'] ?? 'deepseek',
        'system_prompt' => $_POST['system_prompt'] ?? ''
    ];
    if ($record) {
        DatabaseManager::updateSql('api_settings', $data, 'id=' . $record[0]['id']);
    } else {
        DatabaseManager::insertSql('api_settings', $data);
    }
    $_SESSION['msg_success'] = 'Zapisano ustawienia.';
    header('Location: /admin/api-settings');
    exit;
}
$record = DatabaseManager::selectSql('SELECT * FROM api_settings LIMIT 1');
$settings = $record ? $record[0] : [];
$smarty->assign('settings', $settings);
$smarty->display('api-settings.tpl');
