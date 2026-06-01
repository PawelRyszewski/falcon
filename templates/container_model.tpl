<main class="subpage article model">
	<header class="title-subpage">
		<div class="container py-3 border-bottom">
		{if $model}
		<h1 class="display-4 fs-2 top" style="color:#fff">{$model.name}</h1>
		{if $categoryName}<p class="text-white mb-1 date-public">{$categoryName}</p>{/if}
		</div>
		<div class="thumb">
			 {if $model.image}<img src="{$model.image}" alt="{$model.name}" class="img-fluid mb-3" />{/if}
		</div>
	</header>

    <div class="container">
		<a href="/ranking-ai" class="btn btn-return back-to-blog" title="Wróć do bloga">
			<span class="arrow"></span>‹ POWRÓT DO RANKINGU
		</a>
	
	<section class="default container-fluid">
		<div class="row">
			<div class="col-lg-12">		
				<p>{$model.description}</p>
				<p><strong>Organizacja:</strong> {$model.organization}</p>
				<p><strong>Licencja:</strong> {$model.license}</p>

				<p><strong>Głosy:</strong> {$model.votes_json+$model.votes_site}</p>
				{if isset($message)}<div class="alert alert-info">{$message}</div>{/if}
				<form method="post" class="mb-3 d-flex gap-2 flex-wrap align-items-start">
				<div class="captcha-container d-none">
					<img data-src="/admin/utils/captcha/captcha.php" alt="captcha" class="captcha-img d-none" />
					<input type="text" name="captcha" placeholder="captcha" class="form-control w-auto d-none" />
					<small class="text-muted captcha-info d-none">Przepisz czarne znaki, aby oddać głos</small>
				</div>
				<button type="button" name="vote" class="btn btn-primary">Głosuj</button>
				</form>
				<a href="/ranking-ai" class="btn btn-return back-to-blog" title="Wróć do bloga">
					<span class="arrow"></span>‹ POWRÓT DO RANKINGU
				</a>
				{else}
				<p>Model nie został znaleziony.</p>
				{/if}
			</div>
		</div>
    </div>
	
  </section>
</main>