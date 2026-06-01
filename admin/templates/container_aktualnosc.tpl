<main class="subpage article">

	<header class="title-subpage">
		<div class="container py-3 border-bottom">
			<h1 class="display-4 fs-2" style="color:#fff">{$news.title}</h1>
		</div>
	</header>

	<div class="container">
		<a href="/blog" class="btn btn-return back-to-blog" title="Wróć do bloga">
			<span class="arrow"></span>&#8249; POWRÓT DO BLOGA
		</a>
		

		<section class="default container-fluid">
			<div class="row">
				
				{if $news.img}<div class="col-lg-6">{else} <div class="col-lg-12"> {/if}
					{$news.content}
				</div>				
				
				{if $news.img}
					<div class="col-lg-6">
						<img src="/uploads/{$news.img}" alt="{$news.title}" title="{$news.img_title}">
						
					</div>							
				{else}
				
				
				
				{/if}	

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