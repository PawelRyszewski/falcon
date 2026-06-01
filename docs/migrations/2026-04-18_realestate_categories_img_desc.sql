-- Dodanie grafiki banera i opisu do kategorii nieruchomości
-- img: FK images.id - baner wyswietlany na stronie kategorii zamiast slidera
-- description: opis kategorii wyswietlany pod grafiką

ALTER TABLE `realestate_categories`
  ADD COLUMN IF NOT EXISTS `img` INT DEFAULT NULL
    COMMENT 'FK images.id - baner kategorii (z galerii)'
    AFTER `status`,
  ADD COLUMN IF NOT EXISTS `description` TEXT DEFAULT NULL
    COMMENT 'Opis kategorii wyswietlany na stronie /inwestycje/{slug}'
    AFTER `img`;
