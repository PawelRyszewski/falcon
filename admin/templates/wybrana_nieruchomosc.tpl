<main>
	<div class="container">
	<section class="gallery">
		<div class="row">
			<div class="col-12 col-lg-3 mt-4">
				<nav>
					<ul class="list-group">
					<h3 class="fs-4" style="color:#666;"><span style="font-weight:100; font-size:12px;">Dziennik budowy</span><br/>Osiedle Sarabandy:</h3>
						{foreach from=$list_url item=$item_url }
							<li class="list-group-item list-group-item-action">
								{$item_url}
							</li>
						{/foreach} 
					</ul>
				</nav>
			</div>

			<div class="col-12 col-lg-9">
				<div class="row">
					<div class="col-12"><ul class="pagination d-flex justify-content-end align-items-center"></ul></div>
				</div>
					<h1 class="display-4 fs-1 fw-light text-left border-bottom mb-3 pb-3 {if $realestate.realestate_status==1}disabled{/if}" style="color:#878787">{$realestate.title}</h1>
					<div class="imglist row row-cols-3 row-cols-sm-6 row-cols-md-6 g-6  mb-4">
						{foreach from=$images item=$image key=$k}
							<div class="col">
								<div class="card shadow-sm">
									<a href="/uploads/{$image.name}" data-fancybox="preview" class="linked-img text-center">
										<img class="hover-shadow" src="/uploads/thumb/{$image.name}" alt="{$image.title}" title="{$image.title}"  style="max-height: 220px;">
									</a>
								</div>
							</div>
						{/foreach}
					</div>
					
					<h4 class="fs-4" style="color:#666;">Newsy dotyczące działki:</h4>
				{$realestate.content}
				
			</div>
		</div>
    </section>
	
	</div>
</main>



{literal}
<script>
	  $('[data-fancybox="preview"]').fancybox({
	thumbs : {
		autoStart : true
	}
	});
</script>     	
{/literal}