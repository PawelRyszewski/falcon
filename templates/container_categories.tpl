<main>
  <section class="py-4">
    <div class="container">
      <h1>Kategorie</h1>
      {if isset($message)}<div class="alert alert-info">{$message}</div>{/if}
      {foreach from=$categories item=cat}
        <h2>{$cat.name}</h2>
		{assign var=resultCount value=$cat.results|@count}
        <table class="table">
          <thead>
            <tr><th>Model</th><th>Score</th><th>Głosy</th><th></th></tr>
          </thead>
          <tbody>
            {foreach from=$cat.results item=res name=resLoop}
              {if $smarty.foreach.resLoop.index == 10}
          </tbody>
          <tbody id="collapse-cat-{$cat.id}" class="collapse">
              {/if}
            <tr>
              <td>{$res.model.name}</td>
              <td>{$res.score}</td>
              <td>{$res.votes}</td>
              <td>
                <form method="post" class="d-flex gap-2 align-items-center flex-wrap">
                  <input type="hidden" name="model_id" value="{$res.model.id}" />
                  <input type="hidden" name="category_id" value="{$cat.id}" />
					<div class="captcha-container d-none">
						<img data-src="/admin/utils/captcha/captcha.php" alt="captcha" class="captcha-img d-none" />
						<input type="text" name="captcha" placeholder="captcha" class="form-control w-auto d-none" />
						<small class="text-muted captcha-info d-none">Przepisz czarne znaki, aby oddać głos</small>
					</div>
                  <button type="button" name="vote" class="btn btn-sm btn-primary">Głosuj</button>
                </form>
              </td>
            </tr>
            {/foreach}
          </tbody>
        </table>
		{if $resultCount > 10}
			<button class="btn btn-link p-0" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-cat-{$cat.id}" aria-expanded="false" aria-controls="collapse-cat-{$cat.id}">Pokaż więcej</button>
        {/if}
      {/foreach}
    </div>
  </section>
</main>