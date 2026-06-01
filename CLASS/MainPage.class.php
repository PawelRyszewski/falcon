<?php
class MainPage
{
    public function __construct($active_page_ctr, $active_page_par2, $active_page_par3 = false)
    {
        $path = $active_page_ctr . ($active_page_par2 ? "/" . $active_page_par2 : "");
        $path = $path . ($active_page_par3 ? "/" . $active_page_par3 : "");

        if ($path === 'pl') {
            require_once 'redirect.lib.php';
            return;
        }

        if ($path === 'start') {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'container_start.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if ($path === 'inwestycje') {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'nieruchomosci.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if (strpos($path, 'inwestycje/') === 0 && $active_page_par2) {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'wybrana_nieruchomosc.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if ($path === 'developer') {
			require_once 'head_global.lib.php';
			require_once 'menu_global.lib.php';
			require_once 'container_subpage.lib.php';
			require_once 'footer_global.lib.php';
            return;
        }

        if ($path === 'kontakt' || $path === 'kontakt/27') {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'container_kontakt.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if ($path === 'blog' || (strpos($path, 'blog/') === 0 && !$active_page_par3)) {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'container_aktualnosci.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if (strpos($path, 'blog/') === 0 && $active_page_par3) {
            require_once 'head_subpage.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'container_aktualnosc.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if ($path === 'categories') {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'container_categories.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if ($path === 'ranking-ai') {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'container_ranking.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if (strpos($path, 'model/') === 0) {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once 'container_model.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if ($path === 'ai-materials/pages_import.php') {
            require_once __DIR__ . '/../ai-materials/pages_import.php';
            return;
        }

        if ($path === 'ai-materials/uploads/') {
            require_once __DIR__ . '/../ai-materials/uploads/';
            return;
        }

        if (strpos($path, 'start') === 0) {
            require_once 'head_global.lib.php';
            require_once 'menu_global.lib.php';
            require_once '404.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        require_once 'head_global.lib.php';
        require_once 'menu_global.lib.php';
        require_once 'container_subpage.lib.php';
        require_once 'footer_global.lib.php';
    }
}
