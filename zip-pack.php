<?php
/**
 * pack.php — tworzy ZIP z całej zawartości katalogu, w którym leży ten plik.
 *
 * Parametry (GET):
 *   - name=backup.zip     : nazwa wynikowego archiwum (domyślnie backup-YYYYmmdd-His.zip)
 *   - exclude=lista       : przecinki, wzorce z * i ? (np. ".git,node_modules,*.zip,pack.php")
 *   - dry_run=1           : podgląd bez tworzenia ZIP (wypisuje co byłoby dodane)
 *   - level=6             : poziom kompresji 0–9 (domyślnie 6)
 *   - follow_links=1      : podążaj za symlinkami (domyślnie pomijane)
 *
 * Uwaga:
 *  - Zawsze wyklucza ten plik oraz docelowy plik ZIP.
 *  - Po zakończeniu ZIP powstaje w tym samym katalogu.
 */

declare(strict_types=1);
error_reporting(E_ALL);
ini_set('display_errors', '1');
set_time_limit(0);
ignore_user_abort(true);

header('Content-Type: text/plain; charset=utf-8');

$baseDir = realpath(__DIR__);
if ($baseDir === false) {
    http_response_code(500);
    exit("Błąd: nie udało się ustalić katalogu bazowego.\n");
}

function norm_path(string $p): string {
    return rtrim(str_replace('\\','/',$p), '/');
}
$baseDirN = norm_path($baseDir);

// Parametry
$name = isset($_GET['name']) ? trim((string)$_GET['name']) : '';
$name = preg_replace('/[^A-Za-z0-9._-]+/', '_', $name ?? '') ?: ('backup-' . date('Ymd-His'));
if (!preg_match('/\.zip$/i', $name)) $name .= '.zip';

$dryRun       = !empty($_GET['dry_run']);
$followLinks  = !empty($_GET['follow_links']);
$level        = isset($_GET['level']) ? max(0, min(9, (int)$_GET['level'])) : 6;
$excludeInput = isset($_GET['exclude']) ? (string)$_GET['exclude'] : '';
$exclude = array_values(array_filter(array_map('trim', explode(',', $excludeInput))));

// Ścieżka ZIP
$zipPath = $baseDir . DIRECTORY_SEPARATOR . basename($name);

// Nie nadpisuj istniejącego — nadaj unikalną nazwę
function unique_path(string $path): string {
    if (!file_exists($path)) return $path;
    $i = 1;
    $dir = dirname($path);
    $base = pathinfo($path, PATHINFO_FILENAME);
    $ext = pathinfo($path, PATHINFO_EXTENSION);
    do {
        $candidate = $dir . DIRECTORY_SEPARATOR . $base . "-{$i}." . $ext;
        $i++;
    } while (file_exists($candidate));
    return $candidate;
}
if (!$dryRun) {
    $zipPath = unique_path($zipPath);
}

// Stałe wykluczenia (zawsze)
$exclude[] = basename(__FILE__);           // ten skrypt
$exclude[] = basename($zipPath);           // docelowy zip

// Pomocnicze: dopasowanie wzorców exclude do ścieżki relatywnej lub samej nazwy
function match_exclude(string $relPath, string $baseName, array $patterns): bool {
    $relPathN = str_replace('\\','/',$relPath);
    foreach ($patterns as $pat) {
        $pat = trim($pat);
        if ($pat === '') continue;
        // fnmatch jeśli dostępne
        if (function_exists('fnmatch')) {
            if (fnmatch($pat, $baseName, FNM_CASEFOLD) || fnmatch($pat, $relPathN, FNM_PATHNAME | FNM_CASEFOLD)) {
                return true;
            }
        } else {
            // prosty fallback: zamiana * i ? na regex
            $re = '#^' . str_replace(['\*','\?'], ['.*','.'], preg_quote($pat, '#')) . '$#i';
            if (preg_match($re, $baseName) || preg_match($re, $relPathN)) {
                return true;
            }
        }
    }
    return false;
}

echo "Katalog bazowy: {$baseDir}\n";
echo "Plik wynikowy : " . ($dryRun ? '(dry-run) ' : '') . basename($zipPath) . "\n";
echo "Kompresja     : level={$level}\n";
echo "Podążanie za symlinkami: " . ($followLinks ? 'TAK' : 'NIE') . "\n";
if (!empty($exclude)) echo "Wykluczenia   : " . implode(', ', $exclude) . "\n";
echo "\n";

// Iterator po wszystkich zasobach
$flags = FilesystemIterator::SKIP_DOTS | ($followLinks ? 0 : FilesystemIterator::CURRENT_AS_FILEINFO);
$it = new RecursiveIteratorIterator(
    new RecursiveDirectoryIterator($baseDir, $flags),
    RecursiveIteratorIterator::SELF_FIRST
);

// Zbiór do spakowania
$toAdd = [];
foreach ($it as $fi) {
    /** @var SplFileInfo $fi */
    $path = $fi->getPathname();
    // Relatywna ścieżka wewnątrz ZIP
    $rel = ltrim(str_replace($baseDir, '', $path), DIRECTORY_SEPARATOR);
    if ($rel === '') continue;

    // Pomijaj docelowy ZIP i wykluczenia
    if ($path === $zipPath) continue;
    if (match_exclude($rel, $fi->getBasename(), $exclude)) {
        echo "[SKIP] {$rel}\n";
        continue;
    }

    // Symlinki
    if ($fi->isLink() && !$followLinks) {
        echo "[LINK-SKIP] {$rel}\n";
        continue;
    }

    if ($fi->isDir()) {
        $toAdd[] = ['type' => 'dir',  'path' => $path, 'rel' => $rel];
    } elseif ($fi->isFile()) {
        $toAdd[] = ['type' => 'file', 'path' => $path, 'rel' => $rel];
    } else {
        echo "[SKIP-OTHER] {$rel}\n";
    }
}

if ($dryRun) {
    $dirs = 0; $files = 0;
    foreach ($toAdd as $e) {
        if ($e['type'] === 'dir')  { echo "[DIR ] {$e['rel']}\n";  $dirs++; }
        if ($e['type'] === 'file') { echo "[FILE] {$e['rel']}\n"; $files++; }
    }
    echo "\nPODSUMOWANIE (dry-run): katalogi={$dirs}, pliki={$files}\n";
    exit;
}

// Tworzenie ZIP
$zip = new ZipArchive();
if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
    http_response_code(500);
    exit("Błąd: nie udało się utworzyć archiwum.\n");
}

// Dodawanie
$dirs = 0; $files = 0;
foreach ($toAdd as $e) {
    if ($e['type'] === 'dir') {
        // Zabezpieczenie: dodaj puste katalogi, aby odtworzyć strukturę
        $zip->addEmptyDir(str_replace('\\','/',$e['rel']));
        echo "[DIR ] {$e['rel']}\n";
        $dirs++;
    } elseif ($e['type'] === 'file') {
        // Jeśli follow_links, użyj realpath
        $src = $e['path'];
        if ($followLinks) {
            $rp = realpath($src);
            if ($rp !== false) $src = $rp;
        }
        $added = $zip->addFile($src, str_replace('\\','/',$e['rel']));
        if (!$added) {
            echo "[FAIL] {$e['rel']}\n";
            continue;
        }
        // Ustaw poziom kompresji, jeśli metoda dostępna
        if (method_exists($zip, 'setCompressionName')) {
            $zip->setCompressionName($e['rel'], $level);
        }
        echo "[FILE] {$e['rel']}\n";
        $files++;
    }
}

$zip->close();

$size = @filesize($zipPath);
echo "\nPODSUMOWANIE: katalogi={$dirs}, pliki={$files}\n";
echo "Zapisano: " . basename($zipPath) . ($size !== false ? " (" . number_format($size/1024/1024, 2) . " MB)" : "") . "\n";
echo "Gotowe.\n";