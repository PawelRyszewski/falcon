<main class="subpage ranking">

  
	<header class="title-subpage">
		<div class="container py-3 border-bottom">
			<h1 class="display-4 fs-2 top" style="color:#fff">Ranking AI 2025</h1>
		</div>
	</header>
  
    <div class="container">
		<section class="default container-fluid">
			<div class="row">
				<div class="col-lg-12">		
					{if isset($message) && $message}
					<div class="alert alert-info">{$message}</div>
					{/if}
					{foreach from=$categories item=cat}
					<h2>{$cat.name}</h2>
					<table class="table ranking-table table-hover">
						<thead>
							<tr>
								<th scope="col">Model</th>
								<th scope="col" class="sortable" data-column="1">Punktacja</th>
								<th scope="col" class="sortable" data-column="2">Głosy</th>
								<th scope="col"></th>
								<th scope="col">Dokumentacja</th>
							</tr>
						</thead>
					<tbody>
						{foreach from=$cat.results item=res}
						<tr>
							<td scope="row"><a href="/model/{$res.model.slug}">{$res.model.name}</a></td>
							<td>{$res.score|number_format:0:'':' '}</td>
							<td>{$res.votes|number_format:0:'':' '}</td>
							<td>
								{if $res.model.id}
								<form method="post" class="d-flex gap-2 align-items-center flex-wrap">
								<input type="hidden" name="model_id" value="{$res.model.id}" />
								<input type="hidden" name="category_id" value="{$cat.id}" />
								<div class="captcha-container d-none">
									<img data-src="/admin/utils/captcha/captcha.php" alt="captcha" class="captcha-img d-none" />
									<small class="text-muted captcha-info d-none">Przepisz czarne znaki, aby oddać głos</small>
									<input type="text" name="captcha" placeholder="Wpisz tutaj" class="form-control w-auto d-none" />
									
								</div>
								<button type="button" name="vote" class="btn btn-sm btn-primary">Głosuj</button>
								</form>
								{else}-{/if}
							</td>
							<td>
								{if $res.model.model_link}<a href="{$res.model.model_link}" class="btn btn-sm btn-light" rel="nofollow" target="_blank">Sprawdź</a>{else}<span class="warning">brak linku</span>{/if}
							</td>			  
						</tr>
						{/foreach}
					</tbody>
					</table>
					{if $cat.results|@count > 10}
					<button class="btn btn-link p-0" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-rank-{$cat.id}" aria-expanded="false" aria-controls="collapse-rank-{$cat.id}">Pokaż więcej</button>
					{/if}
					{/foreach}
				</div>
			</div>
		</section>
	</div>
</main>

<script src="/utils/js/ranking-sort.js"></script>