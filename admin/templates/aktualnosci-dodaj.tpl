	<div class="container-fluid">
	    <div class="row mb-4">
	        <div class="col-12 col-lg">
	            <h1 class="main-title"><span> Dodaj artykuł</span></h1>
	        </div>
	        <div class="col d-flex align-items-end flex-column">
	            <a href="/admin/aktualnosci" class="mt-auto p-2">
	                <button type="button" class="btn btn-primary">Powrót</button>
	            </a>
	        </div>
	    </div>

	    <div class="row block-white">
	        <div class="col-12">
	            <div class="content">
	                <div class="table-responsive-md">
	                    <div class="table-wrapper">

	                        <form class="p-3" name="edit-page-form" id="edit-page-form" method="post" enctype="multipart/form-data">

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
	                                        <input type="text" class="form-control" name="url" placeholder="nazwa-twojej-aktualnosci" id="url" onkeydown="timeOutCheckUrl()">
	                                        <small id="url-error" class="red" style="display:none;">*Podany URL jest zajęty</small>
	                                        <small>*Jeżeli pozostawisz to pole puste adres URL wygeneruje sie automatycznie na podstawie
	                                            tytułu</small>
	                                    </div>

	                                </div>
	                            </div>

								<div class="form-group">
									<label>Zdjęcie</label>
									<input type="file" class="form-control" name="img" id="multiupload">
									<div class="gallery_preview"></div>
								</div>

								<div class="form-group">
									<label>Lub wybierz z galerii</label>
                                        <div class="d-flex align-items-center">
                                            <button type="button" class="btn btn-secondary" id="open_gallery_popup">Wybierz zdjęcie</button>
                                            <input type="hidden" name="img_from_gallery" id="img_from_gallery" />
                                        </div>
									
									<div id="gallery_selected_preview" class="mt-2"></div>
								</div>
								
								<div id="gallery_popup" class="mfp-hide">
									{if $gallery_images|@count gt 0}
										{foreach from=$gallery_images key=group item=imgs}
											<h5>{$group}</h5>
											<div class="row images">
												{foreach from=$imgs item=img}
													<div class="img">
														<img src="{$img.thumb}" data-name="{$img.name}" alt="{$img.title}" class="img-fluid img-thumbnail selectable-img" style="cursor:pointer;" />
													</div>
												{/foreach}
											</div>
										{/foreach}
									{else}
										<p>Brak zdjęć w galerii</p>
									{/if}
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
                                        {foreach from=$categories item=item}                                            
    	                                    <option value="{$item.id}">{$item.name}</option>
	                                    {/foreach}
	                                </select>
	                            </div>
	                            <div class="form-group">
	                                <label>Krótki opis</label>
	                                <textarea class="form-control" name="content_short"></textarea>
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

	                            <button type="button" class="btn btn-success" onClick="validUrlAndSubmit()">Zapisz i opublikuj</button>
	                            <button type="button" class="btn btn-primary" onClick="validUrlAndSubmitSave()">Zapisz</button>
	                            <button hidden type="submit" name="add_news" onClick="javascript: checkImgName(event); submitForm(event);" class="btn btn-success" id="add_news"></button>
	                            <button hidden type="submit" name="save_news" onClick="javascript: checkImgName(event); submitForm(event);" class="btn btn-success" id="save_news"></button>
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
		
    	    var myVar;
    
    	    function timeOutCheckUrl() {
    	        const url = $("#url")
    	        clearTimeout(myVar);
    	        myVar = setTimeout(async function() {
    
    	            const isUrlValid = await checkIsIssetUrlInDb(url.val())
    
    	            if (isUrlValid > 0) {
    	                messagesValidationMenager(true, 'url')
    	            } else {
    	                messagesValidationMenager(false, 'url')
    	            }
    	        }, 1000);
    	    }
    	    async function validUrl() {
    	        const url = $("#url")
    	        const id_page = $("#id_page").val()
    
    	        if (url.val().length < 3) {
    	            generatedUrlByTitile()
    	        }
    
    	        const isUrlValid = await checkIsIssetUrlInDb(url.val())
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
    	            $("#add_news").click()
    	        }
    	    }
    	    async function validUrlAndSubmitSave() {
    	        const isUrlValid = await validUrl()
    	        if (isUrlValid == 0) {
    	            $("#save_news").click()
    	        }
    	    }
    
    	    function checkImgName() {
    	        const elem = $('input[name="img_name_0"]');
    	        if (elem) {
    	            const imgName = elem.val()
    	            imgName && elem.val(removeDiacritics(imgName, true))
    	        }
    	    }
    
    	    var imagesPreview = function(input, placeToInsertImagePreview) {
    
    	        if (input.files) {
    	            var filesAmount = input.files.length;
    	            var counter = 0;
    	            for (i = 0; i < filesAmount; i++) {
    	                const fileName = input.files[i].name
    	                var reader = new FileReader();
    
    	                reader.onload = function(event) {
    	                    console.log(counter, 'counter')
    	                    const filenameToArray = fileName.split('.')
    	                    const fileExt = filenameToArray[filenameToArray.length - 1]
    	                    const imgTag = `<img src=${event.target.result} style="max-height:100px;max-width:150px;margin:5px;" />`;
    	                    filenameToArray.pop()
    	                    const inputFileNameTag = `<div class="form-group"><label>Nazwa zdjęcia</label><input class="form-control" type="text" value="${filenameToArray.join("")}" name="img_name_${counter}"/></div>`                          
    	                    const inputTitleTag = `<div class="form-group"><label>Tytuł zdjęcia</label><input class="form-control" type="text" value="" name="img_title_${counter}"/></div>`
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

                $('#open_gallery_popup').magnificPopup({items:{src:'#gallery_popup'}, type:'inline', midClick:true});

                $(document).on('click', '#gallery_popup img.selectable-img', function(){
                    const name = $(this).data('name');
                    const thumb = $(this).attr('src');
                    $('#img_from_gallery').val(name);
                    $('#gallery_selected_preview').html(`<img src="${thumb}" style="max-height:100px;max-width:150px;margin:5px;"/>`);
                    $.magnificPopup.close();               
			   
                });
            </script>
    {/literal}