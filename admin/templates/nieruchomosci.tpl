{literal}
<style>
	.row .card img{
	 max-width:100px;
	}
	.row .card h4 {
	font-size:16px;
	}
	.realestate-table-view td { vertical-align: middle; }
	.realestate-table-view .thumb { width: 60px; height: 45px; object-fit: cover; border-radius: 3px; }
	.realestate-view-toggle .btn.active { background:#0d6efd; color:#fff; }
</style>
{/literal}
<main>
	<div class="container-fluid">
		<div class="row mb-4">
			<div class="col-12 col-lg">
				<h1 class="main-title"><span>Lista nieruchomości</span></h1>
			</div>
			<div class="col d-flex align-items-end flex-column">
				<div class="mt-auto d-flex align-items-center">
					<div class="btn-group realestate-view-toggle me-2" role="group" aria-label="Widok listy">
						<button type="button" class="btn btn-outline-primary btn-sm" id="view-toggle-blocks" title="Widok blokowy">
							<span class="icon-content-zarzadzanie-galeria"></span> Bloki
						</button>
						<button type="button" class="btn btn-outline-primary btn-sm" id="view-toggle-table" title="Widok tabeli">
							<span class="icon-content-edytuj-tresc"></span> Tabela
						</button>
					</div>
					<a href="/admin/nieruchomosci/kategorie" class="p-2">
						<button type="button" class="btn btn-primary">Zarządzaj osiedlami</button>
					</a>
					<a href="/admin/nieruchomosci/dodaj" class="p-2">
						<button type="button" class="btn btn-primary">Dodaj nieruchomość</button>
					</a>
				</div>
			</div>
		</div>

		<div id="realestate-blocks-view">
		{foreach from=$realestates_grouped key=catName item=group name=catLoop}
			<div class="d-flex align-items-center mt-4 mb-2 gap-2">
				<h2 class="h5 fw-bold mb-0">{$catName}</h2>
				{if $group|@count > 2}
				<form method="POST" style="margin-left:auto">
					<input type="hidden" name="cat_id" value="{$group[0].category}">
					<button type="submit" name="reverse_order"
					        class="btn btn-sm btn-outline-secondary"
					        style="font-size:0.75rem;padding:2px 8px;"
					        title="Odwróć kolejność nieruchomości w tej kategorii">
						↕ Odwróć kolejność
					</button>
				</form>
				{/if}
			</div>
			<hr class="mt-0 mb-3">

			<div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-3 mb-4 sortable-realestate-row"
			     id="sortable-cat-{$smarty.foreach.catLoop.index}">
				{foreach from=$group item=$realestate}
					<div class="col sortable-realestate-item" data-id="{$realestate.id}">
						<div class="card shadow-sm h-100{if $realestate.is_hide == 1} border-secondary opacity-75{/if}">
							<a href="/admin/nieruchomosci/edytuj/{$realestate.id}" style="background:#ededed;padding:5px;cursor:grab;" class="linked-img text-center">
								<img src="{if isset($mainImages[$realestate.img][0])}/uploads/thumb/{$mainImages[$realestate.img][0]}{else}/utils/images/no-image.png{/if}"
								     alt="{$realestate.title}"
								     style="width:100%;border-bottom:1px solid #dfdfdf"
								     class="hover-shadow"
								     title="{$realestate.title}">
							</a>

							<div class="card-body d-flex flex-column">
								{if $realestate.is_hide == 1}<span class="badge bg-secondary mb-1">Ukryta</span>{/if}
								<h4>
									<a href="/admin/nieruchomosci/edytuj/{$realestate.id}" title="{$realestate.title}">{$realestate.title}</a>
								</h4>
								{*<small class="text-gray bold mb-2">{$realestate.description}</small>*}

								{assign var=hs value=$realestate.house_status|default:''}
								<small class="d-block mb-3">
									Status:
									{if $hs == 'wolne'}
										<span class="text-success fw-bold">Wolne</span>
									{elseif $hs == 'rezerwacja'}
										<span class="text-warning fw-bold">Rezerwacja</span>
									{elseif $hs == 'niedostepne'}
										<span class="text-danger fw-bold">Niedostępne</span>
									{else}
										—
									{/if}
								</small>

								<div class="mt-auto d-flex flex-wrap gap-2" style="gap:5px;">
									<a href="/admin/nieruchomosci/edytuj/{$realestate.id}" class="btn btn-outline-primary">Edytuj</a>
									<a href="/admin/nieruchomosci/kopiuj/{$realestate.id}" class="btn  btn-outline-info"
									   onclick="return confirm('Czy na pewno chcesz skopiować tę nieruchomość wraz ze zdjęciami?');">Kopiuj</a>

									<form method="POST" class="d-inline">
										<input type="hidden" name="id_page" value="{$realestate.id}">
										<input type="hidden" name="is_hide" value="{if $realestate.is_hide == 1}0{else}1{/if}">
										<button type="submit" name="toggle_publish" class="btn btn-outline-secondary">
											{if $realestate.is_hide == 1}Publikuj{else}Ukryj{/if}
										</button>
									</form>

									<a href="/admin/nieruchomosci/usun/{$realestate.id}" class="btn btn-outline-danger"
									   onclick="return confirm('Czy na pewno chcesz usunąć tę nieruchomość?');">Usuń</a>
								</div>
							</div>
						</div>
					</div>
				{/foreach}
			</div>
		{foreachelse}
			<p class="text-muted mt-4">Brak nieruchomości.</p>
		{/foreach}
		</div>

		<div id="realestate-table-view" style="display:none;">
		{foreach from=$realestates_grouped key=catName item=group name=catTblLoop}
			<div class="d-flex align-items-center mt-4 mb-2 gap-2">
				<h2 class="h5 fw-bold mb-0">{$catName}</h2>
				{if $group|@count > 2}
				<form method="POST" style="margin-left:auto">
					<input type="hidden" name="cat_id" value="{$group[0].category}">
					<button type="submit" name="reverse_order"
					        class="btn btn-sm btn-outline-secondary"
					        style="font-size:0.75rem;padding:2px 8px;">
						↕ Odwróć kolejność
					</button>
				</form>
				{/if}
			</div>
			<hr class="mt-0 mb-2">
			<div class="table-responsive mb-4">
				<table class="table table-sm table-hover realestate-table-view align-middle">
					<thead>
						<tr>
							<th style="width:30px;"></th>
							<th style="width:80px;">Zdjęcie</th>
							<th>Tytuł</th>
							<th style="width:130px;">Status</th>
							<th style="width:120px;">Widoczność</th>
							<th style="width:240px;" class="text-end">Akcje</th>
						</tr>
					</thead>
					<tbody class="sortable-realestate-tbody">
					{foreach from=$group item=$realestate}
						<tr class="sortable-realestate-tr{if $realestate.is_hide == 1} text-muted{/if}" data-id="{$realestate.id}">
							<td class="text-center realestate-drag-handle" title="Przeciągnij, aby zmienić kolejność" style="cursor:grab;">≡</td>
							<td>
								<a href="/admin/nieruchomosci/edytuj/{$realestate.id}">
									<img class="thumb" src="{if isset($mainImages[$realestate.img][0])}/uploads/thumb/{$mainImages[$realestate.img][0]}{else}/utils/images/no-image.png{/if}" alt="{$realestate.title}">
								</a>
							</td>
							<td>
								<a href="/admin/nieruchomosci/edytuj/{$realestate.id}" title="{$realestate.title}">{$realestate.title}</a>
							</td>
							<td>
								{assign var=hs2 value=$realestate.house_status|default:''}
								{if $hs2 == 'wolne'}
									<span class="text-success fw-bold">Wolne</span>
								{elseif $hs2 == 'rezerwacja'}
									<span class="text-warning fw-bold">Rezerwacja</span>
								{elseif $hs2 == 'niedostepne'}
									<span class="text-danger fw-bold">Niedostępne</span>
								{else}
									—
								{/if}
							</td>
							<td>
								<form method="POST" class="d-inline">
									<input type="hidden" name="id_page" value="{$realestate.id}">
									<input type="hidden" name="is_hide" value="{if $realestate.is_hide == 1}0{else}1{/if}">
									<button type="submit" name="toggle_publish"
									        class="btn btn-sm {if $realestate.is_hide == 1}btn-outline-secondary{else}btn-outline-success{/if}"
									        title="{if $realestate.is_hide == 1}Kliknij aby opublikować{else}Kliknij aby ukryć{/if}">
										{if $realestate.is_hide == 1}🚫 Ukryta{else}👁 Widoczna{/if}
									</button>
								</form>
							</td>
							<td class="text-end">
								<a href="/admin/nieruchomosci/edytuj/{$realestate.id}" class="btn btn-sm btn-outline-primary">Edytuj</a>
								<a href="/admin/nieruchomosci/kopiuj/{$realestate.id}" class="btn btn-sm btn-outline-info"
								   onclick="return confirm('Czy na pewno chcesz skopiować tę nieruchomość wraz ze zdjęciami?');">Kopiuj</a>
								<a href="/admin/nieruchomosci/usun/{$realestate.id}" class="btn btn-sm btn-outline-danger"
								   onclick="return confirm('Czy na pewno chcesz usunąć tę nieruchomość?');">Usuń</a>
							</td>
						</tr>
					{/foreach}
					</tbody>
				</table>
			</div>
		{foreachelse}
			<p class="text-muted mt-4">Brak nieruchomości.</p>
		{/foreach}
		</div>

	</div>
</main>

<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
{literal}
<style>
.sortable-realestate-item { cursor: grab; }
.sortable-realestate-item.ui-sortable-helper { opacity: .85; cursor: grabbing; box-shadow: 0 8px 24px rgba(0,0,0,.18); }
.sortable-realestate-item.ui-sortable-placeholder { visibility: visible !important; background: #e9f0ff; border: 2px dashed #6c9bd2; border-radius: 8px; }
.sortable-realestate-tr.ui-sortable-helper { background:#f8f9fa; box-shadow:0 4px 12px rgba(0,0,0,.15); }
.sortable-realestate-tr.ui-sortable-placeholder { visibility: visible !important; background:#e9f0ff !important; height:50px; }
#queue-save-indicator { position:fixed; bottom:20px; right:20px; z-index:9999; display:none; }
</style>
<div id="queue-save-indicator">
    <span class="badge bg-success p-2" id="queue-saved-msg">✓ Kolejność zapisana</span>
    <span class="badge bg-secondary p-2" id="queue-saving-msg" style="display:none;">Zapisuję...</span>
</div>
<script>
(function () {
    var COOKIE_NAME = 'admin_realestate_view';
    function readCookie(name) {
        var nameEQ = name + '=';
        var parts = document.cookie.split(';');
        for (var i = 0; i < parts.length; i++) {
            var c = parts[i].replace(/^\s+/, '');
            if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length);
        }
        return null;
    }
    function writeCookie(name, value, days) {
        var d = new Date();
        d.setTime(d.getTime() + (days * 24 * 60 * 60 * 1000));
        document.cookie = name + '=' + value + ';expires=' + d.toUTCString() + ';path=/;SameSite=Lax';
    }
    function applyView(view) {
        var blocks = document.getElementById('realestate-blocks-view');
        var table  = document.getElementById('realestate-table-view');
        var bBtn   = document.getElementById('view-toggle-blocks');
        var tBtn   = document.getElementById('view-toggle-table');
        if (!blocks || !table) return;
        if (view === 'table') {
            blocks.style.display = 'none';
            table.style.display = '';
            if (bBtn) bBtn.classList.remove('active');
            if (tBtn) tBtn.classList.add('active');
        } else {
            blocks.style.display = '';
            table.style.display = 'none';
            if (bBtn) bBtn.classList.add('active');
            if (tBtn) tBtn.classList.remove('active');
        }
    }
    document.addEventListener('DOMContentLoaded', function () {
        var saved = readCookie(COOKIE_NAME);
        applyView(saved === 'table' ? 'table' : 'blocks');
        var bBtn = document.getElementById('view-toggle-blocks');
        var tBtn = document.getElementById('view-toggle-table');
        if (bBtn) bBtn.addEventListener('click', function () { writeCookie(COOKIE_NAME, 'blocks', 365); applyView('blocks'); });
        if (tBtn) tBtn.addEventListener('click', function () { writeCookie(COOKIE_NAME, 'table', 365); applyView('table'); });
    });
})();
</script>
<script>
$(function () {
    function showQueueIndicator(state) {
        $('#queue-save-indicator').show();
        $('#queue-saving-msg').hide();
        $('#queue-saved-msg').hide();
        if (state === 'saving') {
            $('#queue-saving-msg').show();
        } else {
            $('#queue-saved-msg').show();
            setTimeout(function () { $('#queue-save-indicator').fadeOut(); }, 1500);
        }
    }

    $('.sortable-realestate-row').each(function () {
        var $row = $(this);
        $row.sortable({
            items: '.sortable-realestate-item',
            tolerance: 'pointer',
            placeholder: 'col sortable-realestate-item ui-sortable-placeholder',
            forcePlaceholderSize: true,
            update: function () {
                var ids = [];
                $row.find('.sortable-realestate-item').each(function (i) {
                    ids[i] = $(this).data('id');
                });
                showQueueIndicator('saving');
                $.ajax({
                    url: '/admin/utils/php/ajax-realestate-queue.php',
                    type: 'POST',
                    data: ids,
                    complete: function () { showQueueIndicator('saved'); }
                });
            }
        });
        $row.disableSelection();
    });

    $('.sortable-realestate-tbody').each(function () {
        var $tbody = $(this);
        $tbody.sortable({
            items: '.sortable-realestate-tr',
            handle: '.realestate-drag-handle',
            tolerance: 'pointer',
            helper: function (e, tr) {
                var $originals = tr.children();
                var $helper = tr.clone();
                $helper.children().each(function (index) {
                    $(this).width($originals.eq(index).width());
                });
                return $helper;
            },
            update: function () {
                var ids = {};
                $tbody.find('.sortable-realestate-tr').each(function (i) {
                    ids[i] = $(this).data('id');
                });
                showQueueIndicator('saving');
                $.ajax({
                    url: '/admin/utils/php/ajax-realestate-queue.php',
                    type: 'POST',
                    data: ids,
                    complete: function () { showQueueIndicator('saved'); }
                });
            }
        });
        $tbody.disableSelection();
    });
});
</script>
{/literal}
