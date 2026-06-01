<!DOCTYPE html>
<html lang="pl">
<head>
	{literal}

	{/literal}
	
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
	<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;700;800&family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	
	{literal}
		<style>
		/* COOKIES */
		#cookies-info {
			position: fixed !important;
			width: 100% !important;
			z-index: 10 !important;
			bottom: -10px !important;
			padding: 25px !important;
			left: 0px !important;
			background: #efefef !important;
			-webkit-box-shadow: 0px 0px 27px -10px rgb(168 168 173) !important;
			-moz-box-shadow: 0px 0px 27px -10px rgba(168, 168, 173, 1) !important;
			box-shadow: 0px 0px 27px -10px rgb(168 168 173) !important;
		}

		#cookies-info p {
			font-size:10px !important;
			margin-bottom:5px !important;
		}

		#cookies-info .btn {
			-webkit-box-shadow: 0px 0px 7px -2px rgba(168, 168, 173, 1) !important;
			-moz-box-shadow: 0px 0px 7px -2px rgba(168, 168, 173, 1) !important;
			box-shadow: 0px 0px 7px -2px rgba(168, 168, 173, 1) !important;
			-webkit-transition: ease-in-out 0.3s !important;
			-moz-transition: ease-in-out 0.3 !important;
			-o-transition: ease-in-out 0.3 !important;
			transition: ease-in-out 0.3 !important;
			font-size:12px !important;
		}

		#cookies-info .btn-success {
			background:#3AAF34 !important;
			color:#fff !important;
		}
		#cookies-info .btn-warning {
			background:#ffc107 !important;
			color:#000 !important;
		}
		#cookies-info .btn-info {
			background:#0dcaf0 !important;
			color:#000 !important;
		}

		#cookies-info .btn-success:hover {
			background:#095a35 !important;
			color:#fff !important;
		}
		#cookies-info .btn-warning:hover {
			background:#ad8719 !important;
			color:#fff !important;
		}
		#cookies-info .btn-info:hover {
			background:#0d859d !important;
			color:#fff !important;
		}

		@media (max-width:991px){
			#cookies-info .btn {
			width:100% !important;
			margin-bottom:10px !important;
			}
		}
		</style>
	{/literal}	

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$title_seo}</title>
    <meta name="description" content="{$description}">
    <meta name="keywords" content="{$keywords}">
    {if isset($canonical_url)}<link rel="canonical" href="{$canonical_url}">{/if}
    {if isset($prev_url)}<link rel="prev" href="{$prev_url}">{/if}
    {if isset($next_url)}<link rel="next" href="{$next_url}">{/if}
 
	<link rel="apple-touch-icon" sizes="57x57" href="/utils/images/favicon/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="/utils/images/favicon/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="/utils/images/favicon/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="/utils/images/favicon/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="/utils/images/favicon/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="/utils/images/favicon/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="/utils/images/favicon/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="/utils/images/favicon/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="/utils/images/favicon/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="/utils/images/favicon/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/utils/images/favicon/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="/utils/images/favicon/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/utils/images/favicon/favicon-16x16.png">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="/utils/images/favicon/ms-icon-144x144.png">
	<meta name="theme-color" content="#ffffff">

    <link rel="stylesheet" href="/utils/css/bootstrap-reboot.min.css" >
    <link rel="stylesheet" href="/utils/css/bootstrap.min.css" >
	<link rel="stylesheet" href="/utils/css/style-min.css">	
	<link rel="stylesheet" href="/utils/css/wow-ksef.css">
	<link rel="stylesheet" href="/utils/css/aos.css">	
	
	<script src="/utils/js/jquery.js"></script>
	<script src="/utils/js/aos.js"></script>
    <script defer src="/utils/js/functions.js"></script>	
	<script defer src="/utils/js/bootstrap.bundle.min.js"></script>	
</head>
<body>
{*<div class="back-to-top"></div>*}
<div id="cookies-info" style="display: none;">
	<p>
		program-do-ksef.pl używa plików cookies, potocznie zwanych ciasteczkami. Ciasteczka przechowywane są w Twoim urządzeniu i znacznie ułatwiają korzystanie z strony internetowej.<br>

		<strong>Pliki cookies wykorzystujemy np. w celu:</strong><br>
		- dostosowania zawartości serwisu ze stronami www do Twoich preferencji (ciasteczka zapamiętują konfigurację),<br>
		- utrzymywania sesji po zalogowaniu do strony internetowej Siloflex.pl (dzięki czemu m.in. nie musisz na każdej podstronie serwisu ponownie wpisywać loginu i hasła),<br>
	</p>
	<a href="javascript:closeCookiesInfo();" class="btn btn-success btn-sm px-3">Akceptuję wszystkie ciasteczka</a>
	<a href="javascript:closeCookiesInfo();" class="btn btn-warning btn-sm px-3">Akceptuję tylko wymagane ciasteczka</a>
	<a href="/polityka-prywatnosci" class="btn btn-info btn-sm px-3" title="Polityka prywatności serwisu program-do-ksef.pl" >Czytaj więcej</a>
</div>