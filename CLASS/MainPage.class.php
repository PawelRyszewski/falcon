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
            require_once 'container_start.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }


        if ($path === 'eng' || $path === 'eng/12003') {
            require_once 'head_global.lib.php';
            require_once 'container_subpage.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        if (strpos($path, 'start') === 0) {
            require_once 'head_global.lib.php';
            require_once '404.lib.php';
            require_once 'footer_global.lib.php';
            return;
        }

        require_once 'head_global.lib.php';
        require_once 'container_subpage.lib.php';
        require_once 'footer_global.lib.php';
    }
}
