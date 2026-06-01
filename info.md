# EKO-DOM — info.md

> Ostatnia aktualizacja: 2026-03-27 (UTC)
> Zakres: docelowa struktura serwisu EKO-DOM (frontend + CMS)
> Status: **OBOWIĄZUJĄCE ŹRÓDŁO PRAWDY**

## 1) Cel dokumentu
Ten dokument definiuje obowiązującą strukturę informacji i komponentów dla serwisu EKO-DOM. Ma być używany jako punkt odniesienia przy projektowaniu widoków, implementacji komponentów oraz weryfikacji zgodności wizualnej.

## 2) Mapa stron EKO-DOM
Docelowa mapa URL:

- `/` — strona główna,
- `/inwestycje` — listing inwestycji,
- `/inwestycje/{slug}` — karta szczegółowa inwestycji,
- `/developer` — strona o deweloperze,
- `/kontakt` — strona kontaktowa.

## 3) Wymagane sekcje każdego widoku
Każdy widok z mapy stron musi zawierać poniższe sekcje (w układzie dopasowanym do kontekstu strony):

1. **Hero**
   - nagłówek H1,
   - lead/krótki opis,
   - główne CTA.

2. **Slidery**
   - minimum jeden slider treści (np. zdjęcia inwestycji, atuty, realizacje),
   - na mobile obsługa swipe,
   - czytelne kontrolki (strzałki/paginacja).

3. **Listy**
   - listy strukturalne (np. inwestycje, atuty, etapy, udogodnienia),
   - spójne kafle/karty z tytułem, statusem i linkiem.

4. **Formularz**
   - formularz kontaktowy lub leadowy widoczny bez konieczności opuszczania widoku,
   - walidacja pól i obsługa błędów.

5. **Footer**
   - dane kontaktowe,
   - linki nawigacyjne,
   - informacje prawne (polityka prywatności/zgody).

## 4) Komponenty obowiązkowe
Niezależnie od widoku, w całym serwisie muszą występować i działać następujące komponenty:

1. **Submenu „Inwestycje”**
   - dostępne z poziomu głównej nawigacji,
   - zawiera link do `/inwestycje` oraz aktywnych inwestycji (`/inwestycje/{slug}`).

2. **Statusy domów**
   - ustandaryzowane statusy (np. „Dostępny”, „Rezerwacja”, „Sprzedany”),
   - status widoczny w listingu i w szczegółach inwestycji,
   - status wspiera filtrowanie/listowanie.

3. **Sekcja „Pliki do pobrania”**
   - dostępna na kartach inwestycji,
   - prezentuje dokumenty (PDF/DOC) z nazwą, typem i datą publikacji,
   - każdy plik posiada bezpośredni link pobrania.

4. **Formularz z zgodami**
   - checkboxy zgód marketingowych/RODO,
   - zgody rozdzielone na wymagane i opcjonalne,
   - zapisywanie stanu zgód razem z wysyłką formularza.

## 5) Źródła danych dla inwestycji (DB + CMS)

### 5.1 Tabele i kolumny (warstwa danych)
Minimalny model danych dla inwestycji powinien obejmować:

- `investments`
  - `id`, `slug`, `name`, `location`, `description_short`, `description_long`,
  - `status` (status inwestycji),
  - `cover_image`, `published_at`, `is_published`,
  - `created_at`, `updated_at`.

- `investment_units` (domy/lokale)
  - `id`, `investment_id`, `unit_name`, `unit_number`,
  - `area_m2`, `rooms`, `price`,
  - `status` (status domu/lokalu),
  - `floorplan_file`, `created_at`, `updated_at`.

- `investment_files`
  - `id`, `investment_id`, `title`, `file_path`, `file_type`,
  - `published_at`, `sort_order`, `is_active`.

- `investment_gallery`
  - `id`, `investment_id`, `image_path`, `alt_text`, `sort_order`, `is_active`.

- `contact_leads`
  - `id`, `investment_id` (nullable), `name`, `email`, `phone`, `message`,
  - `consent_required`, `consent_marketing`, `consent_profiling`,
  - `created_at`, `source_url`.

### 5.2 Pola CMS (warstwa edycyjna)
W CMS dla inwestycji wymagane są co najmniej:

- dane podstawowe: nazwa, slug, lokalizacja, status, daty publikacji,
- sekcja hero: tytuł, lead, obraz główny, CTA,
- sekcje opisowe: opis krótki i pełny,
- slider: lista zdjęć i kolejność,
- lista domów/lokali: parametry + status,
- „Pliki do pobrania”: nazwa pliku, plik, typ, kolejność,
- SEO: meta title, meta description, og:image,
- publikacja: szkic/opublikowane/ukryte.

## 6) Checklista zgodności wizualnej (pod screenshoty referencyjne)
Każdy widok (`/`, `/inwestycje`, `/inwestycje/{slug}`, `/developer`, `/kontakt`) musi przejść checklistę:

1. **Układ i siatka**
   - zgodność szerokości kontenera, marginesów i rytmu pionowego,
   - brak przesunięć layoutu między breakpoints.

2. **Hero**
   - poprawna hierarchia H1/H2,
   - CTA zgodne z wariantem referencyjnym,
   - kontrast tekstu do tła zgodny z projektem.

3. **Slidery i listy**
   - identyczne proporcje grafik względem referencji,
   - stany hover/focus/active widoczne i spójne,
   - liczba elementów i spacing zgodne z makietą.

4. **Statusy domów**
   - poprawne kolory badge’y statusów,
   - spójna legenda/statusy na wszystkich widokach,
   - brak niespójności nazw statusów.

5. **Pliki do pobrania**
   - sekcja obecna tam, gdzie wymagana,
   - czytelna nazwa pliku + ikona/typ,
   - poprawny stan hover/focus linku pobrania.

6. **Formularze i zgody**
   - walidacja wizualna pól (error/success),
   - checkboxy zgód czytelne i dostępne (label + focus),
   - komunikaty po wysyłce zgodne z makietą.

7. **Footer**
   - komplet obowiązkowych linków i danych,
   - spójna typografia i odstępy,
   - poprawne zachowanie RWD.

8. **Jakość screenshotów referencyjnych**
   - screenshot desktop + mobile dla każdego widoku,
   - ta sama rozdzielczość porównawcza między iteracjami,
   - brak overlayów debug/devtools na finalnych zrzutach.

## 7) Archiwum (sekcje wycofane)
Z dokumentu usunięto z części obowiązującej sekcje dotyczące:

- KSeF,
- rankingu AI,
- integracji i modeli powiązanych z poprzednim zakresem domenowym.

Sekcje te uznaje się za **archiwalne** i nieobowiązujące dla bieżącego rozwoju EKO-DOM.

---

**Data aktualizacji:** 2026-03-27 (UTC)
**Status dokumentu:** **OBOWIĄZUJĄCE ŹRÓDŁO PRAWDY**
