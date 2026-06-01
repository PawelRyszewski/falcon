<main class="subpage blog">

	<header class="title-subpage">
		<div class="container py-3 border-bottom">
			<h1 class="display-4 fs-2" style="color:#fff">BLOG</h1>
		</div>
	</header>

	<div class="container list-gallery mb-5">
		<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
			{foreach from=$news item=item}
				<div class="col">
					<div class="card shadow-sm">
					
						<a href="/blog/{$item.category}/{$item.url}" class="linked-img text-center">
							{if $item.img}
								<img src="/uploads/thumb/{$item.img}" alt="{$item.title}" title="{$item.img_title}" class="hover-shadow">
							{else}
								<div class="no-image no-image-logo">
										
								</div>
							{/if}
						</a>
					
						<div class="card-body">
							<a href="/blog/{$item.category}/{$item.url}" class="linked-content" alt="{$item.title}" title="{$item.title}"></a>
							<div class="content">
								<h2 class="title">
									<a href="/blog/{$item.category}/{$item.url}" class="img-news">{$item.title}</a>
								</h2>	
							</div>
						</div>
						
						
					</div>
				</div>
			{/foreach}
		</div>
	</div>
	
</main>


{literal}
<script src="/utils/js/pagination.min.js"></script>
<script>
    $(document).ready(function () {
        $('ul.pagination').rpmPagination({
            limit: 24,
            domElement: 'div#news div.block'
        });
    });		

	window.addEventListener('resize', ustawWysokosc);

	function ustawWysokosc() {
		let kontenery = document.querySelectorAll('.list-gallery .linked-img');

		kontenery.forEach(function(kontener) {
			let szerokosc = kontener.offsetWidth;
			kontener.style.height = szerokosc + 'px';
		});
	}

	ustawWysokosc();
</script>     	
{/literal}    