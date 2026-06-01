<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Modele AI</span></h1>
        </div>
        <div class="col d-flex align-items-end flex-column">
            <div class="mt-auto d-flex">
                <form method="GET" class="form-inline p-2">
                    <div class="input-group">
                        <select name="category" class="form-select form-control input-sm">
                            <option value="0" {if $selected_category==0}selected{/if}>Wszystkie kategorie</option>
                            {foreach from=$categories item=c}
                            <option value="{$c.id}" {if $selected_category==$c.id}selected{/if}>{$c.name}</option>
                            {/foreach}
                        </select>
                        <button type="submit" class="btn btn-secondary" style="border-top-left-radius:0; border-bottom-left-radius:0;">Filtruj</button>
                    </div>
                </form>			
                <a href="/admin/categories" class="p-2">
                    <button type="button" class="btn btn-primary">Kategorie</button>
                </a>
                <a href="/admin/votes" class="p-2">
                    <button type="button" class="btn btn-primary">Głosy</button>
                </a>
            </div>
        </div>
    </div>
	
    <div class="row mb-2">
        <div class="col-12">
            <div class="d-flex">
                <button type="button" class="btn btn-secondary me-2" id="bulk_generate_description">Wygeneruj tekst</button>
                <button type="button" class="btn btn-secondary me-2" id="bulk_generate_meta">Wygeneruj meta dane</button>
                <button type="button" class="btn btn-secondary" id="bulk_generate_all">Wygeneruj wszystko</button>
                <span id="bulk_gen_status" class="ms-3"></span>
            </div>
        </div>
    </div>	

    <div class="row block-white">
        <div class="col-12">
            <div class="content">
                <div class="table-responsive-md">
                    <div class="table-wrapper">
                        <table class="table table-myborder table-hover" id="table">
                            <thead>
                                <tr>
									<th class="text-center"><input type="checkbox" id="select_all"></th>
                                    <th class="text-center">ID</th>
                                    <th>Nazwa</th>
                                    <th>Kategoria</th>
                                    <th>Organizacja</th>
                                    <th>Licencja</th>
                                    <th class="text-center">Gł. JSON</th>
                                    <th class="text-center">Gł. strona</th>
                                    <th class="text-center">Ocena</th>		
									<th class="text-center">Znaki</th>									
                                    <th class="text-center">Akcje</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$models item=m}
                                <tr>
									<td class="text-center"><input type="checkbox" class="model-checkbox" value="{$m.id}" data-name="{$m.name}"></td>
                                    <td class="text-center">{$m.id}</td>
                                    <td>{$m.name}</td>
                                    <td>{$m.category_name|default:'-'}</td>
                                    <td>{$m.organization}</td>
                                    <td>{$m.license}</td>
                                    <td class="text-center">{$m.votes_json}</td>
                                    <td class="text-center">{$m.votes_site}</td>
                                    <td class="text-center">{$m.score}</td>		
                                    <td class="text-center">{$m.char_count}</td>									
                                    <td class="text-center">
                                        <a href="/admin/ai-models/edytuj/{$m.id}" class="orange hover-opacity" title="Edytuj"><span class="icon-content-edit"></span></a>
                                        <a href="/admin/ai-models/usun/{$m.id}" class="red hover-opacity ml-3" title="Usuń"><span class="icon-content-delete"></span></a>
                                    </td>
                                </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-4 mb-5">
        <div class="col-12 col-lg-6">
            <button class="btn btn-primary mb-3 collapsed" type="button" data-toggle="collapse" data-target="#addModelCollapse" aria-expanded="false" aria-controls="addModelCollapse">
                Dodaj model
            </button>
            <div class="collapse" id="addModelCollapse">
                <div class="card card-body">
                    <form method="post">
                        <input type="hidden" name="add_model" value="1" />
                        <div class="form-group">
                            <label>Nazwa</label>
                            <input name="name" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label>Opis</label>
                            <textarea id="tinymice" name="description" class="form-control"></textarea>
                        </div>
                        <div class="form-group">
                            <label>Kategoria</label>
                            <select name="category_id" class="form-control">
                                <option value="0">Wybierz kategorię</option>
                                {foreach from=$categories item=c}
                                <option value="{$c.id}">{$c.name}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Zdjęcie</label>
                            <div class="d-flex align-items-center">
                                <button type="button" class="btn btn-secondary" id="open_gallery_popup">Wybierz zdjęcie</button>
                                <input type="hidden" name="img_from_gallery" id="img_from_gallery" />
                            </div>
                            <div id="gallery_selected_preview" class="mt-2"></div>
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
                            <input name="organization" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label>Licencja</label>
                            <input name="license" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label>Link do modelu</label>
                            <input name="model_link" class="form-control" />
                        </div>
                        <button type="submit" class="btn btn-primary">Dodaj</button>
                    </form>
                </div>
			</div>
        </div>
    </div>
</div>

{literal}
<script>
function initTable() {
    return $('#table').DataTable({
        "language": {
            "lengthMenu": "Wyświetl _MENU_ pozycji na stronie",
            "zeroRecords": "Nic nie znaleziono",
            "info": "Strona _PAGE_ z _PAGES_",
            "infoEmpty": "Brak wyników wyszukiwania",
            "sSearch": "Wyszukaj",
            "infoFiltered": "",
            "oPaginate": {
                "sFirst": "<<",
                "sPrevious": "<",
                "sNext": ">",
                "sLast": ">>"
            }
        },
        columnDefs: [
            { orderable: false, targets: [0, -1] }
        ]
    });
}

$(document).ready(function(){
    var table = initTable();

	$('#select_all').on('change', function(){
        $('.model-checkbox').prop('checked', this.checked);
    });

    function bulkGenerate(type){
        var ids = $('.model-checkbox:checked');
        if(ids.length === 0){
            alert('Zaznacz modele');
            return;
        }
        var idx = 0;
        function next(){
            if(idx >= ids.length){
                $('#bulk_gen_status').text('Zakończono');
                return;
            }
            var $cb = $(ids[idx]);
            var id = $cb.val();
            var name = $cb.data('name');
            $('#bulk_gen_status').text('Generuję: ' + name);
            var $row = $cb.closest('tr');
            $row.addClass('table-warning');
            $.post('/admin/utils/php/ajax-generate-model-description.php', {title: name, type: type, model_id: id}, function(res){
                // optional handling
            }, 'json').always(function(){
                $row.removeClass('table-warning');
                idx++;
                next();
            });
        }
        next();
    }

    $('#bulk_generate_description').on('click', function(){
        bulkGenerate('description');
    });
    $('#bulk_generate_meta').on('click', function(){
        bulkGenerate('meta');
    });
    $('#bulk_generate_all').on('click', function(){
        bulkGenerate('all');
    });

    $('form.form-inline').on('submit', function(e){
        e.preventDefault();
        var $form = $(this);
        var $button = $form.find('button[type="submit"]');
        $button.prop('disabled', true);
        var category = $form.find('select[name="category"]').val();
        $.get('/admin/utils/php/ajax-filter-ai-models.php', { category: category })
            .done(function(html){
                table.destroy();
                $('#table tbody').html(html);
                table = initTable();
            })
            .always(function(){
                $button.prop('disabled', false);
            });
    });	
	

    $('#open_gallery_popup').magnificPopup({items:{src:'#gallery_popup'}, type:'inline', midClick:true});

    $(document).on('click', '#gallery_popup img.selectable-img', function(){
        const name = $(this).data('name');
        const thumb = $(this).attr('src');
        $('#img_from_gallery').val(name);
        $('#gallery_selected_preview').html(`<img src="${thumb}" style="max-height:100px;max-width:150px;margin:5px;"/>`);
        $.magnificPopup.close();
    });
});
</script>
{/literal}