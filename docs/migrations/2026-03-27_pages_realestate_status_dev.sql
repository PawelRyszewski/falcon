-- DEV: dodanie statusu nieruchomości do tabeli pages
-- 0 = w realizacji, 1 = zakończona/sprzedana

ALTER TABLE `pages`
  ADD COLUMN IF NOT EXISTS `realestate_status` TINYINT NOT NULL DEFAULT 0
  COMMENT '0 = w realizacji, 1 = zakończona/sprzedana'
  AFTER `type`;
