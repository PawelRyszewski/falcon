<div class="container-fluid bg-dark text-light mt-5">
  <footer>
    <div class="row g-4">
      <div class="col-lg-6">
        <p class="text-uppercase small mb-2 text-white-50">Kontakt</p>
        <h2 class="h5 mb-3">EKO-DOM Sp. z o.o.</h2>
        <p class="mb-1 text-white-50">ul. Deweloperska 12, 00-123 Warszawa</p>
        <p class="mb-1 text-white-50"><a href="tel:+48500600700" class="link-light text-decoration-none">+48 500 600 700</a></p>
        <p class="mb-3 text-white-50"><a href="mailto:biuro@eko-dom.pl" class="link-light text-decoration-none">biuro@eko-dom.pl</a></p>
        <p class="mb-0 text-white-50">Godziny pracy: pon.–pt. 8:00–17:00</p>
      </div>

      <div class="col-lg-6">
        <p class="text-uppercase small mb-2 text-white-50">Social media</p>
        <ul class="list-unstyled mb-4">
          <li class="mb-1"><a href="#" class="link-light">Facebook</a></li>
          <li class="mb-1"><a href="#" class="link-light">Instagram</a></li>
        </ul>

        <ul class="list-inline mb-0">
          <li class="list-inline-item"><a href="/polityka-prywatnosci" class="link-light">Polityka prywatności</a></li>
          <li class="list-inline-item"><a href="/kontakt" class="link-light">Kontakt</a></li>
        </ul>
      </div>
    </div>

    <div class="border-top border-secondary mt-4 pt-3">
      <small class="text-white-50">&copy; {$smarty.now|date_format:"%Y"} EKO-DOM Sp. z o.o. Wszelkie prawa zastrzeżone.</small>
    </div>
  </footer>
</div>
{literal}
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
{/literal}
</body>
</html>
