<main>
	<header style="background:#fff;">
		<div class="container py-3 border-bottom">
			<h1 class="display-4 fs-1 fw-light text-left" style="color:#878787">{$gallery.title} - galeria</h1>
		</div>
	</header>

	<div class="container">
	
	<section class="gallery">
		<div class="row">
			{*<div class="col-12 col-lg-3 mt-4">
				<nav>
					<ul class="list-group">
					<h3 class="fs-4" style="color:#666">Galeria:</h3>
						{foreach from=$list_url item=$item_url }
							<li class="list-group-item list-group-item-action">
								{$item_url}
							</li>
						{/foreach} 
					</ul>
				</nav>
			</div>*}

			<div class="col-12 col-lg-12">
			
				<div class="row">
					<div class="col-12"><ul class="pagination d-flex justify-content-end align-items-center"></ul></div>
				</div>
				
				{$gallery.content}
				<div class="imglist row row-cols-3 row-cols-sm-3 row-cols-md-6 g-6">
				
					{foreach from=$images item=$image key=$k}
					<div class="col">
						<div class="card shadow-sm">
							<a href="/uploads/{$image.name}" data-fancybox="preview" class="linked-img text-center">
								<img class="hover-shadow" src="/uploads/thumb/{$image.name}" alt="{$image.title}" title="{$image.title}"  style="max-height: 220px;">
							</a>
							{*<div class="card-body">
								<p class="title" style="margin:0px;">{$image.title}</p>
							</div>*}
						</div>
					</div>
					{/foreach}
				
				</div>
			</div>
		</div>
    </section>
	
	</div>
</main>


<link rel="stylesheet" href="/utils/css/fancybox.min.css">
<script src="/utils/js/fancybox.min.js"></script>
{literal}
<script>
	  $('[data-fancybox="preview"]').fancybox({
	thumbs : {
		autoStart : true
	}
	});
</script>     	
{/literal}