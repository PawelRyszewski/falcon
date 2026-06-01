<main>
	<header style="background:#fff;" class="subpage-header-menu">
		<div class="container">
			<div class="row py-3 border-bottom">
				{if $page.category==3} <div class="menu-oferty-mob btn btn-primary">Pokaż menu firmy</div>{/if}
				<h1 class="display-4 fs-1 fw-light text-left mb-0" style="color:#878787">{$page.title}</h1>
			</div>
		</div>
	</header>

	<div class="container mt-4 subpage with-menu" data-aos="fade-top">
		<div class="subpage-menu-left">		
		
		{if $page.category==3}
		<nav class="navbar">
		<ul class="nav">
			<li>MENU FIRMY</li>
			<li>
				<a href="/rozwiazania/53">Rozwiązania</a>
			</li>
			<li>
				<a href="/referencje/54">Referencje</a>
			</li>
			<li>
				<a href="/praca/55">Praca</a>
			</li>
			<li>
				<a href="/faq/56">FAQ</a>
			</li>
		</ul>
		</nav>
		{/if}
		
		{if $page.category==5}
		<nav class="navbar">
		<ul class="nav">
			<li>МЕНЮ</li>
			<li>
				<a href="/losungen/87">Lösungen</a>
			</li>
			<li>
				<a href="/referenzen/88">Referenzen</a>
			</li>
			<li>
				<a href="/arbeit/89">Arbeit</a>
			</li>
			<li>
				<a href="/faq-haufig-gestellte-fragen/90">FAQ</a>
			</li>	
		</ul>
		</nav>
		{/if}
		
		{if $page.category==4}
		<nav class="navbar">
		<ul class="nav">
			<li>MENU</li>
			<li>
				<a class="dropdown-item" href="/solutions/71">Solutions</a>
			</li>
			<li>
				<a class="dropdown-item" href="/references/72">References</a>
			</li>
			<li>
				<a class="dropdown-item" href="/employment/73">Employment</a>
			</li>
			<li>
				<a class="dropdown-item" href="/faq-frequently-asked-questions/74">FAQ</a>
			</li>		
		</ul>
		</nav>
		{/if}
		
		{if $page.category==6}
		<nav class="navbar">
		<ul class="nav">
			<li>МЕНЮ</li>
			<li>
				<a class="dropdown-item" href="/resheniya/103">Решения</a>
			</li>
			<li>
				<a class="dropdown-item" href="/ssylki/104">Ссылки</a>
			</li>
			<li>
				<a class="dropdown-item" href="/rabota/105">Работа</a>
			</li>
			<li>
				<a class="dropdown-item" href="/FAQ-chasto-zadavaemye-voprosy/106">Вопросы и ответы</a>
			</li>		
		</ul>
		</nav>
		{/if}
		</div>
		
		<div class="row subpage-row-menu">
				{$page.content} 
		</div>
		
	</div>
</main>

{literal}
<script>
	AOS.init({
	  offset: 120,
	  delay: 0,
	  duration: 800, 
	  easing: 'ease-in-out',
	  once: true,
	});	
	
	jQuery.fn.extend({
    toggleText: function (a, b){
        var that = this;
            if (that.text() != a && that.text() != b){
                that.text(a);
            }
            else
            if (that.text() == a){
                that.text(b);
            }
            else
            if (that.text() == b){
                that.text(a);
            }
        return this;
    }
	});
			
	$('.menu-oferty-mob').on('click', function(event) {
		$(this).toggleText('Schowaj menu firmy', 'Pokaż menu firmy');
		$('.subpage-menu-left').toggleClass('show');
	});
		
</script>
{/literal}