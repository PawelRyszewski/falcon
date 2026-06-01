# Falcon / EKO-DOM — przewodnik dla modelu LLM

> Ostatnia aktualizacja: 2026-06-01 (UTC)
> Cel: szybka orientacja w repozytorium — gdzie znajdują się widoki, logika PHP, skrypty pomocnicze, zasoby, migracje i szablony Smarty.

## 1. Najważniejszy kontekst

To jest klasyczna aplikacja PHP oparta o:

- własny prosty router w `index.php` i `admin/index.php`,
- klasy w katalogach `CLASS/` oraz `admin/CLASS/`,
- moduły/akcje widoków w `LIB/` oraz `admin/LIB/`,
- szablony Smarty w `templates/` oraz `admin/templates/`,
- bibliotekę Smarty vendoryzowaną lokalnie w `Smarty/` oraz `admin/Smarty/`,
- zasoby statyczne w `utils/` i `admin/utils/`,
- pliki przesłane przez CMS w `uploads/`.

Nie widać tu standardowego menedżera zależności (`composer.json`, `package.json`) ani frameworka typu Laravel/Symfony. Zależności JS/CSS/PHP są trzymane lokalnie w repozytorium.

## 2. Punkty wejścia aplikacji

| Plik | Rola |
| --- | --- |
| `index.php` | Front publiczny. Ładuje `env.php`, Smarty, i18n oraz tworzy `MainPage` z parametrów URL (`par1`, `par2`, `par3`). |
| `admin/index.php` | Panel administracyjny. Ładuje `admin/env.php`, `admin/setup.php`, Smarty, i18n i adminowy `MainPage`. |
| `mail.php` | Obsługa formularza kontaktowego: zapis do `newsletter_subscribers`, uzupełnianie brakujących kolumn, wysyłka maila i przekierowanie. |
| `newsletter.php` | Publiczny zapis/wypis z newslettera; obsługuje także odpowiedzi AJAX JSON. |
| `pages_import.php` | Endpoint JSON importujący strony do tabeli `pages`; wymaga nagłówka `X-API-Key` lub parametru `api_key` zgodnego z lokalną stałą. |
| `admin/newsletter_export.php` | Eksport CSV subskrybentów newslettera dla zalogowanego admina. |
| `admin/upload.php` | Upload obrazu do katalogu `../ai-materials/uploads/` używany przez panel/edytor. |
| `admin/api/svg-map-save.php` | Samodzielny endpoint AJAX zapisujący mapę SVG kategorii nieruchomości. |
| `utils/ajax/fetch-realestate-images.php` | Publiczny endpoint AJAX zwracający obrazy nieruchomości w JSON. |
| `zip-pack.php` | Narzędzie webowe do spakowania katalogu aplikacji do ZIP; wspiera `dry_run`, `exclude`, `level`, `follow_links`. |
| `php.php` i `admin/php.php` | Proste diagnostyczne pliki wypisujące wersję PHP. |
| `smtp_test.php` | Test wysyłki maila przez konfigurację z `env.php`. |

## 3. Konfiguracja środowiska

| Plik | Rola |
| --- | --- |
| `env.php` | Zmienne środowiskowe frontu: baza danych (`HOST`, `DB_NAME`, `USERNAME`, `PASSWORD`), tryb `ENVIRONMENT`, SMTP/IMAP. |
| `admin/env.php` | Analogiczna konfiguracja dla panelu administracyjnego. |
| `admin/setup.php` | Ustawia globalny URL panelu w `$GLOBALS['admin_url']` (obecnie `weo`). |
| `.htaccess` i `admin/.htaccess` | Reguły serwera Apache / przepisywanie URL-i. |
| `.user.ini` | Lokalne ustawienia PHP dla hostingu. |
| `robots.txt` | Dyrektywy dla robotów. |
| `pass.htpasswd` | Plik haseł dla Basic Auth — traktować jako wrażliwy. |

Uwaga: `env.php` i `admin/env.php` mogą zawierać dane dostępowe. Przy zmianach nie logować sekretów, nie dopisywać ich do dokumentacji i nie przenosić do kodu.

## 4. Routing frontu publicznego

Routing frontu jest w `CLASS/MainPage.class.php`. `index.php` tworzy obiekt `MainPage`, a konstruktor dobiera zestaw plików z `LIB/`.

Najważniejsze ścieżki:

| URL / warunek | Ładowane moduły |
| --- | --- |
| `/` / `start` | `head_global.lib.php`, `menu_global.lib.php`, `container_start.lib.php`, `footer_global.lib.php` |
| `/inwestycje` | `head_global.lib.php`, `menu_global.lib.php`, `nieruchomosci.lib.php`, `footer_global.lib.php` |
| `/inwestycje/{slug}` | `head_global.lib.php`, `menu_global.lib.php`, `wybrana_nieruchomosc.lib.php`, `footer_global.lib.php` |
| `/developer` | `head_global.lib.php`, `menu_global.lib.php`, `container_subpage.lib.php`, `footer_global.lib.php` |
| `/kontakt` lub `/kontakt/27` | `head_global.lib.php`, `menu_global.lib.php`, `container_kontakt.lib.php`, `footer_global.lib.php` |
| `/blog` i `/blog/{slug}` | listing: `container_aktualnosci.lib.php`; szczegół: `container_aktualnosc.lib.php` |
| `/categories` | `container_categories.lib.php` |
| `/ranking-ai` | `container_ranking.lib.php` |
| `/model/{slug}` | `container_model.lib.php` |
| inne ścieżki | domyślnie `container_subpage.lib.php` |

Wzorzec pracy nad frontem:

1. sprawdź routing w `CLASS/MainPage.class.php`,
2. znajdź odpowiadający moduł w `LIB/*.lib.php`,
3. sprawdź przypisania zmiennych Smarty w module,
4. edytuj właściwy szablon w `templates/*.tpl`,
5. w razie potrzeby zmień style/skrypty w `utils/css/` albo `utils/js/`.

## 5. Routing panelu administracyjnego

Routing CMS jest w `admin/CLASS/MainPage.class.php`. Panel rozdziela widoki zależnie od sesji:

- jeśli `$_SESSION['logged_in']` istnieje: ładuje `head.lib.php`, właściwy moduł z `admin/LIB/`, a na końcu `footer.lib.php`,
- jeśli użytkownik nie jest zalogowany: ładuje `head-login.lib.php`, `menu.lib.php` i domyślnie `login.lib.php` albo widoki resetu hasła.

Główne sekcje CMS:

| Sekcja | Moduły w `admin/LIB/` | Szablony w `admin/templates/` |
| --- | --- | --- |
| Start | `start.lib.php` | `start.tpl` |
| Podstrony | `podstrony*.lib.php` | `podstrony*.tpl` |
| Kategorie podstron | `podstrony-kategorie*.lib.php` | `podstrony-kategorie*.tpl` |
| Języki | `jezyki*.lib.php` | `jezyki*.tpl` |
| Użytkownicy | `uzytkownicy*.lib.php` | `uzytkownicy*.tpl` |
| Newsletter | `newsletter*.lib.php`, `newsletter-emails.lib.php`, `newsletter-templates*.lib.php` | `newsletter*.tpl`, `newsletter-emails.tpl`, `newsletter-templates*.tpl` |
| Aktualności/blog | `aktualnosci*.lib.php`, `aktualnosci-kategorie*.lib.php` | `aktualnosci*.tpl`, `aktualnosci-kategorie*.tpl` |
| Modele AI / kategorie / głosy | `ai-models*.lib.php`, `categories*.lib.php`, `votes.lib.php` | `ai-models*.tpl`, `categories*.tpl`, `votes.tpl` |
| Galeria | `galeria*.lib.php` | `galeria*.tpl` |
| Nieruchomości/inwestycje | `nieruchomosci*.lib.php`, `realestate_schema.lib.php` | `nieruchomosci*.tpl`, `wybrana_nieruchomosc.tpl` |
| Poczta | `poczta.lib.php` | `poczta.tpl` |
| Ustawienia API | `api-settings.lib.php` | `api-settings.tpl` |

## 6. Szablony Smarty

Szablony są w katalogach:

- `templates/` — front publiczny,
- `admin/templates/` — panel administracyjny,
- `templates/partials/` i `admin/templates/partials/` — części wspólne, np. element menu,
- `Smarty/` oraz `admin/Smarty/` — lokalna kopia silnika Smarty i jego pluginów; nie edytować bez konieczności.

Konfiguracja Smarty:

- front (`index.php`): `setTemplateDir('templates')`, `setCompileDir('templates_c')`, `setCacheDir('cache')`, `setConfigDir('configs')`,
- admin (`admin/index.php`): analogicznie względem katalogu `admin/`.

Dostępne niestandardowe pluginy/funkcje rejestrowane w aplikacji:

- `{t ...}` — tłumaczenia przez `smarty_t`,
- `{page_url ...}` — budowanie URL-i przez `smarty_page_url`.

Implementacja helperów i18n znajduje się w:

- `utils/php/i18n.php`,
- `admin/utils/php/i18n.php`.

Przy pracy z widokiem zwykle istnieje para:

- `LIB/nazwa.lib.php` + `templates/nazwa.tpl`,
- `admin/LIB/nazwa.lib.php` + `admin/templates/nazwa.tpl`.

Jeżeli zmieniasz HTML, najpierw sprawdź, czy zmienna jest przypisywana w pliku `.lib.php`, a dopiero potem edytuj `.tpl`.

## 7. Logika PHP i klasy

| Katalog / plik | Rola |
| --- | --- |
| `CLASS/DatabaseManager.class.php` | Główna klasa PDO dla frontu: `selectSql`, `insertSql`, `updateSql`, `deleteSql`, grupowania, inkrementacja. |
| `CLASS/MainPage.class.php` | Router frontu. |
| `CLASS/VoteManager.class.php` | Obsługa głosów/rankingu. |
| `admin/CLASS/DatabaseManager.class.php` | Odpowiednik DB dla panelu. |
| `admin/CLASS/MainPage.class.php` | Router panelu. |
| `utils/php/helpers.php` | Helpery frontu, m.in. wysyłka maili przez PHPMailer. |
| `admin/utils/php/helpers.php` | Helpery admina. |
| `utils/php/libphp-phpmailer/` i `admin/utils/php/libphp-phpmailer/` | Lokalna kopia PHPMailer. |

Uwaga techniczna: w wielu miejscach kod buduje SQL przez konkatenację. Przy dopisywaniu nowego kodu preferuj parametryzowane zapytania PDO albo bezpieczne metody `DatabaseManager`, a istniejących zachowań nie refaktoryzuj szeroko bez potrzeby.

## 8. Zasoby statyczne

| Katalog | Zawartość |
| --- | --- |
| `utils/css/` | Style frontu: Bootstrap, `style.css`, `style-min.css`, `onestyle.css`, style map SVG, Swiper, Fancybox, TinyMCE. |
| `utils/js/` | Skrypty frontu: jQuery, Bootstrap, Swiper, Fancybox, walidacja, newsletter, sortowanie rankingu, galeria, cookies. |
| `utils/images/` | Ikony, favicony, grafiki 404, SVG, preloadery. |
| `admin/utils/` | Zasoby panelu: Bootstrap, DataTables, TinyMCE, Chart.js, style admina, JS pomocniczy. |
| `uploads/` | Pliki wgrywane przez CMS/użytkowników. |
| `uploads/thumb/` | Miniatury plików z `uploads/`. |
| `0-wdrozyc/` | Materiały robocze/do wdrożenia (`index.html`, assets, images). |

Nie zakładaj, że `uploads/` jest kodem aplikacji — to głównie zawartość użytkowa. Przy globalnych wyszukiwaniach pomijaj `uploads/`, `Smarty/`, `admin/Smarty/` i zewnętrzne biblioteki, jeśli nie są istotne.

## 9. Baza danych, migracje i seedy

| Plik / katalog | Rola |
| --- | --- |
| `baza-danych.sql` | Główny zrzut/schemat bazy. |
| `docs/realestate_cms_schema.sql` | Schemat CMS dla nieruchomości/inwestycji. |
| `docs/migrations/` | Migracje SQL, m.in. inwestycje, statusy nieruchomości, kategorie, pola domów, opisy/obrazy kategorii. |
| `docs/seeds/README.md` | Instrukcja seedów. |
| `docs/seeds/realestate_seed_5.sql` | Przykładowe dane nieruchomości. |

Migracje są zwykłymi plikami SQL, nie częścią automatycznego narzędzia migracyjnego.

## 10. Lokalnie dostępne skrypty i narzędzia webowe

Repozytorium nie ma `Makefile`, `composer.json` ani `package.json`. Dostępne „skrypty” to głównie endpointy PHP uruchamiane przez serwer lub CLI.

Przykłady uruchomień lokalnych:

```bash
php -S 127.0.0.1:8000
```

Następnie można otwierać m.in.:

- `http://127.0.0.1:8000/` — front,
- `http://127.0.0.1:8000/admin/` — panel,
- `http://127.0.0.1:8000/php.php` — wersja PHP,
- `http://127.0.0.1:8000/zip-pack.php?dry_run=1&exclude=.git,uploads,cache,templates_c` — test pakowania bez zapisu ZIP.

Przykłady kontroli składni PHP:

```bash
find . -path './.git' -prune -o -path './uploads' -prune -o -path './Smarty' -prune -o -path './admin/Smarty' -prune -o -name '*.php' -print -exec php -l {} \;
```

Przykład importu stron przez `pages_import.php`:

```bash
curl -X POST 'https://example.test/pages_import.php?api_key=SEKRET123' \
  -H 'Content-Type: application/json' \
  --data '[{"title":"Tytuł","title_seo":"SEO","url":"slug","content":"Treść","description":"Opis","keywords":"tag"}]'
```

## 11. Języki i tłumaczenia

| Katalog / plik | Rola |
| --- | --- |
| `langs/pl.php` | Tłumaczenia polskie. |
| `langs/eng.php` | Tłumaczenia angielskie. |
| `utils/php/i18n.php` | Frontowy mechanizm tłumaczeń i helpery Smarty. |
| `admin/utils/php/i18n.php` | Adminowy mechanizm tłumaczeń i helpery Smarty. |

W szablonach używaj istniejącego mechanizmu `{t ...}` zamiast twardo wpisywać tekst, jeśli dana część jest już wielojęzyczna.

## 12. Dobre praktyki dla kolejnego LLM/agenta

1. **Nie zaczynaj od vendora** — pomijaj `Smarty/`, `admin/Smarty/`, `utils/php/libphp-phpmailer/`, `admin/utils/php/libphp-phpmailer/`, jeśli nie debugujesz biblioteki.
2. **Dla widoku znajdź parę `.lib.php` + `.tpl`** — logika i dane są zwykle w `LIB/`, HTML w `templates/`.
3. **Dla CMS używaj katalogu `admin/`** — ma osobne klasy, LIB-y, szablony i zasoby.
4. **Szablony Smarty są w `templates/`** — pliki `.tpl`, a nie HTML w PHP, są głównym miejscem edycji markupów.
5. **Nie kasuj `uploads/`** — to pliki użytkowe; nie traktować ich jak tymczasowego cache.
6. **Uważaj na cache/kompilaty Smarty** — katalogi `cache/`, `templates_c/`, `admin/cache/`, `admin/templates_c/` mogą być generowane środowiskowo.
7. **Nie ujawniaj sekretów** — `env.php`, `admin/env.php`, `pass.htpasswd` mogą zawierać dane wrażliwe.
8. **Przed większą zmianą sprawdź bazę** — struktura DB jest w `baza-danych.sql` i `docs/migrations/`.
9. **Przy AJAX sprawdź endpointy w `utils/ajax/`, `admin/utils/php/` i `admin/api/`**.
10. **Do wyszukiwania używaj `rg`** — repo ma dużo zasobów i bibliotek; zawężaj wzorce katalogami.

## 13. Szybka mapa katalogów

```text
.
├── CLASS/                 # klasy frontu: router, DB, głosy
├── LIB/                   # moduły frontu ładowane przez router
├── Smarty/                # lokalna kopia Smarty dla frontu
├── admin/
│   ├── CLASS/             # klasy panelu
│   ├── LIB/               # moduły panelu
│   ├── Smarty/            # lokalna kopia Smarty dla panelu
│   ├── api/               # samodzielne endpointy API admina
│   ├── templates/         # szablony Smarty panelu
│   └── utils/             # CSS/JS/PHP helpery panelu
├── docs/
│   ├── migrations/        # migracje SQL
│   └── seeds/             # seedy SQL
├── langs/                 # tłumaczenia
├── templates/             # szablony Smarty frontu
├── uploads/               # pliki wgrane przez CMS/użytkowników
└── utils/                 # zasoby i helpery frontu
```

## 14. Minimalna procedura zmiany widoku

1. Ustal URL i routing w `CLASS/MainPage.class.php` lub `admin/CLASS/MainPage.class.php`.
2. Otwórz odpowiedni plik `LIB/*.lib.php` albo `admin/LIB/*.lib.php`.
3. Sprawdź, jakie zmienne są przypisywane do Smarty.
4. Edytuj szablon w `templates/*.tpl` albo `admin/templates/*.tpl`.
5. Jeśli potrzeba, dopisz CSS/JS w `utils/` albo `admin/utils/`.
6. Uruchom przynajmniej `php -l` dla zmienionych plików PHP; dla zmian w samym Markdown wystarczy kontrola statusu Git.
