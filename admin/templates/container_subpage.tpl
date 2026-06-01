<main>
	<header class="title-subpage">
		<div class="container py-3 border-bottom">
			<h1 class="display-4 fs-2" style="color:#fff">{$page.title}</h1>
		</div>
	</header>

	<div class="container mt-4 subpage" data-aos="fade-top">
		<div class="row">
			<div class="col-lg-12">
				{$page.content} 
			</div>
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
	
</script>
{/literal}