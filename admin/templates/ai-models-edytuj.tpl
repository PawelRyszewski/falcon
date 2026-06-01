<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Edytuj model</span></h1>
        </div>
        <div class="col d-flex align-items-end flex-column">
            <div class="mt-auto d-flex">
                <a href="/admin/ai-models" class="p-2">
                    <button type="button" class="btn btn-primary">Powrót</button>
                </a>
            </div>
        </div>
    </div>

    <div class="row block-white">
        <div class="col-12">
            <div class="content">
                <form method="post">
                    <input type="hidden" name="save_model" value="1" />
                    <div class="form-group">
                        <label>Nazwa</label>
                        <input name="name" class="form-control" value="{$model.name}" />
                    </div>
                    <div class="form-group">
                        <label>Opis</label>
                        <textarea id="tinymice" name="description" class="form-control">{$model.description}</textarea>
						 <button type="button" class="btn btn-secondary mt-2 me-2" id="generate_description">
                            Wygeneruj tekst <span id="gen_desc_loader" class="spinner-border spinner-border-sm" role="status" style="display:none;"></span>
                        </button>
                        <button type="button" class="btn btn-secondary mt-2 me-2" id="generate_meta">
                            Wygeneruj meta dane <span id="gen_meta_loader" class="spinner-border spinner-border-sm" role="status" style="display:none;"></span>
                        </button>
                        <button type="button" class="btn btn-secondary mt-2" id="generate_all">
                            Wygeneruj wszystko <span id="gen_all_loader" class="spinner-border spinner-border-sm" role="status" style="display:none;"></span>
                        </button>
                    </div>
                    <div class="form-group">
                        <label>Meta tytuł</label>
                        <input name="meta_title" class="form-control" value="{$model.meta_title}" />
                    </div>
                    <div class="form-group">
                        <label>Meta opis</label>
                        <textarea name="meta_description" class="form-control">{$model.meta_description}</textarea>
                    </div>
                    <div class="form-group">
                        <label>Meta słowa kluczowe</label>
                        <input name="meta_keywords" class="form-control" value="{$model.meta_keywords}" />
                    </div>
                    <div class="form-group">
                        <label>Kategoria</label>
                        <select name="category_id" class="form-control">
                            <option value="0">Wybierz kategorię</option>
                            {foreach from=$categories item=c}
                            <option value="{$c.id}" {if $model.category_id == $c.id}selected{/if}>{$c.name}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Zdjęcie</label>
                        <div class="d-flex align-items-center">
                            <button type="button" class="btn btn-secondary" id="open_gallery_popup">Wybierz zdjęcie</button>
                            <input type="hidden" name="img_from_gallery" id="img_from_gallery" value="{$model.image}" />
                        </div>
                        <div id="gallery_selected_preview" class="mt-2">
                            {if $model.image}<img src="{$model.image}" style="max-height:100px;max-width:150px;margin:5px;" />{/if}
                        </div>
                    </div>
                    <div id="gallery_popup" class="mfp-hide">
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
                    </div>
                    <div class="form-group">
                        <label>Organizacja</label>
                        <input name="organization" class="form-control" value="{$model.organization}" />
                    </div>
                    <div class="form-group">
                        <label>Licencja</label>
                        <input name="license" class="form-control" value="{$model.license}" />
                    </div>
                    <div class="form-group">
                        <label>Link do modelu</label>
                        <input name="model_link" class="form-control" value="{$model.model_link}" />
                    </div>					
                    <button type="submit" class="btn btn-primary">Zapisz</button>
                </form>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
$(document).ready(function(){
    $('#open_gallery_popup').magnificPopup({items:{src:'#gallery_popup'}, type:'inline', midClick:true});

    $(document).on('click', '#gallery_popup img.selectable-img', function(){
        const name = $(this).data('name');
        const thumb = $(this).attr('src');
        $('#img_from_gallery').val(name);
        $('#gallery_selected_preview').html(`<img src="${thumb}" style="max-height:100px;max-width:150px;margin:5px;"/>`);
        $.magnificPopup.close();
    });
	
		function generateData(type, loader){
        const title = $('input[name="name"]').val();
        if(!title){
            alert('Podaj nazwę modelu');
            return;
        }
        $(loader).show();
        $.post('/admin/utils/php/ajax-generate-model-description.php', {title: title, type: type}, function(res){
            if(res.success){
                if(type === 'description' || type === 'all'){
                    var editor = typeof tinymce !== 'undefined' ? tinymce.get('tinymice') : null;
                    if(editor){
                        editor.setContent(res.description);
                    } else {
                        $('textarea[name="description"]').val(res.description);
                    }
                }
                if(type === 'meta' || type === 'all'){
                    $('input[name="meta_title"]').val(res.meta_title);
                    $('textarea[name="meta_description"]').val(res.meta_description);
                    $('input[name="meta_keywords"]').val(res.meta_keywords);
                }
            } else if(res.error){
                alert(res.error);
            }
        }, 'json').always(function(){
             $(loader).hide();
        });
    }

    $('#generate_description').on('click', function(){
        generateData('description', '#gen_desc_loader');
    });

    $('#generate_meta').on('click', function(){
        generateData('meta', '#gen_meta_loader');
    });

    $('#generate_all').on('click', function(){
        generateData('all', '#gen_all_loader');
    });		
		
});
</script>
{/literal}
