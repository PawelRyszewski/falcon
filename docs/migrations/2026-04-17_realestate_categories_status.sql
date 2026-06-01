-- Dodanie statusu osiedla w słowniku realestate_categories
-- 0 = W realizacji, 1 = Zrealizowano

ALTER TABLE `realestate_categories`
  ADD COLUMN IF NOT EXISTS `status` TINYINT NOT NULL DEFAULT 0
  COMMENT '0 = W realizacji, 1 = Zrealizowano'
  AFTER `name`;

