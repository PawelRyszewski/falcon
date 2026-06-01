<!DOCTYPE html>
<html lang="en">
<head>
	{literal}

	{/literal}
	
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
	<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@300;500;700;900&display=swap" rel="stylesheet">
	
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
 
	<link rel="apple-touch-icon" sizes="57x57" href="/images/favicon/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="/images/favicon/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="/images/favicon/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="/images/favicon/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="/images/favicon/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="/images/favicon/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="/images/favicon/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="/images/favicon/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="/images/favicon/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="/images/favicon/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/images/favicon/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="/images/favicon/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/images/favicon/favicon-16x16.png">
	<link rel="manifest" href="/images/favicon/manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="/images/favicon/ms-icon-144x144.png">
	<meta name="theme-color" content="#ffffff">

    <link rel="stylesheet" href="/utils/css/bootstrap-reboot.min.css" >
    <link rel="stylesheet" href="/utils/css/bootstrap.min.css" >
	<link rel="stylesheet" href="/utils/css/style-min.css">	
	<link rel="stylesheet" href="/utils/css/wow-ksef.css">
	
	<script src="/utils/js/jquery.js"></script>
    <script defer src="/utils/js/functions.js"></script>	
	<script defer src="/utils/js/bootstrap.bundle.min.js"></script>	
</head>
<body>
<div class="back-to-top"></div>
<div id="cookies-info" style="display: none;">
	<p>
		Siloflex.pl uses cookies, commonly referred to as cookies. Cookies are stored on your device and greatly simplify the use of the website.<br>

		<strong>We use cookies, for example, to:</strong><br>
		- customize the website’s content to your preferences (cookies remember your settings),<br>
		- maintain your session after logging into the Siloflex.pl website (so you don’t have to re-enter your login and password on every page),<br>
	</p>
	<a href="javascript:closeCookiesInfo();" class="btn btn-success btn-sm px-3">I accept all cookies</a>
	<a href="javascript:closeCookiesInfo();" class="btn btn-warning btn-sm px-3">I accept only the required cookies</a>
	<a href="/polityka-prywatnosci" class="btn btn-info btn-sm px-3" title="Privacy Policy of weo.pl">Read more</a>
</div>