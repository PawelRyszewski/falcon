	<div class="container-fluid">
		<div class="row mb-4">
			<div class="col-12 col-lg">
				<h1 class="main-title"><span>Dodaj działkę</span></h1>
			</div>
			<div class="col d-flex align-items-end flex-column">
                <a href="/admin/nieruchomosci" class="mt-auto p-2">
                    <button type="button" class="btn btn-primary">Powrót</button>
                </a>				
			</div>			
		</div>
		
		<div class="row block-white">
			<div class="col-12">
				<div class="content">					
					<form class="p-3" name="edit-page-form" id="edit-page-form" method="post">
					
						<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#ustawieniaSeo" aria-expanded="false" aria-controls="ustawieniaSeo">
						Ustawienia SEO <span class="icon-arrow-right"></span> 
						</button>			

						<div class="collapse mb-3" id="ustawieniaSeo">
							<div class="card card-body">

								<div class="form-group">
									<label>Title (SEO)</label>
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
									<input type="text" class="form-control" name="url" placeholder="link-do-nieruchomosci" id="url" onkeydown="timeOutCheckUrl()">
									<small id="url-error" class="red" style="display:none;">*Podany URL jest zajęty</small>
									<small>*Jeżeli pozostawisz to pole puste adres URL wygeneruje sie automatycznie na podstawie
										tytułu</small>
								</div>
								
							</div>
						</div>			

						<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#parterPietro" aria-expanded="false" aria-controls="parterPietro">
						Parter / Piętro / Poddasze <span class="icon-arrow-right"></span>
						</button>

						<div class="collapse mb-3" id="parterPietro">
							<div class="card card-body">

								<h6 class="mb-3">Parter, piętro i poddasze</h6>
								<p class="text-muted small">Zdjęcia sekcji można przypisać po dodaniu nieruchomości i wgraniu fotografii.</p>

								<div class="form-check mb-2">
								  <input class="form-check-input" type="checkbox" name="has_parter" id="has_parter" value="1">
								  <label class="form-check-label" for="has_parter">Pokaż sekcję <strong>Parter</strong></label>
								</div>

								<div id="parter_section" style="display:none;" class="border rounded p-3 mb-3 bg-light">
								  <div class="form-group">
									<label>Treść sekcji Parter</label>
									<textarea id="parter_content" name="parter_content"></textarea>
								  </div>
								</div>

								<div class="form-check mb-2">
								  <input class="form-check-input" type="checkbox" name="has_pietro" id="has_pietro" value="1">
								  <label class="form-check-label" for="has_pietro">Pokaż sekcję <strong>Piętro</strong></label>
								</div>

								<div id="pietro_section" style="display:none;" class="border rounded p-3 mb-3 bg-light">
								  <div class="form-group">
									<label>Treść sekcji Piętro</label>
									<textarea id="pietro_content" name="pietro_content"></textarea>
								  </div>
								</div>

								<div class="form-check mb-2">
								  <input class="form-check-input" type="checkbox" name="has_poddasze" id="has_poddasze" value="1">
								  <label class="form-check-label" for="has_poddasze">Pokaż sekcję <strong>Poddasze</strong></label>
								</div>

								<div id="poddasze_section" style="display:none;" class="border rounded p-3 mb-3 bg-light">
								  <div class="form-group">
									<label>Treść sekcji Poddasze</label>
									<textarea id="poddasze_content" name="poddasze_content"></textarea>
								  </div>
								</div>

							</div>
						</div>								
					
						<div class="form-group">
							<label>Tytuł</label>
							<input type="text" class="form-control" name="title" id="title" onblur="javascript: validateTitle(this, this.value);" onkeypress="javascript: validateTitle(this, this.value);">
							<small id="title-error" class="red" style="display:none;">*Tytuł musi posiadać min 5 znaków</small>
						</div>	

						<div class="form-group">
							<label>Osiedle</label>
							<select class="form-control" name="category">
								<option value="0">- Brak kategorii -</option>
								{foreach from=$categories item=item}
									<option value="{$item.id}">{$item.name}</option>
								{/foreach}
							</select>
						</div>

						<div class="form-group">
							<label>Status domu</label>
							<select class="form-control" name="house_status">
								<option value="wolne">Wolne</option>
								<option value="rezerwacja">Rezerwacja</option>
								<option value="niedostepne">Niedostępne</option>
							</select>
						</div>

						<div class="row">
							<div class="col-md-4">
								<div class="form-group">
									<label>Powierzchnia działki</label>
									<input type="text" class="form-control" name="plot_area" placeholder="np. 600 m²">
								</div>
							</div>
							<div class="col-md-4">
								<div class="form-group">
									<label>Powierzchnia użytkowa</label>
									<input type="text" class="form-control" name="usable_area" placeholder="np. 182,81 m²">
								</div>
							</div>
							<div class="col-md-4">
								<div class="form-group">
									<label>Cena</label>
									<input type="text" class="form-control" name="house_price" placeholder="np. 2 350 000 zł">
								</div>
							</div>
						</div>

						<div class="form-group">
							<label>Opis</label>
							<textarea id="tinymice" name="content">

							</textarea>
						</div>

						<hr>
						<div class="w-100 text-right">
							<button type="button" class="btn btn-success" onClick="validUrlAndSubmit()">Dodaj nieruchomość</button>
							<button hidden type="submit" name="add_realestate" onClick="javascript: submitForm(event);" class="btn btn-success" id="add_realestate">Dodaj nieruchomość</button>
						</div>
					</form>				
				</div>
			</div>				
		</div>				
	</div>						
						

{literal}
    <script>
        // #5: TinyMCE for floor sections
        if (typeof tinymce !== 'undefined') {
            tinymce.init({
                language: 'pl',
                selector: '#parter_content, #pietro_content, #poddasze_content',
                width: '100%',
                height: 300,
                plugins: 'advlist autolink link lists charmap searchreplace wordcount code fullscreen table paste',
                toolbar: 'undo redo | bold italic | alignleft aligncenter alignright | bullist numlist | link | table | code | fullscreen',
                menubar: false,
                content_css: ['../../../utils/css/bootstrap.css', '../../../utils/css/style-min.css'],
                content_style: 'td, th { border: 1px solid #878787 !important; }',
            });
        }

        // #5: Checkbox toggles for floor sections
        var DEFAULT_PARTER_TABLE = '<table style="border-collapse:collapse;width:100%;" border="1"><tbody><tr><td>0/1</td><td>Hall</td><td> m2</td></tr><tr><td>0/2</td><td>Pokój dzienny + aneks kuchenny</td><td> m2</td></tr><tr><td>0/3</td><td>Spiżarnia</td><td> m2</td></tr><tr><td>0/4</td><td>Łazienka</td><td> m2</td></tr><tr><td>0/5</td><td>Schody</td><td> m2</td></tr><tr><td>0/6</td><td>Garaż</td><td> m2</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>Łącznie  m2</td></tr></tbody></table>';
        var DEFAULT_PIETRO_TABLE = '<table style="border-collapse:collapse;width:100%;" border="1"><tbody><tr><td>1/1</td><td>Sypialnia 1</td><td> m2</td></tr><tr><td>1/2</td><td>Garderoba</td><td> m2</td></tr><tr><td>1/3</td><td>Łazienka 1</td><td> m2</td></tr><tr><td>1/4</td><td>Pomieszczenie techniczne.</td><td> m2</td></tr><tr><td>1/5</td><td>Łazienka 2</td><td> m2</td></tr><tr><td>1/6</td><td>Korytarz</td><td> m2</td></tr><tr><td>1/7</td><td>Schody</td><td> m2</td></tr><tr><td>1/8</td><td>Sypialnia 2</td><td> m2</td></tr><tr><td>1/9</td><td>Sypialnia 3</td><td> m2</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>Łącznie  m2</td></tr></tbody></table>';
        var DEFAULT_PODDASZE_TABLE = '<table style="border-collapse:collapse;width:100%;" border="1"><tbody><tr><td>P/1</td><td>Pokój 1</td><td> m2</td></tr><tr><td>P/2</td><td>Pokój 2</td><td> m2</td></tr><tr><td>P/3</td><td>Łazienka</td><td> m2</td></tr><tr><td>P/4</td><td>Korytarz</td><td> m2</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>Łącznie  m2</td></tr></tbody></table>';

        function setDefaultFloorContent(editorId, defaultContent) {
            var ed = typeof tinymce !== 'undefined' ? tinymce.get(editorId) : null;
            if (ed) {
                if (ed.getContent().replace(/\s/g, '') === '') {
                    ed.setContent(defaultContent);
                }
            } else {
                var ta = document.getElementById(editorId);
                if (ta && ta.value.trim() === '') {
                    ta.value = defaultContent;
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            var hasParterCb     = document.getElementById('has_parter');
            var hasPietroCb     = document.getElementById('has_pietro');
            var hasPoddaszeCb   = document.getElementById('has_poddasze');
            var parterSection   = document.getElementById('parter_section');
            var pietroSection   = document.getElementById('pietro_section');
            var poddaszeSection = document.getElementById('poddasze_section');

            if (hasParterCb) {
                hasParterCb.addEventListener('change', function() {
                    parterSection.style.display = this.checked ? '' : 'none';
                    if (this.checked) {
                        setDefaultFloorContent('parter_content', DEFAULT_PARTER_TABLE);
                    }
                });
            }
            if (hasPietroCb) {
                hasPietroCb.addEventListener('change', function() {
                    pietroSection.style.display = this.checked ? '' : 'none';
                    if (this.checked) {
                        setDefaultFloorContent('pietro_content', DEFAULT_PIETRO_TABLE);
                    }
                });
            }
            if (hasPoddaszeCb) {
                hasPoddaszeCb.addEventListener('change', function() {
                    poddaszeSection.style.display = this.checked ? '' : 'none';
                    if (this.checked) {
                        setDefaultFloorContent('poddasze_content', DEFAULT_PODDASZE_TABLE);
                    }
                });
            }

            // Sync TinyMCE floor editors before submit
            var addBtn = document.getElementById('add_realestate');
            if (addBtn) {
                addBtn.addEventListener('click', function() {
                    if (typeof tinymce !== 'undefined') {
                        ['parter_content', 'pietro_content', 'poddasze_content'].forEach(function(id) {
                            var ed = tinymce.get(id);
                            if (ed) ed.save();
                        });
                    }
                }, true);
            }
        });

        var myVar;

        async function timeOutCheckUrl() {
            const url = $("#url")
            const id_page = $("#id_page")
            clearTimeout(myVar);
            myVar = setTimeout(async function() {
                const isUrlValid = await checkIsIssetUrlInDb(url.val(), id_page.val())
    
                if (isUrlValid > 0) {
                    messagesValidationMenager(true, 'url')
                } else {
                    messagesValidationMenager(false, 'url')
                }
            }, 1000);
        }
        async function validUrl() {
            const url = $("#url")
            const id_page = $("#id_page")
    
            if (url.val().length < 3) {
                generatedUrlByTitile()
            }
    
            const isUrlValid = await checkIsIssetUrlInDb(url.val(), id_page.val())
    
            if (isUrlValid > 0) {
                messagesValidationMenager(true, 'url')
            } else {
                messagesValidationMenager(false, 'url')
            }
            return isUrlValid
        }
    
    
        async function validUrlAndSubmit() {
            const isUrlValid = await validUrl()
    
            if (isUrlValid == 0) {
                $("#add_realestate").click()
            }
        }
    </script>
{/literal}
