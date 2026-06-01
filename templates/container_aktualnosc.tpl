<main class="subpage article">

	<header class="title-subpage">
				<div class="container py-3 border-bottom">
					<h1 class="display-4 fs-2 top" style="color:#fff">{$news.title}</h1>
					<p class="text-white mb-1 date-public">{$news.created_at|date_format:"%d.%m.%Y"}</p>
					{if $category_name}
									<p class="category-name" style="color:#fff">{$category_name}</p>
					{/if}
				</div>
			{if $news.img_path}
					<div class="background">
							<img src="{$news.img_path}" alt="{$news.title}" title="{$news.img_title}">
					</div>
			{/if}
			{if $news.img_thumb_path}<div class="thumb" style="background:url({$news.img_thumb_path})"></div>{/if}
	</header>

	<div class="container">
		<a href="/blog" class="btn btn-return back-to-blog" title="Wróć do bloga">
			<span class="arrow"></span>&#8249; POWRÓT DO BLOGA KSeF
		</a>
		

		<section class="default container-fluid">
			<div class="row">
				<div class="col-lg-12">
					{$news.content}
				</div>				
			</div>
		</section>
		
		<div class="content my-3">
			{if $prev_news}
				<a href="/blog/{$id_cat}/{$prev_news.url}" class="btn btn-primary" title="{$prev_news.title}">
					< poprzedni news
				</a>
			{/if}
			{if $next_news}
				<a href="/blog/{$id_cat}/{$next_news.url}" class="btn btn-primary pull-right" style="float:right" title="{$next_news.title}">
					następny news >
				</a>
			{/if}
		</div>	
		
	</div>
</main>