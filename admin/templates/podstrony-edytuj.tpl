<div class="container-fluid">
<div class="row mb-4">
	<div class="col-12 col-lg">
		<h1 class="main-title"><span>{$page.title}</span></h1>
		<h5><span>Edytuj podstronę</span></h5>
	</div>
	<div class="col d-flex align-items-end flex-column">
		<a href="/admin/podstrony" class="mt-auto p-2">
			<button type="button" class="btn btn-primary">Powrót</button>
		</a>
	</div>
</div>

<div class="row block-white">
	<div class="col-12">
		<div class="content">

			<form class="p-3" name="edit-page-form" id="edit-page-form" method="post">

				<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse"
					data-target="#ustawieniaSeo" aria-expanded="false" aria-controls="ustawieniaSeo">
					Ustawienia SEO <span class="icon-arrow-right"></span>
				</button>

				<div class="collapse mb-3" id="ustawieniaSeo">
					<div class="card card-body">
						<div class="form-group">
							<label>Title</label>
							<input type="text" class="form-control" name="title_seo" value="{$page.title_seo}">
						</div>
						<div class="form-group">
							<label>Description</label>
							<input type="text" class="form-control" name="description" value="{$page.description}">
						</div>
						<div class="form-group">
							<label>Keywords</label>
							<input type="text" class="form-control" name="keywords" value="{$page.keywords}">
						</div>
						{if !$is_homepage}
						<div class="form-group">
							<label>Adres URL</label>
							<label class="float-right create-url"
								onclick="javascript: generatedUrlByTitile()">Generuj URL na
								podstawie tytułu</label>
							<input type="text" class="form-control" name="url" placeholder="nazwa-twojej-podstrony"
								id="url" value="{$page.url}">
							<small>*Jeżeli pozostawisz to pole puste adres URL wygeneruje sie automatycznie na
								podstawie tytułu</small>
						</div>
						{else}
						<input type="hidden" id="url" value="">
						{/if}
					</div>
				</div>

				<div class="form-group">
					<label>Tytuł</label>
					<input type="text" class="form-control" name="title" id="title" value="{$page.title}"
						onblur="javascript: validateTitle(this, this.value);"
						onkeypress="javascript: validateTitle(this, this.value);">
					<small id="title-error" class="red" style="display:none;">*Tytuł musi posiadać min 5
						znaków</small>
				</div>
				<div class="form-group">
					<label>Język</label>
					<select class="form-control" name="lang">
							<option value="0">Wybierz język</option>
								{foreach from=$languages item=item}
										<option value="{$item.id}" {if $page.lang==$item.id}selected{/if}>{$item.name}</option>
								{/foreach}
					</select>
				</div>
				<div class="form-group">
						<label>Kategoria</label>
						<select class="form-control" name="category">
								<option value="0">Wybierz kategorię</option>
								{foreach from=$categories item=cat}
										<option value="{$cat.id}" {if $page.category==$cat.id}selected{/if}>{$cat.name}</option>
								{/foreach}
						</select>
				</div>

				<div class="form-group">
					<label>Opublikuj</label>
					<select class="form-control" name="is_published">
						<option value="0" {if $page.is_published==0}selected{/if}>Nie</option>
						<option value="1" {if $page.is_published==1}selected{/if}>Tak</option>
					</select>
				</div>

				{if $is_homepage}
				<div class="form-group">
					<label><strong>Grafika główna (baner)</strong></label>
					<p class="text-muted small mb-2">Wybierz grafikę, która wyświetli się jako baner na stronie głównej. Grafiki zarządzasz w <a href="/admin/galeria-zdjec/edytuj/60" target="_blank">Galerii zdjęć</a>.</p>
					<input type="hidden" id="hero_image_id" name="hero_image_id" value="{$page.img}">
					{assign var=hero_selected_name value=''}
					{foreach from=$gallery_images item=gimg}
						{if $gimg.id == $page.img}{assign var=hero_selected_name value=$gimg.name}{/if}
					{/foreach}
					<div id="hero_img_preview" class="mb-2" {if !$hero_selected_name}style="display:none"{/if}>
						<img id="hero_img_thumb" src="/uploads/thumb/{$hero_selected_name}" alt=""
							style="height:90px;object-fit:cover;border-radius:4px;border:2px solid #007bff;">
						<br><small class="text-muted">Wybrana grafika</small>
					</div>
					<div>
						<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#galleryPickerModal">
							Wybierz grafikę z galerii
						</button>
						<button type="button" class="btn btn-sm btn-outline-danger ml-2" id="btn_clear_hero" onclick="clearHeroImage()" {if !$hero_selected_name}style="display:none"{/if}>
							Usuń grafikę
						</button>
					</div>
				</div>

				<div id="hero-overlay-section" {if !$hero_selected_name}style="display:none"{/if}>
					<div class="form-group">
						<label><strong>Treść na grafice (nakładka)</strong></label>
						<p class="text-muted small mb-2">Ten tekst wyświetli się na tle wybranej grafiki.</p>
						<textarea id="tinymice_hero" name="content_short">{$page.content_short}</textarea>
					</div>
				</div>
				{/if}

				<div class="form-group">
					<label>Treść</label>
					<textarea id="tinymice" name="content">
						{$page.content}
					</textarea>
				</div>

				{if !$is_homepage}
				<div class="form-group">
					<label>Pokaż w menu głównym</label>
					<select class="form-control max-content" name="show_in_main_menu">
						<option value="0" {if $page.show_in_menu==0}selected="selected" {/if}>Nie</option>
						<option value="1" {if $page.show_in_menu==1}selected="selected" {/if}>Tak</option>
					</select>
				</div>
				{/if}

				<button type="submit" name="edit_page" onClick="javascript: submitForm(event);"
					class="btn btn-success">Edytuj podstronę</button>
			</form>

		</div>
	</div>
</div>
</div>

{if $is_homepage}
<!-- Gallery picker modal -->
<div class="modal fade" id="galleryPickerModal" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Wybierz grafikę z galerii</h5>
				<button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
			</div>
			<div class="modal-body">
				{if $gallery_images}
				<div style="display:flex;flex-wrap:wrap;gap:8px;max-height:420px;overflow-y:auto;">
					{foreach from=$gallery_images item=gimg}
					<div onclick="selectHeroImage({$gimg.id}, '{$gimg.name|escape}')" style="cursor:pointer;" title="{$gimg.title}">
						<img src="/uploads/thumb/{$gimg.name}" alt="{$gimg.title}"
							style="width:120px;height:90px;object-fit:cover;border-radius:4px;border:2px solid #dee2e6;"
							class="hero-picker-thumb" data-img-id="{$gimg.id}">
					</div>
					{/foreach}
				</div>
				{else}
				<p class="text-muted">Brak zdjęć w galerii. <a href="/admin/galeria-zdjec/edytuj/60" target="_blank">Dodaj zdjęcia do galerii</a>.</p>
				{/if}
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
			</div>
		</div>
	</div>
</div>

{literal}
<script>
function selectHeroImage(imgId, imgName) {
	document.getElementById('hero_image_id').value = imgId;

	document.querySelectorAll('.hero-picker-thumb').forEach(function(t) {
		t.style.border = '2px solid #dee2e6';
	});
	var selected = document.querySelector('.hero-picker-thumb[data-img-id="' + imgId + '"]');
	if (selected) selected.style.border = '2px solid #007bff';

	var thumb = document.getElementById('hero_img_thumb');
	if (thumb) {
		thumb.src = '/uploads/thumb/' + imgName;
	}
	document.getElementById('hero_img_preview').style.display = 'block';
	document.getElementById('btn_clear_hero').style.display = '';

	$('#galleryPickerModal').modal('hide');

	var overlaySection = document.getElementById('hero-overlay-section');
	if (overlaySection.style.display === 'none' || overlaySection.style.display === '') {
		overlaySection.style.display = 'block';
		if (!tinymce.get('tinymice_hero')) {
			initHeroTinyMce();
		}
	}
}

function clearHeroImage() {
	document.getElementById('hero_image_id').value = '';
	document.getElementById('hero_img_preview').style.display = 'none';
	document.getElementById('btn_clear_hero').style.display = 'none';
	document.querySelectorAll('.hero-picker-thumb').forEach(function(t) {
		t.style.border = '2px solid #dee2e6';
	});
	document.getElementById('hero-overlay-section').style.display = 'none';
}

function initHeroTinyMce() {
	tinymce.init({
		language: 'pl',
		selector: '#tinymice_hero',
		width: '100%',
		height: 350,
		plugins: [
			'advlist autolink link lists charmap preview hr',
			'searchreplace wordcount visualblocks code fullscreen',
			'table paste help'
		],
		toolbar: 'undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist | link | forecolor backcolor | code | help',
		menubar: false,
		content_css: [
			'../../../utils/css/bootstrap.css',
			'../../../utils/css/style-min.css'
		]
	});
}
</script>
{/literal}

{if $hero_selected_name}
<script>
document.addEventListener('DOMContentLoaded', function() {
	// Mark the currently saved image in the modal picker
	var currentId = document.getElementById('hero_image_id').value;
	if (currentId) {
		var thumb = document.querySelector('.hero-picker-thumb[data-img-id="' + currentId + '"]');
		if (thumb) thumb.style.border = '2px solid #007bff';
	}
	if (!tinymce.get('tinymice_hero')) {
		initHeroTinyMce();
	}
});
</script>
{/if}
{/if}
