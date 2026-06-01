<?php
// Simple translation helper
if (!defined('LANG_PATH')) {
    define('LANG_PATH', dirname(__DIR__, 2) . '/langs');
}

function getSupportedLanguages(): array {
    static $langs = null;
    if ($langs !== null) return $langs;
    try {
        $db = DatabaseManager::getConnection();
        $langs = $db->query('SELECT name FROM pages_langs')->fetchAll(PDO::FETCH_COLUMN);
        if (!$langs) { $langs = ['pl']; }
    } catch (PDOException $e) {
        $langs = ['pl'];
    }
    return $langs;
}

function getDefaultLang(): string {
    static $def = null;
    if ($def !== null) return $def;
    try {
        $db = DatabaseManager::getConnection();
        $def = $db->query('SELECT name FROM pages_langs WHERE is_default=1 LIMIT 1')->fetchColumn();
    } catch (PDOException $e) {
        $def = null;
    }
    return $def ?: (getSupportedLanguages()[0] ?? 'pl');
}

function initLang(): void {
    $supported = getSupportedLanguages();
    $default = getDefaultLang();
    if (isset($_GET['lang']) && in_array($_GET['lang'], $supported)) {
        $_SESSION['lang'] = $_GET['lang'];
        return;
    }

    $prefix = $_GET['par1'] ?? null;
    if ($prefix && in_array($prefix, $supported)) {
        $_SESSION['lang'] = $prefix;
        $_GET['par1'] = $_GET['par2'] ?? 'start';
        $_GET['par2'] = $_GET['par3'] ?? false;
        unset($_GET['par3']);
    } elseif (!isset($_SESSION['lang'])) {
        $preferred = substr($_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? $default, 0, 2);
        $_SESSION['lang'] = in_array($preferred, $supported) ? $preferred : $default;
    }
}

function loadLangFile(string $lang): array {
    static $cache = [];
    if (isset($cache[$lang])) {
        return $cache[$lang];
    }
    $file = LANG_PATH . '/' . $lang . '.php';
    if (is_file($file)) {
        $data = include $file;
        if (is_array($data)) {
            $cache[$lang] = $data;
            return $data;
        }
    }
    $cache[$lang] = [];
    return $cache[$lang];
}

function t(string $key, ?string $lang = null): string {
    $lang = $lang ?? ($_SESSION['lang'] ?? getDefaultLang());
    $vals = loadLangFile($lang);
    if (isset($vals[$key])) {
        return $vals[$key];
    }
    $defaultVals = loadLangFile(getDefaultLang());
    return $defaultVals[$key] ?? "⟦$key⟧";
}

function smarty_t($params, Smarty_Internal_Template $template): string {
    $key = $params['key'] ?? '';
    $lang = $params['lang'] ?? null;
    return t($key, $lang);
}

function page_url(string $slug, ?string $lang = null): string {
    $lang = $lang ?? ($_SESSION['lang'] ?? 'pl');
    $slug = ltrim($slug, '/');
    return '/' . $lang . ($slug === 'start' ? '' : '/' . $slug);
}

function smarty_page_url($params, Smarty_Internal_Template $template): string {
    $slug = $params['slug'] ?? '';
    $lang = $params['lang'] ?? null;
    return page_url($slug, $lang);
}
