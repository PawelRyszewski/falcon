-- Dodanie tabeli kategorii nieruchomości dla modułu /admin/nieruchomosci

CREATE TABLE IF NOT EXISTS `realestate_categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '0 = W realizacji, 1 = Zrealizowano',
  `queue` INT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_realestate_categories_queue` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
