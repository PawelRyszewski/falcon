START TRANSACTION;

INSERT INTO investments (
  slug, name, location, description_short, description_long, status,
  cover_image, published_at, is_published
) VALUES
  ('osiedle-zielone-tarasy', 'Osiedle Zielone Tarasy', 'Warszawa, Wawer', 'Nowoczesne domy szeregowe blisko zieleni.', 'Inwestycja z naciskiem na energooszczędność i dostęp do infrastruktury miejskiej.', 'W sprzedaży', '/uploads/investments/zielone-tarasy/cover.jpg', '2026-03-27 09:00:00', 1),
  ('villa-park-etap-1', 'Villa Park Etap 1', 'Kraków, Podgórze', 'Kameralne osiedle domów jednorodzinnych.', 'Etap 1 obejmuje 24 lokale o podwyższonym standardzie wykończenia.', 'W sprzedaży', '/uploads/investments/villa-park-etap-1/cover.jpg', '2026-03-27 09:15:00', 1),
  ('domy-przy-lesie', 'Domy przy Lesie', 'Gdańsk, Kokoszki', 'Osiedle domów przy terenach rekreacyjnych.', 'Projekt nastawiony na komfort rodzin i szybki dojazd do centrum.', 'Przedsprzedaż', '/uploads/investments/domy-przy-lesie/cover.jpg', '2026-03-27 09:30:00', 1),
  ('nova-przystan', 'Nova Przystań', 'Wrocław, Psie Pole', 'Zabudowa bliźniacza z dużymi ogrodami.', 'Inwestycja łączy nowoczesną architekturę z funkcjonalnymi układami wnętrz.', 'Zakończona', '/uploads/investments/nova-przystan/cover.jpg', '2026-03-27 09:45:00', 1),
  ('osiedle-sloneczne', 'Osiedle Słoneczne', 'Poznań, Naramowice', 'Domy w spokojnej części miasta.', 'Osiedle z pełną infrastrukturą usługową i szybkim dostępem do komunikacji.', 'W sprzedaży', '/uploads/investments/osiedle-sloneczne/cover.jpg', '2026-03-27 10:00:00', 1)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  location = VALUES(location),
  description_short = VALUES(description_short),
  description_long = VALUES(description_long),
  status = VALUES(status),
  cover_image = VALUES(cover_image),
  published_at = VALUES(published_at),
  is_published = VALUES(is_published);

DELETE iu
FROM investment_units iu
JOIN investments i ON i.id = iu.investment_id
WHERE i.slug IN (
  'osiedle-zielone-tarasy',
  'villa-park-etap-1',
  'domy-przy-lesie',
  'nova-przystan',
  'osiedle-sloneczne'
);

INSERT INTO investment_units (investment_id, unit_name, unit_number, area_m2, rooms, price, status, floorplan_file)
SELECT i.id, 'Dom A1', 'A1', 124.50, 5, 995000.00, 'Dostępny', CONCAT('/uploads/investments/', i.slug, '/floorplans/a1.pdf')
FROM investments i WHERE i.slug = 'osiedle-zielone-tarasy'
UNION ALL
SELECT i.id, 'Dom A2', 'A2', 126.00, 5, 1025000.00, 'Rezerwacja', CONCAT('/uploads/investments/', i.slug, '/floorplans/a2.pdf')
FROM investments i WHERE i.slug = 'osiedle-zielone-tarasy'
UNION ALL
SELECT i.id, 'Dom B1', 'B1', 132.40, 6, 1210000.00, 'Dostępny', CONCAT('/uploads/investments/', i.slug, '/floorplans/b1.pdf')
FROM investments i WHERE i.slug = 'villa-park-etap-1'
UNION ALL
SELECT i.id, 'Dom B2', 'B2', 130.10, 6, 1190000.00, 'Sprzedany', CONCAT('/uploads/investments/', i.slug, '/floorplans/b2.pdf')
FROM investments i WHERE i.slug = 'villa-park-etap-1'
UNION ALL
SELECT i.id, 'Dom C1', 'C1', 118.20, 5, 915000.00, 'Dostępny', CONCAT('/uploads/investments/', i.slug, '/floorplans/c1.pdf')
FROM investments i WHERE i.slug = 'domy-przy-lesie'
UNION ALL
SELECT i.id, 'Dom C2', 'C2', 120.00, 5, 945000.00, 'Rezerwacja', CONCAT('/uploads/investments/', i.slug, '/floorplans/c2.pdf')
FROM investments i WHERE i.slug = 'domy-przy-lesie'
UNION ALL
SELECT i.id, 'Dom D1', 'D1', 140.00, 6, 1290000.00, 'Sprzedany', CONCAT('/uploads/investments/', i.slug, '/floorplans/d1.pdf')
FROM investments i WHERE i.slug = 'nova-przystan'
UNION ALL
SELECT i.id, 'Dom D2', 'D2', 138.50, 6, 1275000.00, 'Rezerwacja', CONCAT('/uploads/investments/', i.slug, '/floorplans/d2.pdf')
FROM investments i WHERE i.slug = 'nova-przystan'
UNION ALL
SELECT i.id, 'Dom E1', 'E1', 112.00, 4, 865000.00, 'Dostępny', CONCAT('/uploads/investments/', i.slug, '/floorplans/e1.pdf')
FROM investments i WHERE i.slug = 'osiedle-sloneczne'
UNION ALL
SELECT i.id, 'Dom E2', 'E2', 115.00, 4, 895000.00, 'Sprzedany', CONCAT('/uploads/investments/', i.slug, '/floorplans/e2.pdf')
FROM investments i WHERE i.slug = 'osiedle-sloneczne';

DELETE inf
FROM investment_files inf
JOIN investments i ON i.id = inf.investment_id
WHERE i.slug IN (
  'osiedle-zielone-tarasy',
  'villa-park-etap-1',
  'domy-przy-lesie',
  'nova-przystan',
  'osiedle-sloneczne'
);

INSERT INTO investment_files (investment_id, title, file_path, file_type, published_at, sort_order, is_active)
SELECT id, 'Prospekt informacyjny', CONCAT('/uploads/investments/', slug, '/files/prospekt.pdf'), 'pdf', '2026-03-27 10:10:00', 1, 1
FROM investments
WHERE slug IN (
  'osiedle-zielone-tarasy',
  'villa-park-etap-1',
  'domy-przy-lesie',
  'nova-przystan',
  'osiedle-sloneczne'
);

DELETE ig
FROM investment_gallery ig
JOIN investments i ON i.id = ig.investment_id
WHERE i.slug IN (
  'osiedle-zielone-tarasy',
  'villa-park-etap-1',
  'domy-przy-lesie',
  'nova-przystan',
  'osiedle-sloneczne'
);

INSERT INTO investment_gallery (investment_id, image_path, alt_text, sort_order, is_active)
SELECT id, CONCAT('/uploads/investments/', slug, '/gallery/01.jpg'), CONCAT(name, ' - wizualizacja 1'), 1, 1
FROM investments
WHERE slug IN (
  'osiedle-zielone-tarasy',
  'villa-park-etap-1',
  'domy-przy-lesie',
  'nova-przystan',
  'osiedle-sloneczne'
)
UNION ALL
SELECT id, CONCAT('/uploads/investments/', slug, '/gallery/02.jpg'), CONCAT(name, ' - wizualizacja 2'), 2, 1
FROM investments
WHERE slug IN (
  'osiedle-zielone-tarasy',
  'villa-park-etap-1',
  'domy-przy-lesie',
  'nova-przystan',
  'osiedle-sloneczne'
);

COMMIT;
