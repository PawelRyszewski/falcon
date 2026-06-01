<div class="container-fluid">
<div class="row mb-4">
	<div class="col-12 col-lg">
		<h1 class="main-title"><span>Dodaj podstronę</span></h1>
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
			<div class="table-responsive-md">
				<div class="table-wrapper">
					<form class="p-3" name="edit-page-form" id="edit-page-form" method="post">

						<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#ustawieniaSeo" aria-expanded="false" aria-controls="ustawieniaSeo">
							Ustawienia SEO <span class="icon-arrow-right"></span>
						</button>

						<div class="collapse mb-3" id="ustawieniaSeo">
							<div class="card card-body">
								<div class="form-group">
									<label>Title</label>
									<input type="text" class="form-control" name="title_seo">
								</div>
								<div class="form-group">
									<label>Description</label>
									<input type="text" class="form-control" name="description">
								</div>
								<div class="form-group">
									<label>Keywords</label>
									<input type="text" class="form-control" name="keywords">
								</div>
								<div class="form-group">
									<label>Adres URL</label>
									<label class="float-right create-url" onclick="javascript: generatedUrlByTitile()">Generuj URL na
										podstawie tytułu</label>
									<input type="text" class="form-control" name="url" placeholder="nazwa-twojej-podstrony" id="url">
									<small>*Jeżeli pozostawisz to pole puste adres URL wygeneruje sie automatycznie na podstawie
										tytułu</small>
								</div>

							</div>
						</div>

						<div class="form-group">
							<label>Tytuł</label>
							<input type="text" class="form-control" name="title" id="title" onblur="javascript: validateTitle(this, this.value);" onkeypress="javascript: validateTitle(this, this.value);">
							<small id="title-error" class="red" style="display:none;">*Tytuł musi posiadać min 5 znaków</small>
						</div>
						<div class="form-group">
							<label>Język</label>
							<select class="form-control" name="lang">
									<option value="0">Wybierz język</option>
									 {foreach from=$languages item=item}
											<option value="{$item.id}" {if $item.is_default==1}selected{/if}>{$item.name}</option>
									{/foreach}
							</select>
						</div>
						<div class="form-group">
								<label>Kategoria</label>
								<select class="form-control" name="category">
										<option value="0">Wybierz kategorię</option>
										{foreach from=$categories item=cat}
												<option value="{$cat.id}">{$cat.name}</option>
										{/foreach}
								</select>
						</div>
						<div class="form-group">
							<label>Treść</label>
							<textarea id="tinymice" name="content"></textarea>
						</div>

						<div class="form-group">
							<label>Pokaż w menu głównym</label>
							<select class="form-control max-content" name="show_in_main_menu">
								<option value="0">Nie</option>
								<option value="1">Tak</option>
							</select>
						</div>

						<button type="submit" name="add_page_and_show" onClick="javascript: submitForm(event);" class="btn btn-success">Zapisz i opublikuj</button>
						<button type="submit" name="add_page" onClick="javascript: submitForm(event);" class="btn btn-primary">Zapisz</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
</div>

{literal}
<script>
	function inputValues(){
		let seo1 = $('input[name="title_seo"]');
		let seo2 = $('input[name="description"]');
		let seo3 = $('input[name="keywords"]');		

		let contentTitle = $('input#title').val();
		let lengthTitle = $('input#title').val().length;	
		
		let lengthSeo1 = $(seo1).val().length;
		let lengthSeo2 = $(seo2).val().length;
		let lengthSeo3 = $(seo3).val().length;		

		console.log(lengthSeo1);
		console.log(lengthTitle);
		
		if (lengthSeo1 == 0) {
			$(seo1).val(contentTitle);
		} 		
		if (lengthSeo2 == 0) {
			$(seo2).val(contentTitle);
		} 		
		if (lengthSeo3 == 0) {
			$(seo3).val(contentTitle);
		} 				
	}
	inputValues()

	$('input#title').on('change', function(event) {
		inputValues();
	});		
</script>
{/literal}