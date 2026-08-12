<!DOCTYPE html>
<html lang="pl">
<head>
    <meta name="description" content="Webpage description goes here" />
    <meta charset="utf-8">
    <title>Change_me</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="">
    <script src="/admin/utils/jQuery/jQuery.js">
    </script>
    <link rel="stylesheet" href="/admin/utils/bootstrap/css/bootstrap.min.css">
    <script src="/admin/utils/bootstrap/js/bootstrap.min.js">
    </script>
    <link rel="stylesheet" href="/admin/utils/style.css">
    <link rel="stylesheet" href="/admin/utils/styles/magnific-popup.css">
    <script src="/admin/utils/jquery.magnific-popup.min.js"></script>
    <script src="/admin/utils/moment/moment.js"></script>	
    <script src="/admin/utils/chart/Chart.min.js"></script>
    <script src="/admin/utils/chart/chart-rounded.js"></script>
    <script src="/admin/utils/chart/chartjs-plugin-doughnutlabel.min.js"></script>
    <script src="/admin/utils/functions.js"></script>
	<script src="/admin/utils/jquery.dataTables.min.js"></script>
	<script src="/admin/utils/dataTables.bootstrap.min.js"></script>    
	<script src="/admin/utils/dt-length-cookie.js"></script>
    <!--<script src="/admin/utils/popper.min.js"></script>-->
    <!--<script src="https://cdn.tiny.cloud/1/zf55hvfb0sq52o27atns3zcs1149gfli15eiqfz13grgoy1j/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>-->
    <script src="/admin/utils/tinymice/old/tinymce.min.js"></script>
    <script src="/admin/utils/tinymice/pl.js"></script>
</head>

<body>
    <div id="spinner" class="justify-content-center">
        <div class="align-self-center text-center">
            <div class="spinner-border text-primary mb-2" role="status">
                <span class="sr-only"></span>
            </div>
            <h5>Trwa dodawanie do bazy danych. Prosze nie odświeżać strony.</h5>
        </div>
    </div>


    <div class="side-bar col-12 col-md-2">
	<div class="burger-menu"><span class="burger icon"></span></div>
        <ul class="menu">
			<li class="logo">
				<a href="/admin/">
				   <span class="icon-logo"></span>
				 </a>
			</li>
            <li>
				<a href="/admin/podstrony"><span class="icon-menu-podstrony"></span> Podstrony</a>
			</li>	
			{*<li>
				<a href="/admin/aktualnosci"><span class="icon-menu-aktualnosci "></span>Blog</a>
			</li>
            <li>
				<a href="/admin/galeria-zdjec/edytuj/60"><span class="icon-menu-galeria"></span>Galeria zdjęć</a>
            </li>*}
            <li>
				<a href="/admin/uzytkownicy"><span class="icon-menu-uzytkownicy"></span>Użytkownicy</a>
            </li>
            {*<li>
                <a href="/admin/nieruchomosci"><span class="icon-menu-nieruchomosci"></span>Nieruchomości</a>
            </li>
					
            <li>
                <a href="/admin/newsletter"><span class="icon-menu-poczta"></span>F.Kont. / Newsl.</a>
            </li>*}
            <li>
                <a href="/admin/poczta"><span class="icon-menu-poczta"></span>Poczta</a>
            </li>
            <li>
                <a href="/" target="_blank"><span class="icon-menu-home"></span>Strona główna</a>
            </li>			
        </ul>	
    </div>
	
	<div class="copyright">
		Copyright © {$smarty.now|date_format:"%Y"} <a href="" target="_blank">weo.pl</a>. <br/> All rights reserved.
	</div>	
	
    {if isset($msg_success)}
        <div class="alert alert-success" id="success-alert">
            <button type="button" class="close" data-dismiss="alert">x</button>
            {$msg_success}
        </div>
    
        <script>
            $("#success-alert").fadeTo(4000, 500).fadeOut(500, function() {
                $("#success-alert").fadeOut(500);
            });
        </script>
        <style>
            #success-alert {
                z-index: 30;
            }
        </style>
    {/if}

    {if isset($msg_error)}
        <div class="alert alert-danger" id="error-alert">
            <button type="button" class="close" data-dismiss="alert">x</button>
            {$msg_error}
        </div>
    
        <script>
            $("#error-alert").fadeTo(4000, 500).fadeOut(500, function() {
                $("#error-alert").fadeOut(500);
            });
        </script>
        <style>
            #error-alert {
                z-index: 30;
            }
        </style>
    {/if}
	
<div class="page-wrapper col-12 col-md-10">	

    <div class="top-bar d-flex align-items-center col justify-content-cente flex-wrap">
		<div class="p-2 user">
			Witaj <strong>{$user}</strong>
		</div>
		<div class="p-2 options" hidden>
			<span class="icon-top-bar-options"></span>
		</div>		
		<div class="p-2 news" hidden>
			<div class="qua">2</div>
			<span class="icon-top-bar-info"></span>
		</div>	
		<div class="p-2 search" hidden>
			<form method="post">
				<input maxlength="255" class="search__input" name="search" type="search" autocomplete="off" placeholder="Szukaj">
				<button type="button" class="search-button">
					<span class="icon-top-bar-search"></span>
				</button>
			</form>
		</div>	

		<div class="p-2 ml-auto logout">
			<form method="POST">
				<button type="submit" class="btn btn-dark left-ico" name="logout"><span class="icon-top-bar-login"></span>Wyloguj się</button>
			</form>			
		</div>

    </div>
