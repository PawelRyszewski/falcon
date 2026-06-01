<?php

if (!function_exists('realestate_category_slugify')) {
    function realestate_category_slugify($value)
    {
        $value = trim((string) $value);
        if ($value === '') {
            return '';
        }

        $polishChars = [
            'ą' => 'a', 'ć' => 'c', 'ę' => 'e', 'ł' => 'l', 'ń' => 'n', 'ó' => 'o', 'ś' => 's', 'ż' => 'z', 'ź' => 'z',
            'Ą' => 'a', 'Ć' => 'c', 'Ę' => 'e', 'Ł' => 'l', 'Ń' => 'n', 'Ó' => 'o', 'Ś' => 's', 'Ż' => 'z', 'Ź' => 'z',
        ];

        $slug = strtr($value, $polishChars);
        $slug = strtolower($slug);
        $slug = preg_replace('/[^a-z0-9]+/', '-', $slug);
        $slug = trim((string) $slug, '-');

        return $slug;
    }
}

if (!function_exists('realestate_categories_table_exists')) {
    function realestate_categories_table_exists()
    {
        static $tableExists = null;

        if ($tableExists !== null) {
            return $tableExists;
        }

        $tableCheck = DatabaseManager::selectSql(
            "SELECT COUNT(*) as qty FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'realestate_categories' LIMIT 1"
        );

        $tableExists = !empty($tableCheck[0]['qty']);

        return $tableExists;
    }
}

if (!function_exists('realestate_category_find_by_slug')) {
    function realestate_category_find_by_slug($slug)
    {
        $slug = trim((string) $slug);
        if ($slug === '') {
            return null;
        }

        if (!realestate_categories_table_exists()) {
            error_log('[SCHEMA WARNING] Missing realestate_categories table. Skipping slug lookup in realestate_category_find_by_slug().');
            return null;
        }

        $categories = DatabaseManager::selectSql(
            "SELECT `id`, `name`
            FROM `realestate_categories`
            ORDER BY `queue` ASC, `id` DESC"
        );

        foreach ($categories as $category) {
            if (realestate_category_slugify($category['name']) === $slug) {
                return $category;
            }
        }

        return null;
    }
}