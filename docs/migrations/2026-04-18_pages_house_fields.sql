-- Dodanie pól domu per nieruchomość: status dostępności, powierzchnia działki/użytkowa, cena
-- Wyświetlane w tabeli "Lista domów" na stronie kategorii inwestycji

ALTER TABLE `pages`
  ADD COLUMN IF NOT EXISTS `house_status` VARCHAR(20) NOT NULL DEFAULT 'wolne'
    COMMENT 'wolne/rezerwacja/niedostepne'
    AFTER `realestate_status`,
  ADD COLUMN IF NOT EXISTS `plot_area` VARCHAR(100) NOT NULL DEFAULT ''
    COMMENT 'Powierzchnia dzialki (np. 600 m2)'
    AFTER `house_status`,
  ADD COLUMN IF NOT EXISTS `usable_area` VARCHAR(100) NOT NULL DEFAULT ''
    COMMENT 'Powierzchnia uzytkowa (np. 182,81 m2)'
    AFTER `plot_area`,
  ADD COLUMN IF NOT EXISTS `house_price` VARCHAR(100) NOT NULL DEFAULT ''
    COMMENT 'Cena (np. 2 350 000 zl)'
    AFTER `usable_area`;
