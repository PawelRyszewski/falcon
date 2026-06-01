<main>

<section class="section-select py-0 head-section" data-aos="fade-top">
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<div class="text-absolute">
					<h1>The Best for Silage</h1>
					<p>WRAP WITH US!</p>
				</div>
				
				<img src="/utils/images/background.webp" alt="Siloflex - The Best for Silage" title="Siloflex - The Best for Silage"/>
				
				<a href="#" class="video-popup" data-video="utils/images/siloflex.mp4">WATCH <span>VIDEO</span></a>
			</div>
		</div>
	</div>
</section>

<section class="section-txt txt-right style1 position-relative sec1">
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<div class="text position-relative">
					<h2 class="title-style-2">THE HIGHEST QUALITY OF MANUFACTURE!</h2>
					<p>Tight compression and oxygen expulsion result in high-quality silage. It creates a barrier against air ingress, preventing the loss of the silage’s nutritional value. Enjoy high efficiency – up to 35% more bales per roll. Price negotiation is available for larger orders. <span class="strong-yellow">ATTRACTIVE PRICES</span></p>
				</div>
				
				<img src="/utils/images/back-section.webp"  class="img" alt="Highest quality of manufacture - Siloflex" title="Highest quality of manufacture - Siloflex">
			</div>
		</div>
	</div>
</section>

<section class="section-txt txt-right style1 position-relative sec2">
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<div class="text position-relative">
					<h2 class="title-style-2">EUROPEAN STANDARD!</h2>
					<p class="text-center w-100">Our films meet the highest European standards of quality and environmental protection, ensuring safe and efficient usage. We invest in innovative production technologies that make our films not only exceptionally durable and functional but also completely eco-friendly.</p>
					
					<p class="text-center w-100">✅ <strong>100% Recycled</strong> ✅ <strong>Safe Disposal</strong> ✅ <strong>Eco-Friendly Approach</strong></p>
					
					<p class="text-center w-100">By choosing our films, you not only get a product of outstanding quality and durability but also support sustainable development and environmental protection! 🌍♻️</p>
				</div>
			</div>
		</div>
	</div>
</section>

<section class="section-txt txt-right style1 position-relative sec3">
	<div class="container">
		<div class="row">
			<div class="col-lg-10">
				<div class="text position-relative">
					<h2 class="title-style-3">WHY BUY?</h2>
					
					<p>Our film is a premium product that guarantees the highest quality protection for silage. Thanks to modern production technologies, it meets the expectations of even the most demanding users.</p>
					
					<ul class="list-no-style">
						<li>🔹 Universal application – the film works perfectly with all types of wrappers, both stationary and self-loading, ensuring full compatibility and ease of use.</li>
						
						<li>🔹 Strong adhesive properties – thanks to the use of specialized adhesive components, the film adheres perfectly to the bale, creating an airtight protective layer and eliminating the risk of air infiltration.</li>
						
						<li>🔹 5-layer structure – the multi-layer construction of the film provides exceptional resistance to punctures and mechanical damage, which is crucial when working in harsh agricultural conditions.</li>
						
						<li>🔹 Consistent elasticity – the film maintains ideal tension during wrapping, creating an even and aesthetically pleasing protective layer that minimizes feed losses.</li>
						
						<li>🔹 UV protection – a special UV stabilizing additive ensures high resistance to sunlight, preventing film degradation and extending its durability even in extreme weather conditions.</li>
					</ul>
					
					<p>By purchasing our film, you invest in the efficiency, durability, and safety of your yield! 🌿✅</p>
				</div>
			</div>
		</div>
	</div>
</section>

<section class="section-txt foot2">
	<div class="container py-5">
		<div class="d-flex py-5">
			
			<div class="mb-5 pe-5 border-end">
				<img class="mb-5" width="150" height="25" loading="lazy" src="/utils/images/logo.svg" alt="Stretch film, silage" title="Stretch film, silage">
				<p>
					+48 601 475 389 MAJMEX J. Maj (Silesia)
				</p>
				<p>
					+48 505 901 204 T. Kazimierski 09-540 Sanniki
				</p>
				<p>
					+48 501 735 130 R. Barczyk (Mazovia) 
				</p>
				
				<p>biuro@siloflex.pl</p>
			</div>
			
			<div class="px-5">
				<p class="fs-4 mb-4 title lh-1">
					<strong>COMPANY</strong>
				</p>
				<a href="/o-nas/25" alt="About Us" title="About Us">About Us</a>
				<a href="/kontakt/26" alt="Contact" title="Contact">Contact</a>
			</div>
			
			<div class="px-5">
				<p class="fs-4 mb-4 title lh-1">
					<strong>LEGAL REGULATIONS</strong>
				</p>
				<a href="/polityka-prywatnosci/29#regulamin" alt="Terms &amp; Conditions" title="Terms &amp; Conditions">Terms &amp; Conditions</a>
				<a href="/polityka-prywatnosci/29#polityka" alt="Cookie Policy" title="Cookie Policy">Cookie Policy</a>			
			</div>			
			
		</div>
	</div>
</section>

<div class="modal fade" id="videoModal" tabindex="-1" aria-labelledby="videoModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center">
        <video id="videoPlayer" width="100%" controls>
          <source src="" type="video/mp4">
          Your browser does not support the video tag.
        </video>
      </div>
    </div>
  </div>
</div>

</main>

{literal}
	<script>

		function buttons(){
			const button = ('.section-select .menu a');
			$(button).on('mouseenter', function(event) {
				let get_class = $(this).attr('class');
				$('.section-select .products').find('.'+get_class).addClass('show');	
			});
			$(button).on('mouseleave', function(event) {
				let get_class = $(this).attr('class');
				$('.section-select .products').find('.'+get_class).removeClass('show');	
			});	
			
			const button2 = ('.products a');
			$(button2).on('mouseenter', function(event) {
				let get_class2 = $(this).attr('class');
				$('.menu').find('.'+get_class2).addClass('hover');					
				$(this).addClass('show');
				$(this).removeAttr
			});
			$(button2).on('mouseleave', function(event) {
				$(this).removeClass('show');
				let get_class2 = $(this).attr('class');
				$('.menu').find('.'+get_class2).removeClass('hover');									
			});			
					
		}
		buttons();
		
		$(document).ready(function() {
			$('.video-popup').on('click', function(e) {
				e.preventDefault();
				let videoUrl = $(this).data('video');
				let video = $('#videoPlayer')[0];
				
				$('#videoPlayer source').attr('src', videoUrl);
				video.load();
				video.play(); 

				$('#videoModal').modal('show');
			});

			$('#videoModal').on('hidden.bs.modal', function () {
				let video = $('#videoPlayer')[0];
				video.pause();
				video.currentTime = 0;
			});
		});	
	</script>
{/literal}
