<?php

if (!function_exists('realestate_db_name')) {
    function realestate_db_name()
    {
        static $resolvedDbName = null;

        if ($resolvedDbName !== null) {
            return $resolvedDbName;
        }

        $envDbName = (string) getenv('DB_NAME');
        if ($envDbName !== '') {
            $resolvedDbName = $envDbName;
            return $resolvedDbName;
        }

        $currentDb = DatabaseManager::selectSql('SELECT DATABASE() AS db_name LIMIT 1');
        $resolvedDbName = !empty($currentDb[0]['db_name']) ? (string) $currentDb[0]['db_name'] : '';

        return $resolvedDbName;
    }
}

if (!function_exists('realestate_table_exists')) {
    function realestate_table_exists($tableName)
    {
        $dbName = realestate_db_name();
        if ($dbName === '') {
            return false;
        }

        $dbNameSafe = addslashes($dbName);
        $tableSafe = addslashes($tableName);
        $result = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = '{$tableSafe}' LIMIT 1");

        return !empty($result[0]['qty']);
    }
}

if (!function_exists('realestate_column_exists')) {
    function realestate_column_exists($tableName, $columnName)
    {
        $dbName = realestate_db_name();
        if ($dbName === '') {
            return false;
        }

        $dbNameSafe = addslashes($dbName);
        $tableSafe = addslashes($tableName);
        $columnSafe = addslashes($columnName);
        $result = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = '{$tableSafe}' AND COLUMN_NAME = '{$columnSafe}' LIMIT 1");

        return !empty($result[0]['qty']);
    }
}

if (!function_exists('realestate_ensure_category_status_column')) {
    function realestate_ensure_category_status_column()
    {
        if (!realestate_table_exists('realestate_categories')) {
            return false;
        }

        if (realestate_column_exists('realestate_categories', 'status')) {
            return true;
        }

        try {
            $pdo = DatabaseManager::getConnection();
            $pdo->exec("
                ALTER TABLE `realestate_categories`
                ADD COLUMN `status` TINYINT NOT NULL DEFAULT 0
                COMMENT '0 = W realizacji, 1 = Zrealizowano'
                AFTER `name`
            ");
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się dodać kolumny realestate_categories.status: ' . $e->getMessage());
        }

        return realestate_column_exists('realestate_categories', 'status');
    }
}

if (!function_exists('realestate_ensure_category_img_desc_columns')) {
    function realestate_ensure_category_img_desc_columns()
    {
        if (!realestate_table_exists('realestate_categories')) {
            return false;
        }

        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_column_exists('realestate_categories', 'img')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `img` INT DEFAULT NULL COMMENT 'FK images.id - baner kategorii' AFTER `status`");
            }
            if (!realestate_column_exists('realestate_categories', 'description')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `description` TEXT DEFAULT NULL COMMENT 'Opis kategorii wyswietlany na stronie /inwestycje/{slug}' AFTER `img`");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się dodać kolumn img/description do realestate_categories: ' . $e->getMessage());
        }

        return true;
    }
}

if (!function_exists('realestate_ensure_category_seo_columns')) {
    function realestate_ensure_category_seo_columns()
    {
        if (!realestate_table_exists('realestate_categories')) {
            return false;
        }

        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_column_exists('realestate_categories', 'title_seo')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `title_seo` VARCHAR(255) DEFAULT NULL AFTER `description`");
            }
            if (!realestate_column_exists('realestate_categories', 'meta_description')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `meta_description` VARCHAR(500) DEFAULT NULL AFTER `title_seo`");
            }
            if (!realestate_column_exists('realestate_categories', 'keywords')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `keywords` VARCHAR(255) DEFAULT NULL AFTER `meta_description`");
            }
            if (!realestate_column_exists('realestate_categories', 'url')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `url` VARCHAR(255) DEFAULT NULL AFTER `keywords`");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się dodać kolumn SEO do realestate_categories: ' . $e->getMessage());
        }

        return true;
    }
}

if (!function_exists('realestate_ensure_category_homepage_columns')) {
    function realestate_ensure_category_homepage_columns()
    {
        if (!realestate_table_exists('realestate_categories')) {
            return false;
        }

        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_column_exists('realestate_categories', 'homepage_img')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `homepage_img` INT DEFAULT NULL COMMENT 'FK images.id - zdjecie kategorii na stronie glownej' AFTER `url`");
            }
            if (!realestate_column_exists('realestate_categories', 'homepage_title')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `homepage_title` VARCHAR(255) DEFAULT NULL COMMENT 'Tytul kategorii na stronie glownej' AFTER `homepage_img`");
            }
            if (!realestate_column_exists('realestate_categories', 'homepage_subtitle')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `homepage_subtitle` VARCHAR(255) DEFAULT NULL COMMENT 'Podtytul kategorii na stronie glownej' AFTER `homepage_title`");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się dodać kolumn homepage do realestate_categories: ' . $e->getMessage());
        }

        return true;
    }
}

if (!function_exists('realestate_ensure_category_menu_name_column')) {
    function realestate_ensure_category_menu_name_column()
    {
        if (!realestate_table_exists('realestate_categories')) {
            return false;
        }
        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_column_exists('realestate_categories', 'menu_name')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `menu_name` VARCHAR(255) DEFAULT NULL COMMENT 'Nazwa w menu (jeśli pusta – używana jest nazwa kategorii)' AFTER `name`");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się dodać kolumny menu_name do realestate_categories: ' . $e->getMessage());
        }
        return true;
    }
}

if (!function_exists('realestate_ensure_images_hide_from_slider')) {
    function realestate_ensure_images_hide_from_slider()
    {
        if (!realestate_table_exists('images')) return false;
        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_column_exists('images', 'hide_from_slider')) {
                $pdo->exec("ALTER TABLE `images` ADD COLUMN `hide_from_slider` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Ukryj zdjęcie w sliderze nieruchomości' AFTER `queue`");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA] images.hide_from_slider: ' . $e->getMessage());
        }
        return true;
    }
}

if (!function_exists('realestate_drop_investment_files_fk')) {
    function realestate_drop_investment_files_fk()
    {
        if (!realestate_table_exists('investment_files')) {
            return false;
        }

        $dbName = realestate_db_name();
        if ($dbName === '') {
            return false;
        }

        $dbNameSafe = addslashes($dbName);
        $fkExists = DatabaseManager::selectSql("SELECT COUNT(*) as qty FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = '{$dbNameSafe}' AND TABLE_NAME = 'investment_files' AND CONSTRAINT_NAME = 'fk_investment_files_investment' AND CONSTRAINT_TYPE = 'FOREIGN KEY' LIMIT 1");

        if (empty($fkExists[0]['qty'])) {
            return true;
        }

        try {
            $pdo = DatabaseManager::getConnection();
            $pdo->exec("ALTER TABLE `investment_files` DROP FOREIGN KEY `fk_investment_files_investment`");
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się usunąć FK investment_files: ' . $e->getMessage());
            return false;
        }

        return true;
    }
}

if (!function_exists('realestate_ensure_category_icons_table')) {
    function realestate_ensure_category_icons_table()
    {
        if (!realestate_table_exists('realestate_categories')) return false;
        try {
            $pdo = DatabaseManager::getConnection();
            $pdo->exec("CREATE TABLE IF NOT EXISTS `realestate_category_icons` (
                `id` INT NOT NULL AUTO_INCREMENT,
                `category_id` INT NOT NULL,
                `image_id` INT NOT NULL,
                `description` VARCHAR(255) DEFAULT NULL,
                `sort_order` INT NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                KEY `idx_rci_category` (`category_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        } catch (Exception $e) {
            error_log('[SCHEMA] realestate_category_icons: ' . $e->getMessage());
        }
        return true;
    }
}

if (!function_exists('realestate_ensure_category_map_columns')) {
    function realestate_ensure_category_map_columns()
    {
        if (!realestate_table_exists('realestate_categories')) {
            return false;
        }
        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_column_exists('realestate_categories', 'map_lat')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `map_lat` DECIMAL(10,7) DEFAULT NULL COMMENT 'Szerokość geograficzna pinezki na mapie' AFTER `homepage_subtitle`");
            }
            if (!realestate_column_exists('realestate_categories', 'map_lng')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `map_lng` DECIMAL(10,7) DEFAULT NULL COMMENT 'Długość geograficzna pinezki na mapie' AFTER `map_lat`");
            }
            if (!realestate_column_exists('realestate_categories', 'map_zoom')) {
                $pdo->exec("ALTER TABLE `realestate_categories` ADD COLUMN `map_zoom` TINYINT UNSIGNED NOT NULL DEFAULT 15 COMMENT 'Poziom powiększenia mapy (1-20)' AFTER `map_lng`");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się dodać kolumn map_lat/map_lng/map_zoom do realestate_categories: ' . $e->getMessage());
        }
        return true;
    }
}

if (!function_exists('realestate_ensure_homepage_slider_table')) {
    function realestate_ensure_homepage_slider_table()
    {
        try {
            $pdo = DatabaseManager::getConnection();
            $pdo->exec("CREATE TABLE IF NOT EXISTS `homepage_slider_slides` (
                `id` INT NOT NULL AUTO_INCREMENT,
                `category_id` INT NOT NULL,
                `image_id` INT DEFAULT NULL,
                `slide_order` INT NOT NULL DEFAULT 0,
                `text_p1` VARCHAR(255) DEFAULT NULL,
                `text_p2` VARCHAR(255) DEFAULT NULL,
                `text_p3` VARCHAR(255) DEFAULT NULL COMMENT 'Tekst przycisku',
                PRIMARY KEY (`id`),
                KEY `idx_hss_category` (`category_id`),
                KEY `idx_hss_order` (`slide_order`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        } catch (Exception $e) {
            error_log('[SCHEMA] homepage_slider_slides: ' . $e->getMessage());
        }
        return true;
    }
}

if (!function_exists('realestate_ensure_category_svg_map_table')) {
    function realestate_ensure_category_svg_map_table()
    {
        try {
            $pdo = DatabaseManager::getConnection();
            $pdo->exec("CREATE TABLE IF NOT EXISTS `realestate_category_svg_maps` (
                `id` INT NOT NULL AUTO_INCREMENT,
                `category_id` INT NOT NULL,
                `image_id` INT DEFAULT NULL,
                `image_name` VARCHAR(255) DEFAULT NULL,
                `image_width` INT DEFAULT NULL,
                `image_height` INT DEFAULT NULL,
                `shapes` MEDIUMTEXT DEFAULT NULL COMMENT 'JSON array of shape data',
                `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`),
                UNIQUE KEY `uk_rcsm_category` (`category_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        } catch (Exception $e) {
            error_log('[SCHEMA] realestate_category_svg_maps: ' . $e->getMessage());
        }
        return true;
    }
}

if (!function_exists('realestate_ensure_floor_columns')) {
    function realestate_ensure_floor_columns()
    {
        if (!realestate_table_exists('pages')) {
            return false;
        }

        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_column_exists('pages', 'has_parter')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `has_parter` TINYINT NOT NULL DEFAULT 0 COMMENT 'Czy pokazac sekcje Parter' AFTER `content`");
            }
            if (!realestate_column_exists('pages', 'parter_img_id')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `parter_img_id` INT DEFAULT NULL COMMENT 'FK images.id - zdjecie parteru' AFTER `has_parter`");
            }
            if (!realestate_column_exists('pages', 'parter_content')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `parter_content` TEXT DEFAULT NULL COMMENT 'HTML tresc sekcji Parter' AFTER `parter_img_id`");
            }
            if (!realestate_column_exists('pages', 'has_pietro')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `has_pietro` TINYINT NOT NULL DEFAULT 0 COMMENT 'Czy pokazac sekcje Pietro' AFTER `parter_content`");
            }
            if (!realestate_column_exists('pages', 'pietro_img_id')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `pietro_img_id` INT DEFAULT NULL COMMENT 'FK images.id - zdjecie pietra' AFTER `has_pietro`");
            }
            if (!realestate_column_exists('pages', 'pietro_content')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `pietro_content` TEXT DEFAULT NULL COMMENT 'HTML tresc sekcji Pietro' AFTER `pietro_img_id`");
            }
            if (!realestate_column_exists('pages', 'has_poddasze')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `has_poddasze` TINYINT NOT NULL DEFAULT 0 COMMENT 'Czy pokazac sekcje Poddasze' AFTER `pietro_content`");
            }
            if (!realestate_column_exists('pages', 'poddasze_img_id')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `poddasze_img_id` INT DEFAULT NULL COMMENT 'FK images.id - zdjecie poddasza' AFTER `has_poddasze`");
            }
            if (!realestate_column_exists('pages', 'poddasze_content')) {
                $pdo->exec("ALTER TABLE `pages` ADD COLUMN `poddasze_content` TEXT DEFAULT NULL COMMENT 'HTML tresc sekcji Poddasze' AFTER `poddasze_img_id`");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się dodać kolumn floor do pages: ' . $e->getMessage());
        }

        return true;
    }
}

if (!function_exists('realestate_ensure_homepage_section_settings_table')) {
    function realestate_ensure_homepage_section_settings_table()
    {
        try {
            $pdo = DatabaseManager::getConnection();
            if (!realestate_table_exists('realestate_homepage_section_settings')) {
                $pdo->exec(
                    "CREATE TABLE `realestate_homepage_section_settings` (".
                    "`status` TINYINT NOT NULL PRIMARY KEY COMMENT '0 = W realizacji, 1 = Zrealizowano',".
                    "`first_side` ENUM('left','right') NOT NULL DEFAULT 'left' COMMENT 'Strona zdjecia pierwszego rekordu na stronie glownej'".
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8"
                );
                $pdo->exec("INSERT INTO `realestate_homepage_section_settings` (`status`, `first_side`) VALUES (0, 'left'), (1, 'left')");
            }
        } catch (Exception $e) {
            error_log('[SCHEMA WARNING] Nie udało się utworzyć tabeli realestate_homepage_section_settings: ' . $e->getMessage());
            return false;
        }

        return true;
    }
}
