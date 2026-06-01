<main>
	<div style="background:#fff;">
		<div class="container subpage py-3 border-bottom">
			<h1 class="display-4 fs-1 fw-light text-left" style="color:#878787">{$page.title}</h1>
		</div>
	</div>

	<section class="container subpage mt-4">
		<div class="row">
			<div class="col-lg-5 col-sm-12 kontakt" data-aos="fade-right">
				{$page.content} 
			</div>
			<div class="col-lg-7 col-sm-12 position-relative" data-aos="fade-left">
				<p class="nav-map">Navigation: E21°183553 - N52°013585</p>
				<p class="switch-map"><span class="icon2 ico5"></span></p>
				<div class="col-lg-12 col-sm-12 map-container">
					<h3 class="mb-3">Map of directions</h3>
					<div class="map">
						<div id="other1">
							<img style="max-width:250%; transform-origin: 0px 0px 0px; transform: matrix(1.20699, 0, 0, 1.20699, -1014.35, -674.703);" src="/utils/images/map.webp" />
						</div>
					</div>
					{literal}
					<script>
					window.addEventListener('load', function () {
						panzoom(document.getElementById('other1'));
					}); 
					</script>
					{/literal}
					<a href="https://www.google.pl/maps?ie=UTF8&cid=9457012180018342675&q=FOLPOL+S.J.&gl=PL&hl=pl&t=h&ll=52.014961,21.183808&spn=0.004622,0.00912&z=16&iwloc=A&source=embed" target="_blank"  rel="nofollow" style="    border-top-left-radius: 0 !important; border-top-right-radius: 0 !important;" class="btn btn-primary w-100 mt-0">View larger map</a>
				</div>
				
			</div>
					
			
		</div>
	</section>
	
	<section data-aos="fade-top" class="container-fluid px-0 hr-contact specjalisci">
		<p>SPECIALISTS</p>
	</section>	

	<section class="container subpage mt-5">
		<div class="row people">
			<div class="col-lg-12 w1">
				<p>WOULD YOU LIKE TO GET IN TOUCH WITH THE SPECIALIST?</p>
				<p>USE FOLLOWING E-MAIL ADDRESSES AND YOUR ENQUIRY MORE QUICKLY WILL HIT TO THE RESPONSIBLE PERSON</p>
			</div>
		
			<div class="col-lg-4 w1" data-aos="fade-top" data-aos-delay="100">
				<div class="row mx-0 px-0">
					<div class="col-lg-4 photo"></div>
					<div class="col-lg-8 txt">
						<div>
							<p class="my-0">I am interested in</p>
							<p><strong>stretch foil</strong></p>
							<p><span class="icon email me-1"></span></span><a href="lp.loplof@hcterts:otliam"><span class="revers">lp.loplof@hcterts</span></a></p>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-4 w1" data-aos="fade-top" data-aos-delay="200">
				<div class="row mx-0 px-0">
					<div class="col-lg-4 photo"></div>
					<div class="col-lg-8 txt">
						<div>
							<p class="my-0">I am interested in</p>
							<p><strong>agricultural foils</strong></p>
							<p><span class="icon email me-1"></span><a href="lp.loplof@ezcinlor.eilof:otliam"><span class="revers">lp.loplof@ezcinlor.eilof</span></a></p>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-4 w1" data-aos="fade-top" data-aos-delay="300">
				<div class="row mx-0 px-0">
					<div class="col-lg-4 photo"></div>
					<div class="col-lg-8 txt">
						<div>
							<p class="my-0">I am interested in</p>
							<p><strong>machines and devices</strong></p>
							<p><span class="icon email me-1"></span><a href="lp.loplof@ynyzsam:otliam"><span class="revers">lp.loplof@ynyzsam</span></a></p>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-4 w1" data-aos="fade-top" data-aos-delay="100">
				<div class="row mx-0 px-0">
					<div class="col-lg-4 photo"></div>
					<div class="col-lg-8 txt">
						<div>
							<p class="my-0">I am interested in</p>
							<p><strong>cardboard packaging</strong></p>
							<p><span class="icon email me-1"></span><a href="lp.loplof@ynotrak:otliam"><span class="revers">lp.loplof@ynotrak</span></a></p>
						</div>
					</div>
				</div>
			</div>		
			<div class="col-lg-4 w1" data-aos="fade-top" data-aos-delay="200">
				<div class="row mx-0 px-0">
					<div class="col-lg-4 photo"></div>
					<div class="col-lg-8 txt">
						<div>
							<p class="my-0">I am interested in</p>
							<p><strong>organization of the packaging system in My Company</strong></p>
							<p><span class="icon email me-1"></span><a href="lp.loplof@eigolonhcet:otliam"><span class="revers">lp.loplof@eigolonhcet</span></a></p>
						</div>
					</div>
				</div>
			</div>				
			
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

$('div.people div.txt span.email + a').each(function(index, value){
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