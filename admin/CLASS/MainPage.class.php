<?php
class MainPage
{

    private $active_page;
    public function __construct($active_page_ctr, $active_page_par2)
    {
        $path = $active_page_ctr . ($active_page_par2 ? "/" . $active_page_par2 : "");

        if (isset($_SESSION['logged_in'])) {
            require_once 'head.lib.php';
            // require_once 'menu.lib.php';

            switch ($path) {
                case 'start':
                    require_once 'start.lib.php';
                    break;
                case 'podstrony':
                    require_once 'podstrony.lib.php';
                    break;
                case 'podstrony/edytuj':
                    require_once 'podstrony-edytuj.lib.php';
                    break;
                case 'podstrony/dodaj':
                    require_once 'podstrony-dodaj.lib.php';
                    break;
                case 'podstrony/usun':
                    require_once 'podstrony-usun.lib.php';
                    break;
                case 'podstrony/duplikuj':
                    require_once 'podstrony-duplikuj.lib.php';
                    break;
                case "podstrony/kategorie":
                    require_once 'podstrony-kategorie.lib.php';
                    break;
                case "podstrony/kategorie-edytuj":
                    require_once 'podstrony-kategorie-edytuj.lib.php';
                    break;
                case "podstrony/kategorie-usun":
                    require_once 'podstrony-kategorie-usun.lib.php';
                    break;
                case 'jezyki':
                    require_once 'jezyki.lib.php';
                    break;
                case 'jezyki-edytuj':
                    require_once 'jezyki-edytuj.lib.php';
                    break;
                case 'jezyki-usun':
                    require_once 'jezyki-usun.lib.php';
                    break;
                case 'uzytkownicy':
                    require_once 'uzytkownicy.lib.php';
                    break;
                case 'uzytkownicy/dodaj':
                    require_once 'uzytkownicy-dodaj.lib.php';
                    break;
                case 'uzytkownicy/edytuj':
                    require_once 'uzytkownicy-edytuj.lib.php';
                    break;
                case 'uzytkownicy/usun':
                    require_once 'uzytkownicy-usun.lib.php';
                    break;
                case 'newsletter':
                    require_once 'newsletter.lib.php';
                    break;
                case 'newsletter/usun':
                    require_once 'newsletter-usun.lib.php';
                    break;
                case 'newsletter/templates':
                    require_once 'newsletter-templates.lib.php';
                    break;
                case 'newsletter/templates-dodaj':
                    require_once 'newsletter-templates-dodaj.lib.php';
                    break;
                case 'newsletter/templates-usun':
                    require_once 'newsletter-templates-usun.lib.php';
                    break;
                case 'newsletter/templates-edytuj':
                    require_once 'newsletter-templates-edytuj.lib.php';
                    break;
                case 'newsletter/templates-duplikuj':
                    require_once 'newsletter-templates-duplikuj.lib.php';
                    break;
                case 'newsletter/emails':
                    require_once 'newsletter-emails.lib.php';
                    break;
                case 'aktualnosci':
                    require_once 'aktualnosci.lib.php';
                    break;
                case 'aktualnosci/dodaj':
                    require_once 'aktualnosci-dodaj.lib.php';
                    break;
                case 'aktualnosci/edytuj':
                    require_once 'aktualnosci-edytuj.lib.php';
                    break;
                case 'aktualnosci/usun':
                    require_once 'aktualnosci-usun.lib.php';
                    break;
                case 'aktualnosci/duplikuj':
                    require_once 'aktualnosci-duplikuj.lib.php';
                    break;
                case 'ai-models':
                    require_once 'ai-models.lib.php';
                    break;
                case 'ai-models/edytuj':
                    require_once 'ai-models-edytuj.lib.php';
                    break;
                case 'ai-models/usun':
                    require_once 'ai-models-usun.lib.php';
                    break;		
                case 'api-settings':
                    require_once 'api-settings.lib.php';
                    break;					
                case 'categories':
                    require_once 'categories.lib.php';
                    break;
                case 'categories/edytuj':
                    require_once 'categories-edytuj.lib.php';
                    break;
                case 'categories/usun':
                    require_once 'categories-usun.lib.php';
                    break;
                case 'categories/przeladuj-json':
                    require_once 'categories-przeladuj-json.lib.php';
                    break;
                case 'votes':
                    require_once 'votes.lib.php';
                    break;					
                case 'poczta':
                    require_once 'poczta.lib.php';
                    break;
                case 'galeria-zdjec':
                    require_once 'galeria.lib.php';
                    break;
                case 'galeria-zdjec/dodaj':
                    require_once 'galeria-dodaj.lib.php';
                    break;
                case 'galeria-zdjec/edytuj':
                    require_once 'galeria-edytuj.lib.php';
                    break;
                case 'galeria-zdjec/usun':
                    require_once 'galeria-usun.lib.php';
                    break;
                case "aktualnosci/kategorie":
                    require_once 'aktualnosci-kategorie.lib.php';
                    break;
                case "aktualnosci/kategorie-usun":
                    require_once 'aktualnosci-kategorie-usun.lib.php';
                    break;
                case "aktualnosci/kategorie-edytuj":
                    require_once 'aktualnosci-kategorie-edytuj.lib.php';
                    break;
                case "podstrony/kolejnosc-w-menu":
                    require_once 'podstrony-kolejnosc-w-menu.lib.php';
                    break;
					
                    /* Nieruchomosci z Galeria */
                case 'nieruchomosci':
                    require_once 'nieruchomosci.lib.php';
                    break;
                case 'nieruchomosci/dodaj':
                    require_once 'nieruchomosci-dodaj.lib.php';
                    break;
                case 'nieruchomosci/edytuj':
                    require_once 'nieruchomosci-edytuj.lib.php';
                    break;
                case 'nieruchomosci/usun':
                    require_once 'nieruchomosci-usun.lib.php';
                    break;
                case 'nieruchomosci/kopiuj':
                    require_once 'nieruchomosci-kopiuj.lib.php';
                    break;
                case 'nieruchomosci/kategorie':
                    require_once 'nieruchomosci-kategorie.lib.php';
                    break;
                case 'nieruchomosci/kategorie-edytuj':
                    require_once 'nieruchomosci-kategorie-edytuj.lib.php';
                    break;
                case 'nieruchomosci/kategorie-usun':
                    require_once 'nieruchomosci-kategorie-usun.lib.php';
                    break;
            }

            require_once 'footer.lib.php';
        } else {
            require_once 'head-login.lib.php';
            require_once 'menu.lib.php';
            switch ($active_page_ctr) {
                case 'przypomnij-haslo':
                    require_once 'przypomnij-haslo.lib.php';
                    break;
                case 'zmien-haslo':
                    require_once 'zmien-haslo.lib.php';
                    break;
                default:
                    require_once 'login.lib.php';
                    break;
            }
        }
    }
}
