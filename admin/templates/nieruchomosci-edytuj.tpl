	<div class="container-fluid">
	    <div class="row mb-4">
	        <div class="col-12 col-lg">
				<h1 class="main-title"><span>{$realestate.title}</span></h1>				
				<h5><span>Edytuj działkę</span></h5>
	        </div>
	        <div class="col d-flex align-items-end flex-column">

					<a href="/admin/nieruchomosci" class="mt-auto p-2">
						<button type="button" class="btn btn-primary">Powrót</button>
					</a>
	        </div>
	    </div>

	    <div class="row block-white">

	        <ul class="nav nav-tabs" role="tablist">
	            <li class="nav-item active"><a class="nav-link active" href="#menu2" role="tab" data-toggle="tab">Edycja treści</a></li>
	            <li class="nav-item"><a class="nav-link" href="#menu1" role="tab" data-toggle="tab">Dodaj fotografię</a></li>
	            <li class="nav-item"><a class="nav-link" href="#menu4" role="tab" data-toggle="tab">Pliki do pobrania</a></li>
	            <li class="nav-item"><a class="nav-link" href="#menu3" role="tab" data-toggle="tab">Zarządzanie listą zdjęć</a></li>
	        </ul>

	        <div class="tab-content">

	            <div role="tabpanel" class="col-12 tab-pane fade" id="menu1">
	                <div class="content">
	                    <h2 class="title"><span class="icon-content-dodaj-zdjecie mr-2"></span>Dodaj fotografię</h2>

	                    <form class="p-3" name="edit-page-form" id="edit-page-form" method="post" enctype="multipart/form-data">
	                        <div class="form-group">
	                            <label>Dodaj zdjęcia</label>
	                            <input name="upload[]" type="file" multiple="multiple" id="multiupload" accept="image/png,image/gif,image/jpeg,image/webp"/>
	                            <p class="red">*Zmiana nazwy zdjęcia działa tylko przy dodawaniu nowych zdjęć, po dodaniu nie ma możliwości zmiany nazwy zdjęcia. Nazwa zdjęcie generowana jest na podstawie wprowadzonego tytułu.</p>
	                            {* <input name="img_name_1" type="text" /> *}
	                        </div>
	                        <div class="realestate_preview"></div>
	                        <button type="submit" name="add_images" class="btn btn-success" onClick="javascript: addImages(event);">Dodaj zdjęcia</button>
	                    </form>

	                </div>
	            </div>

	            <div class="col-12 tab-pane fade active show" id="menu2">
	                <div class="content">
	                    <h2 class="title"><span class="icon-content-edytuj-tresc mr-2"></span> Edycja treści</h2>

	                    <form class="p-3" role="tabpanel" name="edit-page-form" id="edit-page-form" method="post">

	                        <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#ustawieniaSeo" aria-expanded="false" aria-controls="ustawieniaSeo">
	                            Ustawienia SEO <span class="icon-arrow-right"></span>
	                        </button>

	                        <div class="collapse mb-3" id="ustawieniaSeo">
	                            <div class="card card-body">

	                                <div class="form-group">
	                                    <label>Title (SEO)</label>
	                                    <input type="text" class="form-control" name="title_seo" value="{$realestate.title_seo}">
	                                </div>
	                                <div class="form-group">
	                                    <label>Description</label>
	                                    <input type="text" class="form-control" name="description" value="{$realestate.description}">
	                                </div>
	                                <div class="form-group">
	                                    <label>Keywords</label>
	                                    <input type="text" class="form-control" name="keywords" value="{$realestate.keywords}">
	                                </div>
	                                <div class="form-group">
	                                    <label>Adres URL</label>
	                                    <label class="float-right create-url" onclick="javascript: generatedUrlByTitile()">Generuj URL na
	                                        podstawie tytułu</label>
	                                    <input type="text" class="form-control" name="url" placeholder="link-do-nieruchomosci" id="url" value="{$realestate.url}" onkeydown="timeOutCheckUrl()">
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

								<div class="form-check mb-2">
								<input class="form-check-input" type="checkbox" name="has_parter" id="has_parter" value="1"
								{if $realestate.has_parter == 1}checked{/if}>
								<label class="form-check-label" for="has_parter">Pokaż sekcję <strong>Parter</strong></label>
								</div>

								<div id="parter_section" {if $realestate.has_parter != 1}style="display:none;"{/if} class="border rounded p-3 mb-3 bg-light">
								<div class="form-group mb-3">
								<label>Zdjęcie parteru <small class="text-muted">(wybierz z galerii nieruchomości)</small></label>
								<div class="d-flex flex-wrap gap-2 mt-2">
								  {foreach from=$images item=img}
									<label class="position-relative" style="cursor:pointer;">
									  <input type="radio" name="parter_img_id" value="{$img.id}"
										{if $realestate.parter_img_id == $img.id}checked{/if}
										class="position-absolute top-0 start-0 m-1">
									  <img src="./../../../uploads/thumb/{$img.name}" alt="{$img.title}"
										   style="width:80px;height:60px;object-fit:cover;border-radius:4px;
												  {if $realestate.parter_img_id == $img.id}outline:2px solid #0d6efd;{/if}">
									</label>
								  {foreachelse}
									<p class="text-muted small mb-0">Brak zdjęć w galerii. Dodaj zdjęcia w zakładce "Dodaj fotografię".</p>
								  {/foreach}
								  <label style="cursor:pointer;line-height:60px;">
									<input type="radio" name="parter_img_id" value="0"
									  {if !$realestate.parter_img_id}checked{/if}> Brak zdjęcia
								  </label>
								</div>
								</div>
								<div class="form-group">
								<label>Treść sekcji Parter</label>
								<textarea id="parter_content" name="parter_content">{$realestate.parter_content}</textarea>
								</div>
								</div>

								<div class="form-check mb-2">
								<input class="form-check-input" type="checkbox" name="has_pietro" id="has_pietro" value="1"
								{if $realestate.has_pietro == 1}checked{/if}>
								<label class="form-check-label" for="has_pietro">Pokaż sekcję <strong>Piętro</strong></label>
								</div>

								<div id="pietro_section" {if $realestate.has_pietro != 1}style="display:none;"{/if} class="border rounded p-3 mb-3 bg-light">
								<div class="form-group mb-3">
								<label>Zdjęcie piętra <small class="text-muted">(wybierz z galerii nieruchomości)</small></label>
								<div class="d-flex flex-wrap gap-2 mt-2">
								  {foreach from=$images item=img}
									<label class="position-relative" style="cursor:pointer;">
									  <input type="radio" name="pietro_img_id" value="{$img.id}"
										{if $realestate.pietro_img_id == $img.id}checked{/if}
										class="position-absolute top-0 start-0 m-1">
									  <img src="./../../../uploads/thumb/{$img.name}" alt="{$img.title}"
										   style="width:80px;height:60px;object-fit:cover;border-radius:4px;
												  {if $realestate.pietro_img_id == $img.id}outline:2px solid #0d6efd;{/if}">
									</label>
								  {foreachelse}
									<p class="text-muted small mb-0">Brak zdjęć w galerii.</p>
								  {/foreach}
								  <label style="cursor:pointer;line-height:60px;">
									<input type="radio" name="pietro_img_id" value="0"
									  {if !$realestate.pietro_img_id}checked{/if}> Brak zdjęcia
								  </label>
								</div>
								</div>
								<div class="form-group">
								<label>Treść sekcji Piętro</label>
								<textarea id="pietro_content" name="pietro_content">{$realestate.pietro_content}</textarea>
								</div>
								</div>

								<div class="form-check mb-2">
								<input class="form-check-input" type="checkbox" name="has_poddasze" id="has_poddasze" value="1"
								{if $realestate.has_poddasze == 1}checked{/if}>
								<label class="form-check-label" for="has_poddasze">Pokaż sekcję <strong>Poddasze</strong></label>
								</div>

								<div id="poddasze_section" {if $realestate.has_poddasze != 1}style="display:none;"{/if} class="border rounded p-3 mb-3 bg-light">
								<div class="form-group mb-3">
								<label>Zdjęcie poddasza <small class="text-muted">(wybierz z galerii nieruchomości)</small></label>
								<div class="d-flex flex-wrap gap-2 mt-2">
								  {foreach from=$images item=img}
									<label class="position-relative" style="cursor:pointer;">
									  <input type="radio" name="poddasze_img_id" value="{$img.id}"
										{if $realestate.poddasze_img_id == $img.id}checked{/if}
										class="position-absolute top-0 start-0 m-1">
									  <img src="./../../../uploads/thumb/{$img.name}" alt="{$img.title}"
										   style="width:80px;height:60px;object-fit:cover;border-radius:4px;
												  {if $realestate.poddasze_img_id == $img.id}outline:2px solid #0d6efd;{/if}">
									</label>
								  {foreachelse}
									<p class="text-muted small mb-0">Brak zdjęć w galerii.</p>
								  {/foreach}
								  <label style="cursor:pointer;line-height:60px;">
									<input type="radio" name="poddasze_img_id" value="0"
									  {if !$realestate.poddasze_img_id}checked{/if}> Brak zdjęcia
								  </label>
								</div>
								</div>
								<div class="form-group">
								<label>Treść sekcji Poddasze</label>
								<textarea id="poddasze_content" name="poddasze_content">{$realestate.poddasze_content}</textarea>
								</div>
								</div>

								</div>
							</div>	

	                        <div class="form-group">
	                            <label>Tytuł</label>
	                            <input type="text" class="form-control" name="title" id="title" onblur="javascript: validateTitle(this, this.value);" onkeypress="javascript: validateTitle(this, this.value);" value="{$realestate.title}">
	                            <small id="title-error" class="red" style="display:none;">*Tytuł musi posiadać min 5 znaków</small>
	                        </div>

							<div class="form-group">
								<label>Osiedle</label>
								<select class="form-control" name="category">
									<option value="0" {if $realestate.category==0}selected{/if}>- Brak kategorii -</option>
									{foreach from=$categories item=item}
										<option value="{$item.id}" {if $realestate.category==$item.id}selected{/if}>{$item.name}</option>
									{/foreach}
								</select>
							</div>

							<div class="form-group">
								<label>Status domu</label>
								<select class="form-control" name="house_status">
									<option value="wolne" {if $realestate.house_status=='wolne'}selected{/if}>Wolne</option>
									<option value="rezerwacja" {if $realestate.house_status=='rezerwacja'}selected{/if}>Rezerwacja</option>
									<option value="niedostepne" {if $realestate.house_status=='niedostepne'}selected{/if}>Niedostępne</option>
								</select>
							</div>

							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label>Powierzchnia działki</label>
										<input type="text" class="form-control" name="plot_area" value="{$realestate.plot_area}" placeholder="np. 600 m²">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>Powierzchnia użytkowa</label>
										<input type="text" class="form-control" name="usable_area" value="{$realestate.usable_area}" placeholder="np. 182,81 m²">
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>Cena</label>
										<input type="text" class="form-control" name="house_price" value="{$realestate.house_price}" placeholder="np. 2 350 000 zł">
									</div>
								</div>
							</div>

	                        <div class="form-group">
	                            <label>Treść</label>
	                            <textarea id="tinymice" name="content">
									{$realestate.content}
								</textarea>
	                        </div>

							{* #5: Parter / Piętro sections *}

							<hr>
	                        <button type="button" class="btn btn-success" onClick="validUrlAndSubmit()">Zapisz zmiany</button>
	                        <button hidden type="submit" name="edit_realestate" onClick="javascript: submitForm(event);" class="btn btn-success" id="edit_realestate">Zapisz zmiany</button>
	                    </form>

	                </div>
	            </div>
				
	            <div role="tabpanel" class="col-12 tab-pane fade" id="menu4">
	                <div class="content">
	                    <h2 class="title">Pliki do pobrania</h2>

	                    {* Upload form *}
	                    <form class="p-3 mb-4 border rounded" method="post" enctype="multipart/form-data">
	                      <h6>Dodaj plik</h6>
	                      <div class="row g-3 align-items-end">
	                        <div class="col-md-4">
	                          <label class="form-label">Plik (PDF, JPG, PNG, WebP)</label>
	                          <input type="file" name="investment_file" class="form-control"
	                                 accept=".pdf,.jpg,.jpeg,.png,.webp" required>
	                        </div>
	                        <div class="col-md-5">
	                          <label class="form-label">Tytuł pliku</label>
	                          <input type="text" name="file_title" class="form-control" placeholder="np. Rzut parteru">
	                        </div>
	                        <div class="col-md-3">
	                          <button type="submit" name="add_investment_file" class="btn btn-success w-100">Dodaj plik</button>
	                        </div>
	                      </div>
	                    </form>

	                    {* Existing files grid *}
	                    {if $investment_files_admin}
	                      <div class="row g-3">
	                        {foreach from=$investment_files_admin item=ifile}
	                          <div class="col-sm-6 col-md-4 col-lg-3">
	                            <div class="card h-100">
	                              {if $ifile.file_type == 'image'}
	                                <img src="./../../../uploads/thumb/{$ifile.file_path|replace:'/uploads/':''}"
	                                     alt="{$ifile.title}"
	                                     class="card-img-top"
	                                     style="height:120px;object-fit:cover;">
	                              {else}
	                                <div class="card-img-top d-flex align-items-center justify-content-center bg-light"
	                                     style="height:120px;">
	                                  <div class="text-center">
	                                    <span class="fw-bold text-danger d-block" style="font-size:1.5rem;">PDF</span>
	                                    <small class="text-muted">{$ifile.title}</small>
	                                  </div>
	                                </div>
	                              {/if}
	                              <div class="card-body p-2">
	                                <form method="post" class="mb-2">
	                                  <input type="hidden" name="file_id" value="{$ifile.id}">
	                                  <input type="text" name="file_title" class="form-control form-control-sm mb-1"
	                                         value="{$ifile.title}">
	                                  <button type="submit" name="update_investment_file_title"
	                                          class="btn btn-sm btn-outline-primary w-100">Zapisz tytuł</button>
	                                </form>
	                                <form method="post" onsubmit="return confirm('Usunąć plik?')">
	                                  <input type="hidden" name="file_id" value="{$ifile.id}">
	                                  <button type="submit" name="delete_investment_file"
	                                          class="btn btn-sm btn-danger w-100">Usuń</button>
	                                </form>
	                              </div>
	                            </div>
	                          </div>
	                        {/foreach}
	                      </div>
	                    {else}
	                      <p class="text-muted">Brak plików do pobrania dla tej nieruchomości.</p>
	                    {/if}
	                </div>
	            </div>

	            <div role="tabpanel" class="col-12 tab-pane fade" id="menu3">
	                <div class="content">
	                    <h2 class="title">
	                        <span class="icon-content-zarzadzanie-galeria mr-2"></span>
	                        Zarządzanie zdjęciami
	                        <form method="POST">
	                            <button class="btn btn-danger float-right" type="submit" name="delete_selected_images" id="delete_selected_images">Usuń wybrane zdjęcia</button>
	                            <input type="hidden" name="images_to_delete" id="images_to_delete" />
	                        </form>
	                    </h2>
	                    <p>Przeciągnij zdjęcie w odpowiednie miejsce, aby ustawić kolejność</p>
	                    <div class="row lista-zdjec" id="sortable">
	                        {foreach from=$images item=item key=key name=name}
    	                        <div class="col {if $item.id === $realestate.img}active{/if}">
    	                            <form method="POST" class="p-2 mb-2 sortableElement">
    	                            <input type="checkbox" value="{$item.id}" class="images-to-delete-checkbox" />
    	                                <div class="position-relative">
    	                                    <a class="realestate-image-link" href="./../../../uploads/{$item.name}"><img src="./../../../uploads/thumb/{$item.name}" style="max-width:100%;margin:0 auto;height:160px;border:1px solid #545454;display:block;{if $item.hide_from_slider}opacity:.35;{/if}" title="Nazwa: {$item.name}, Tytuł: {$item.title}" /></a>
    	                                    {if $item.hide_from_slider}<span style="position:absolute;top:6px;left:6px;background:rgba(0,0,0,.6);color:#fff;font-size:11px;padding:2px 6px;border-radius:4px;">Ukryte na sliderze</span>{/if}
    	                                </div>
    	                                <input class="form-control mt-3 mb-1" type="text" value="{$item.title}" placeholder="Tytuł zdjęcia" name="img_title" />
    	                                <input type="hidden" value="{$item.id}" name="img_id" class="img_id" />
    	                                <input type="hidden" value="{$item.name}" name="img_name" class="img_name" />
    	                                <button type="submit" name="edit_title" class="btn btn-success btn-sm">Aktualizuj</button>
    	                                {if $item.id === $realestate.img}
        	                                <div class="main-photo">Zdjęcie główne</div>
    	                                {else}
        	                                <button type="submit" name="set_main" class="btn btn-primary btn-sm">Główne</button>
    	                                {/if}
    	                                <button type="button"
    	                                        class="btn btn-sm {if $item.hide_from_slider}btn-secondary{else}btn-outline-secondary{/if} btn-toggle-slider"
    	                                        data-img-id="{$item.id}"
    	                                        data-hidden="{if $item.hide_from_slider}1{else}0{/if}"
    	                                        title="{if $item.hide_from_slider}Pokaż na sliderze{else}Ukryj na sliderze{/if}">
    	                                    {if $item.hide_from_slider}👁 Pokaż{else}🚫 Ukryj na sliderze{/if}
    	                                </button>
    	                                <button type="submit" name="del_img" class="btn btn-danger btn-sm float-right" onclick="return confirm('Czy usunąć wybrane zdjęcie?')">Usuń</button>
    	                            </form>
    	                        </div>
	                        {/foreach}
	                    </div>

	                </div>
	            </div>


	        </div>

	    </div>
	</div>


	<input type="hidden" value="{$realestate.id}" id="id_realestate" />
	<input type="hidden" value="{$realestate.id}" id="id_page" />
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	{literal}
    	<script>
    	    /* IMAGE POPUP */
    	    $('#delete_selected_images').on("click", function(e) {
    	        const imagesToDelete = $("#images_to_delete").val()
    
    	        if (imagesToDelete.length) {
    	            return confirm("Czy usunąć wybrane zdjęcia?")
    	        } else {
    	            e.preventDefault()
    	            return alert("Nie zaznaczono zdjęć")
    	        }
    	    });
    
    	    $(".images-to-delete-checkbox").change(function(event, target) {
    	        const idImagesToDel = $(".images-to-delete-checkbox").get().reduce((acc, input) => {
    	            const value = input.value
    	            const isChecked = input.checked
    	            if (isChecked) {
    	                if (!!acc) {
    	                    return acc + "," + value
    	                } else {
    	                    return value
    	                }
    	            }
    	            return acc
    	        }, "")
    	        $("#images_to_delete").val(idImagesToDel)
    	    })
    	    $('.realestate-image-link').magnificPopup({
    	        type: 'image',
    	        mainClass: 'mfp-with-zoom',
    	        zoom: {
    	            enabled: true,
    	            duration: 300,
    	            easing: 'ease-in-out',
    	            opener: function(openerElement) {
    	                return openerElement.is('img') ? openerElement : openerElement.find('img');
    	            }
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
    	            $("#edit_realestate").click()
    	        }
    	    }
    	    $(function() {
    	        $("#sortable").sortable({
    	            update: (event, ui) => {
    	                $("#spinner").css("display", "flex")
    	                const elems = $(".sortableElement")
    	                const data = {}
    	                const id_realestate = $("#id_realestate").val()
    	                let i = 0
    	                for (let item of elems) {
    	                    const id = $(item).find(".img_id").val()
    	                    data[i] = id
    	                    i++
    	                }
    	                $.ajax({
    	                    url: "./../../utils/php/ajax-change-img-queue.php?id_realestate=" + id_realestate,
    	                    type: "POST",
    	                    data: data,
    	                    success: function(response) {
    	                        if (response === 'ok') {
    
    	                        }
    	                        $("#spinner").css("display", "none")
    	                    }
    	                });
    	            }
    	        });
    	        $("#sortable").disableSelection();
    	    });

    	    // Toggle hide_from_slider per image
    	    $(document).on('click', '.btn-toggle-slider', function () {
    	        var btn     = $(this);
    	        var imgId   = btn.data('img-id');
    	        var hidden  = parseInt(btn.data('hidden'), 10);
    	        var newHide = hidden ? 0 : 1;
    	        $.ajax({
    	            url: './../../utils/php/ajax-toggle-slider-img.php',
    	            type: 'POST',
    	            data: { img_id: imgId, hide: newHide },
    	            dataType: 'json',
    	            success: function (res) {
    	                if (!res.ok) return;
    	                btn.data('hidden', newHide);
    	                var card = btn.closest('.sortableElement');
    	                var img  = card.find('.realestate-image-link img');
    	                var lbl  = card.find('.slider-hidden-label');
    	                if (newHide) {
    	                    btn.removeClass('btn-outline-secondary').addClass('btn-secondary');
    	                    btn.html('&#128065; Pokaż').attr('title', 'Pokaż na sliderze');
    	                    img.css('opacity', '0.35');
    	                    if (!lbl.length) {
    	                        img.closest('.position-relative').prepend('<span class="slider-hidden-label" style="position:absolute;top:6px;left:6px;background:rgba(0,0,0,.6);color:#fff;font-size:11px;padding:2px 6px;border-radius:4px;">Ukryte na sliderze</span>');
    	                    }
    	                } else {
    	                    btn.removeClass('btn-secondary').addClass('btn-outline-secondary');
    	                    btn.html('&#128683; Ukryj').attr('title', 'Ukryj na sliderze');
    	                    img.css('opacity', '1');
    	                    lbl.remove();
    	                }
    	            }
    	        });
    	    });
    	</script>
    
    
    	<script>
    	    // #5: TinyMCE for floor sections (separate init from #tinymice in footer.tpl)
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
    	    });

    	    // #5: Sync TinyMCE floor editors before form submit
    	    document.addEventListener('DOMContentLoaded', function() {
    	        var saveBtn = document.getElementById('edit_realestate');
    	        if (saveBtn) {
    	            saveBtn.addEventListener('click', function() {
    	                if (typeof tinymce !== 'undefined') {
    	                    ['parter_content', 'pietro_content', 'poddasze_content'].forEach(function(id) {
    	                        var ed = tinymce.get(id);
    	                        if (ed) ed.save();
    	                    });
    	                }
    	            }, true);
    	        }
    	    });

    	    function addImages(event) {
    	        const imageNames = $('.image_name')
    	        let index = 0
    
    	        if (!imageNames.length) {
    	            event.preventDefault()
    	            return alert("Nie dodano zdjęć")
    	        }
    
    	        for (let item of imageNames) {
    	            const elem = $(item);
    	            const titleValue = $(".img_title_" + index).val()
    
    	            if (titleValue.length > 4) {
    	                elem.val(removeDiacritics(titleValue, true))
    	            }
    
    	            index++
    	        }
    	        $("#spinner").css("display", "flex")
    	    }
    
    	    var imagesPreview = function(input, placeToInsertImagePreview) {
    
    	        if (input.files) {
    	            var filesAmount = input.files.length;
    	            var counter = 0;
    	            for (i = 0; i < filesAmount; i++) {
    	                const fileName = input.files[i].name
    	                var reader = new FileReader();
    
    	                reader.onload = function(event) {
    	                    const filenameToArray = fileName.split('.')
    	                    const fileExt = filenameToArray[filenameToArray.length - 1]
    	                    const imgTag = `<img src=${event.target.result} style="max-height:100px;max-width:150px;margin:5px;" />`;
    	                    filenameToArray.pop()
    	                    const inputFileNameTag = `<div class="form-group" hidden><label>Nazwa zdjęcia</label><input class="form-control image_name" type="text" value="${filenameToArray.join("")}" name="img_name_${counter}"/></div>`                          
    	                    const inputTitleTag = `<div class="form-group"><label>Tytuł zdjęcia</label><input class="form-control img_title_${counter}" type="text" value="" name="img_title_${counter}" /></div>`
    	                    const imageExt = `<input type="hidden" value="${fileExt}" name="img_ext_${counter}"/>`
    	                    $(`<div>${imgTag}${inputFileNameTag}${inputTitleTag}${imageExt}<hr></div>`).appendTo(placeToInsertImagePreview);
    	                    counter++
    	                }
    
    	                reader.readAsDataURL(input.files[i]);
    	            }
    	        }
    
    	    };
    
    	    $('#multiupload').on('change', function() {
    	        let isValid = true;
    	        const validFormats = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    
    	        if (this.files) {
    	            const filesAmount = this.files.length;
    	            for (i = 0; i < filesAmount; i++) {
    	                const fileName = this.files[i].name
    	                const filenameToArray = fileName.split('.')
    	                const fileExt = filenameToArray[filenameToArray.length - 1]
    	                if (!validFormats.includes(fileExt.toLocaleLowerCase())) {
    	                    isValid = false;
    	                }
    	            }
    	        }
    	        if (!isValid) {
    	            alert("Poprawne formaty zdjęć to " + validFormats.join(", "))
    	            this.value = "";
    	            return false
    	        }
    	        imagesPreview(this, 'div.realestate_preview');
    	    });
    	</script>
	{/literal}
