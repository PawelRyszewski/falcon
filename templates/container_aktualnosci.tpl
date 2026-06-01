<main class="subpage blog">

	<header class="title-subpage">
		<div class="container py-3 border-bottom">
			<h1 class="display-4 fs-2" style="color:#fff">BLOG KSEF</h1>
				{if isset($category_name) && $category_name}
						<p class="category-name" style="color:#fff">{$category_name}</p>
				{/if}
		</div>
	</header>

	{if $cats_news|@count}
	<div class="container my-4">
			<nav class="nav justify-content-center flex-wrap blog-categories" aria-label="Kategorie">
					{if $selected_category}
							<a href="/blog" class="btn btn-return back-to-blog" style="margin-top:0 !important; margin-bottom:0 !important;"><span class="arrow"></span>‹ POWRÓT DO BLOGA KSeF</a>
					{/if}
					{foreach from=$cats_news item=cat}
							<a href="/blog/{$cat.id}" class="nav-link{if $selected_category == $cat.id} active{/if}">{t key="cat{$cat.id}"}</a>
					{/foreach}

			</nav>
	</div>
	{/if}

	<div class="container list-gallery mb-5">
		<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
		
			{foreach from=$news item=item}
				<div class="col">
					<div class="card shadow-sm">
						<a href="/blog/{$item.category}/{$item.url}" class="linked-img text-center">
							{if $item.img_thumb_path}
								<img src="{$item.img_thumb_path}" alt="{$item.title}" title="{$item.img_title}" class="hover-shadow" loading="lazy">
							{else}
								<div class="no-image no-image-logo"></div>
							{/if}
						</a>

						<div class="card-body">
							<a href="/blog/{$item.category}/{$item.url}" class="linked-content" alt="{$item.title}" title="{$item.title}"></a>
							<div class="content">
								<p class="text-muted mb-1 date-public">{$item.created_at|date_format:"%d.%m.%Y"}</p>
								<h2 class="title">
										<a href="/blog/{$item.category}/{$item.url}" class="img-news">{$item.title|truncate:60}</a>
								</h2>
							</div>
						</div>
					</div>
				</div>
			{/foreach}						
								
		</div>
	</div>
	
        {if $total_pages > 1}
        <nav aria-label="Pagination">
                <ul class="pagination justify-content-center">
                        {if $current_page > 1}
                                <li class="page-item">
                                        <a class="page-link" href="{$pagination_base_url}{if $current_page-1 > 1}?page={$current_page-1}{/if}" rel="prev">&laquo;</a>
                                </li>
                        {/if}
                        {foreach from=$pages item=p}
                                <li class="page-item{if $p == $current_page} active{/if}">
                                        <a class="page-link" href="{$pagination_base_url}{if $p > 1}?page={$p}{/if}">{$p}</a>
                                </li>
                        {/foreach}
                        {if $current_page < $total_pages}
                                <li class="page-item">
                                        <a class="page-link" href="{$pagination_base_url}?page={$current_page+1}" rel="next">&raquo;</a>
                                </li>
                        {/if}
                </ul>
        </nav>
        {/if}
</main>


{literal}

<script>

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