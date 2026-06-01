<div class="contianer-fluid">
	<footer class="row d-flex flex-wrap justify-content-between align-items-top py-3 border-top bg-dark2 text-light mx-0 mb-0">
		<p class="col-md-4 mb-0 text-white-50" style="font-size:12px;">© {$smarty.now|date_format:"%Y"} weo.pl <br/> 
		{if $page.category==3}
			Wszelkie prawa zastrzeżone 
		{else if $page.category==4}
			All rights reserved
		{else if $page.category==5}
			Konzeption und Umsetzung
		{else if $page.category==6}		
			Дизайн и реализация
		{/if}	
		</p>

		<div style="flex:auto; font-size:12px;" class="col-md-4 d-flex flex-wrap flex-direction-column align-items-center justify-content-end mb-3 mb-md-0 me-md-auto link-dark text-decoration-none icon-container">
			<p class="w-100 mb-0 text-end text-white-50">
			{if $page.category==3}
				Projekt i realizacja
			{else if $page.category==4}
				Design and implementation
			{else if $page.category==5}
				Konzeption und Umsetzung
			{else if $page.category==6}		
				Дизайн и реализация
			{/if}
			</p>
			<span class="icon weo" style="opacity:0.5"></span>
		</div>		

	</footer>
</div>	
{literal}
<script src="https://sugestie.weo.pl/popup" type="text/javascript"></script>
<script>
	const shouldHideCookiesAlert = localStorage.getItem('shouldHideCookiesAlert');

	if (!shouldHideCookiesAlert) {
	$('#cookies-info').css('display','block');
	}

	function closeCookiesInfo() {
	$('#cookies-info').css('display','none');
	localStorage.setItem('shouldHideCookiesAlert', true);
	}
</script>

<script>
  if (window.innerWidth >= 768) {
    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = '/utils/css/aos.css';
    document.head.appendChild(link);

    var script = document.createElement('script');
    script.src = '/utils/js/aos.js';
    script.onload = function () {
      AOS.init({
        offset: 120,
        delay: 0,
        duration: 800,
        easing: 'ease-in-out',
        once: true,
      });
    };
    document.head.appendChild(script);
  }
</script>
{/literal}
</body>
</html>