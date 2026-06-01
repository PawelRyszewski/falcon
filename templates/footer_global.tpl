<footer class="ekd-global-footer mt-5">
  <div class="container">
    <div class="row ekd-global-footer__grid">

      <div class="col-lg-6 ekd-global-footer__col">
        <h2 class="ekd-global-footer__company">EKO-DOM Sp. z o.o.</h2>
        <h3 class="ekd-global-footer__heading">Kontakt</h3>
        <p class="ekd-global-footer__text">al. Krakowska 179</p>
        <p class="ekd-global-footer__text">02-180 Warszawa</p>
        <p class="ekd-global-footer__text">(+48) 604 532 685</p>
        <p class="ekd-global-footer__text"><a href="mailto:biuro@eko-dom.waw.pl">biuro@eko-dom.waw.pl</a></p>
      </div>

      <div class="col-lg-6 ekd-global-footer__col">
        <h3 class="ekd-global-footer__heading">Jesteśmy dostępni</h3>
        <p class="ekd-global-footer__text">Od poniedziałku do piątku</p>
		
		<div>
		<h3 class="ekd-global-footer__heading">Social Media</h3>
        <div class="ekd-global-footer__social">
          <a href="https://www.facebook.com/ekodom" class="ekd-global-footer__social-btn" target="_blank" rel="noopener" aria-label="Facebook">
            <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20" aria-hidden="true"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
          </a>
          <a href="https://www.instagram.com/ekodom" class="ekd-global-footer__social-btn" target="_blank" rel="noopener" aria-label="Instagram">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="20" height="20" aria-hidden="true"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><circle cx="17.5" cy="6.5" r=".5" fill="currentColor" stroke="none"/></svg>
          </a>
		  </div>
        </div>
		
      </div>
    </div>


		</div>
		

  </footer>
</div>

{literal}
	<script src="/utils/js/jquery.js"></script>
	<script src="/utils/js/aos.js"></script>
	<script>
	  if (window.AOS) {
		AOS.init({
		  offset: 120,
		  delay: 0,
		  duration: 800,
		  easing: 'ease-in-out',
		  once: true,
		  disable: function () {
			return window.innerWidth < 768;
		  }
		});
	  }
	</script>
{/literal}
</main>
</body>
</html>
