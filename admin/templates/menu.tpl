{*	<header class="py-3 border-bottom container-fluid px-5">
		<div class="container">
			<nav class="navbar navbar-expand-lg w-100">
				<a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none w-100-mob justify-content-center">
					<img class="bi me-2 me-xs-0" width="200" src="/utils/images/logo.svg" />
				</a>
				
				<button class="navbar-toggler bg-dark navbar-dark mt-xs-2 mb-xs-2 w-100-mob" type="button" data-bs-toggle="collapse" data-bs-target="#navbar1" aria-controls="navbar1" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>	
		
				<div class="collapse navbar-collapse justify-content-end" id="navbar1">
					<ul class="nav nav-pills align-items-center justify-content-center">
						
							{foreach from=$menuPages item=item}
								<li class="nav-item w-100-mob text-center">
									<a class="nav-link" href="/{$item.url}" title="{$item.title}">{$item.title}</a>
								</li>
							{/foreach} 		
						<li class="nav-item ms-3 ms-xs-0"><a href="#" class="icon-container circle"><span class="icon facebook"></span></a></li>
						<li class="nav-item mx-1"><a href="#" class="icon-container circle"><span class="icon twitter"></span></a></li>
					</ul>
				</div>
			</nav>
		</div>
</header>*}