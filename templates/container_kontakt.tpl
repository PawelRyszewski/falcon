<main>
	<section class="container" data-aos="fade-up">
	<header class="section-header" style="margin-top:20px !important">
		<div class="section-header__ribbon">
			<h1 class="section-header__title mb-0">{$page.title}</h1>
		</div>
	</header>
	</section>

	<section class="container subpage mt-4">
		<div class="row">
			<div class="col-lg-12 kontakt" data-aos="fade-right">
				{$page.content} 
			</div>	
		</div>
	</section>
	
	<div id="contact-form"></div>
	<section class="py-5" data-aos="fade-up">
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

{literal}
<script>
AOS.init({
  offset: 120,
  delay: 0,
  duration: 800, 
  easing: 'ease-in-out',
  once: true,
});	

$('div.people div.txt span.email + a, .subpage .icon.email + strong + a').each(function(index, value){
	$(this).on('mouseenter', function(event) {
		let email = $(this).attr("href").split("").reverse().join("");
		$(this).attr("href",email);
	});
	$(this).on('mouseleave', function(event) {
		let email = $(this).attr("href").split("").reverse().join("");
		$(this).attr("href",email);
	});	
});

function switch_map(){

	$('.switch-map').on('click', function(event) {
		$(this).next().toggleClass('show');
		$(this).toggleClass('active');
	});
	
}
switch_map()

</script>
{/literal}