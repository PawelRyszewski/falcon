# Seed danych inwestycji (5 rekordów)

Plik `realestate_seed_5.sql` uzupełnia dane testowe zgodne z `info.md`:
- 5 inwestycji (`investments`) z unikalnymi slugami,
- min. 2 jednostki na inwestycję (`investment_units`) ze statusami `Dostępny` / `Rezerwacja` / `Sprzedany`,
- min. 1 plik (`investment_files`) na inwestycję,
- min. 2 zdjęcia (`investment_gallery`) na inwestycję.

## Uruchomienie

1. Najpierw wykonaj migrację schematu:

```bash
mysql -u <USER> -p <DB_NAME> < docs/migrations/2026-03-27_investments_schema.sql
```

2. Następnie wykonaj seed:

```bash
mysql -u <USER> -p <DB_NAME> < docs/seeds/realestate_seed_5.sql
```

3. Kontrola po seedzie:

```sql
SELECT COUNT(*) FROM investments;
SELECT investment_id, COUNT(*) FROM investment_units GROUP BY investment_id;
SELECT investment_id, COUNT(*) FROM investment_files GROUP BY investment_id;
SELECT investment_id, COUNT(*) FROM investment_gallery GROUP BY investment_id;
```

## Dodatkowa weryfikacja spójności

```sql
-- brak osieroconych FK (oczekiwane: 0)
SELECT COUNT(*) AS orphan_units
FROM investment_units iu
LEFT JOIN investments i ON i.id = iu.investment_id
WHERE i.id IS NULL;

SELECT COUNT(*) AS orphan_files
FROM investment_files f
LEFT JOIN investments i ON i.id = f.investment_id
WHERE i.id IS NULL;

SELECT COUNT(*) AS orphan_gallery
FROM investment_gallery g
LEFT JOIN investments i ON i.id = g.investment_id
WHERE i.id IS NULL;

-- slug unikalne (oczekiwane: 0)
SELECT slug, COUNT(*) c
FROM investments
GROUP BY slug
HAVING c > 1;

-- statusy jednostek zgodne słownikowo
SELECT DISTINCT status
FROM investment_units
ORDER BY status;

-- daty publikacji ustawione (oczekiwane: 0)
SELECT COUNT(*) AS missing_published_at
FROM investments
WHERE published_at IS NULL;
```
