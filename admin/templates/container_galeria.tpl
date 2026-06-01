<main>
	<div class="container mt-4">
        <div class="row row-cols-2 row-cols-sm-2 row-cols-md-2 g-3">
                {$counter = 0 }
                {foreach from=$galleries item=$gallery key=$k}
                    {if $counter == 0}
            
                        {/if}
                        <div class="col">
							<div class="card shadow-sm">
								<a href="/galeria/{$gallery.url}" class="linked-img text-center">
									{if $gallery.id == 111}
										<img src="/ai-materials/uploads/thumb/{$mainImages[$gallery.img][0]}" alt="{$gallery.title}" class="hover-shadow" title="{$gallery.title}">
										{else}
										<img src="/uploads/thumb/{$mainImages[$gallery.img][0]}" alt="{$gallery.title}" class="hover-shadow" title="{$gallery.title}">
									{/if}	
								</a>							
							
								<div class="card-body">
									<h4><a href="/galeria/{$gallery.url}" title="{$gallery.title}">{$gallery.title}</a></h4>
									<small class="text-gray bold">{$gallery.description}</small>
									<p class="card-text">{$gallery.content|strip_tags|truncate:30}</p>
								</div>
       
							</div>
                        </div>
                        {if $counter == 2}
                            {$counter = 0}
                        
                        {else}
                            {$counter = $counter + 1}
                        {/if}
            
                        {if $gallery@last}
                
                    {/if}
            
                {/foreach}
                <div class="clear"></div>
        </div>
	</div>
</main>