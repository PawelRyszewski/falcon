<div class="container-fluid bg-dark text-light mt-5">
  <footer class="container py-4">
    <div class="row align-items-center">
      <div class="col-md-4 text-start">
        <small>Strona zawiera linki partnerskie...</small>
      </div>	
      <div class="col-md-8 mb-3 mb-md-0 text-end">
        <ul class="list-inline mb-0">
          <li class="list-inline-item"><a href="/polityka-prywatnosci" class="link-light">Polityka prywatności</a></li>
          <li class="list-inline-item"><a href="/kontakt" class="link-light">Kontakt</a></li>
        </ul>
      </div>


    </div>
  </footer>
</div>

{literal}
	<script src="https://sugestie.weo.pl/popup" type="text/javascript" async></script>
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

	<script src="/utils/js/jquery.js"></script>
	<script src="/utils/js/aos.js"></script>
	<script src="/utils/js/bootstrap.bundle.min.js"></script>
{/literal}
</main>
</body>
</html>
