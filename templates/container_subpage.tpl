<main>
	<section class="container" data-aos="fade-up">
	<header class="section-header" style="margin-top:20px !important">
		<div class="section-header__ribbon">
			<h1 class="section-header__title mb-0">{$page.title}</h1>
		</div>
	</header>
	</section>
	
  {*
  {if $page_url == 'developer'}
    <section class="pb-5">
      <div class="container">
        <div class="row g-4">
          <div class="col-lg-4">
            <div class="p-4 border rounded-4 h-100">
              <h2 class="h5">Kim jesteśmy</h2>
              <p class="mb-0">EKO-DOM to zespół projektantów, inżynierów i doradców sprzedaży z doświadczeniem w projektach mieszkaniowych.</p>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="p-4 border rounded-4 h-100">
              <h2 class="h5">Jak projektujemy</h2>
              <p class="mb-0">Stawiamy na funkcjonalne rzuty, energooszczędne technologie oraz wysoką jakość części wspólnych.</p>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="p-4 border rounded-4 h-100">
              <h2 class="h5">Co zyskujesz</h2>
              <p class="mb-0">Przejrzysty harmonogram, wsparcie przy formalnościach i opiekę po odbiorze nieruchomości.</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  {/if}
  *}

  <section class="pb-5 mb-5" data-aos="fade-up">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-12">
            {$page.content}
        </div>
      </div>
    </div>
  </section>
  

	<section class="py-5" data-aos="fade-up" id="contact-form">
    <div class="container">
        <header class="section-header">
			<div class="section-header__ribbon">
				<h2 class="section-header__title mb-0">Umów spotkanie. Zostaw swój numer!</h2>
			</div>
        </header>
          {include file='partials/contact_form.tpl'}
    </div>
  </section>

</main>
