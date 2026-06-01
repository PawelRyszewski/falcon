	<div class="container-fluid">
	    <div class="row mb-4">
	        <div class="col-12 col-lg">
				<h1 class="main-title"><span>{$gallery.title}</span></h1>				
				<h5><span>Zarządzaj listą zdjęć</span></h5>
	        </div>
	        <div class="col d-flex align-items-end flex-column">
	            <a href="/admin/galeria-zdjec" class="mt-auto p-2">
	                <button type="button" class="btn btn-primary">Powrót</button>
	            </a>
	        </div>
	    </div>

	    <div class="row block-white">

	        <ul class="nav nav-tabs" role="tablist">
	            <li class="nav-item active"><a class="nav-link active" href="#menu1" role="tab" data-toggle="tab">Dodaj fotografię</a></li>
	            <li class="nav-item"><a class="nav-link" href="#menu2" role="tab" data-toggle="tab">Edycja treści</a></li>
	            <li class="nav-item"><a class="nav-link" href="#menu3" role="tab" data-toggle="tab">Zarządzanie listą zdjęć</a></li>
	        </ul>

	        <div class="tab-content">

	            <div role="tabpanel" class="col-12 tab-pane fade active show" id="menu1">
	                <div class="content">
	                    <h2 class="title"><span class="icon-content-dodaj-zdjecie mr-2"></span>Dodaj fotografię</h2>

	                    <form class="p-3" name="edit-page-form" id="edit-page-form" method="post" enctype="multipart/form-data">
	                        <div class="form-group">
	                            <label>Dodaj zdjęcia</label>
	                            <input name="upload[]" type="file" multiple="multiple" id="multiupload" accept="image/png,image/gif,image/jpeg,image/webp" />
	                            <p class="red">*Zmiana nazwy zdjęcia działa tylko przy dodawaniu nowych zdjęć, po dodaniu nie ma możliwości zmiany nazwy zdjęcia. Nazwa zdjęcie generowana jest na podstawie wprowadzonego tytułu.</p>
	                            {* <input name="img_name_1" type="text" /> *}
	                        </div>
	                        <div class="gallery_preview"></div>
	                        <button type="submit" name="add_images" class="btn btn-success" onClick="javascript: addImages(event);">Dodaj zdjęcia</button>
	                    </form>

	                </div>
	            </div>

	            <div class="col-12 tab-pane fade in" id="menu2">
	                <div class="content">
	                    <h2 class="title"><span class="icon-content-edytuj-tresc mr-2"></span> Edycja treści</h2>

	                    <form class="p-3" role="tabpanel" name="edit-page-form" id="edit-page-form" method="post">

	                        <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#ustawieniaSeo" aria-expanded="false" aria-controls="ustawieniaSeo">
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
	                                    <input type="text" class="form-control" name="description" value="{$gallery.description}">
	                                </div>
	                                <div class="form-group">
	                                    <label>Keywords</label>
	                                    <input type="text" class="form-control" name="keywords" value="{$gallery.keywords}">
	                                </div>
	                                <div class="form-group">
	                                    <label>Adres URL</label>
	                                    <label class="float-right create-url" onclick="javascript: generatedUrlByTitile()">Generuj URL na
	                                        podstawie tytułu</label>
	                                    <input type="text" class="form-control" name="url" placeholder="nazwa-twojej-galerii" id="url" value="{$gallery.url}" onkeydown="timeOutCheckUrl()">
	                                    <small id="url-error" class="red" style="display:none;">*Podany URL jest zajęty</small>
	                                    <small>*Jeżeli pozostawisz to pole puste adres URL wygeneruje sie automatycznie na podstawie
	                                        tytułu</small>
	                                </div>

	                            </div>
	                        </div>

	                        <div class="form-group">
	                            <label>Tytuł</label>
	                            <input type="text" class="form-control" name="title" id="title" onblur="javascript: validateTitle(this, this.value);" onkeypress="javascript: validateTitle(this, this.value);" value="{$gallery.title}">
	                            <small id="title-error" class="red" style="display:none;">*Tytuł musi posiadać min 5 znaków</small>
	                        </div>

	                        <div class="form-group">
	                            <label>Treść</label>
	                            <textarea id="tinymice" name="content">
									{$gallery.content}
								</textarea>
	                        </div>
	                        <button type="button" class="btn btn-success" onClick="validUrlAndSubmit()">Edytuj galerię</button>
	                        <button hidden type="submit" name="edit_gallery" onClick="javascript: submitForm(event);" class="btn btn-success" id="edit_gallery">Edytuj galerię</button>
	                    </form>

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
    	                        <div class="col {if $item.id === $gallery.img}active{/if}">
    	                            <form method="POST" class="p-2 mb-2 sortableElement">
    	                            <input type="checkbox" value="{$item.id}" class="images-to-delete-checkbox" />
										{if $gallery.id == 111}
											<a class="gallery-image-link" href="./../../../ai-materials/uploads/{$item.name}"><img src="./../../../ai-materials/uploads/thumb/{$item.name}" style="max-width:100%;margin:0 auto;height: 160px;border: 1px solid #545454;display: block;" title="Nazwa: {$item.name}, Tytuł: {$item.title}" /></a>
											{else}
											<a class="gallery-image-link" href="./../../../uploads/{$item.name}"><img src="./../../../uploads/thumb/{$item.name}" style="max-width:100%;margin:0 auto;height: 160px;border: 1px solid #545454;display: block;" title="Nazwa: {$item.name}, Tytuł: {$item.title}" /></a>
                                        {/if}
										
										<p class="pt-2 mb-0">Tytuł zdjęcia</p>
										<input class="form-control mt-0 mb-1" type="text" value="{$item.title}" placeholder="Tytuł zdjęcia" name="img_title" />
    	                                
										<p class="pt-2 mb-0">Link do zdjęcia</p>
                                        {if $gallery.id == 111}
											<input class="form-control" type="text" value="https://{$smarty.server.HTTP_HOST}/ai-materials/uploads/{$item.name}" />
											{else}
											<input class="form-control" type="text" value="https://{$smarty.server.HTTP_HOST}/uploads/{$item.name}" />
                                        {/if}
										
										<input type="hidden" value="{$item.id}" name="img_id" class="img_id" />
    	                                <input type="hidden" value="{$item.name}" name="img_name" class="img_name" />
    	                                <button type="submit" name="edit_title" class="btn btn-success">Aktualizuj</button>
    	                                {if $item.id === $gallery.img}
        	                                {*<div class="main-photo">Zdjęcie główne</div>*}
    	                                {else}
        	                                {*<button type="submit" name="set_main" class="btn btn-primary">Główne</button>*}
    	                                {/if}
    	                                <button type="submit" name="del_img" class="btn btn-danger float-right" onclick="return confirm('Czy usunąć wybrane zdjęcie?')">Usuń zdjęcie</button>
    	                            </form>
    	                        </div>
	                        {/foreach}
	                    </div>

	                </div>
	            </div>

	        </div>

	    </div>
	</div>


	<input type="hidden" value="{$gallery.id}" id="id_gallery" />
	<input type="hidden" value="{$gallery.id}" id="id_page" />
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
    	    $('.gallery-image-link').magnificPopup({
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
    	            $("#edit_gallery").click()
    	        }
    	    }
    	    $(function() {
    	        $("#sortable").sortable({
    	            update: (event, ui) => {
    	                $("#spinner").css("display", "flex")
    	                const elems = $(".sortableElement")
    	                const data = {}
    	                const id_gallery = $("#id_gallery").val()
    	                let i = 0
    	                for (let item of elems) {
    	                    const id = $(item).find(".img_id").val()
    	                    data[i] = id
    	                    i++
    	                }
    	                $.ajax({
    	                    url: "./../../utils/php/ajax-change-img-queue.php?id_gallery=" + id_gallery,
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
    	</script>
    
    
    	<script>
    
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
    	        imagesPreview(this, 'div.gallery_preview');
    	    });
    	</script>
	{/literal}