<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Kategorie modeli</span></h1>
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
                <div class="table-responsive-md">
                    <div class="table-wrapper">
                        <table class="table table-myborder table-hover" id="table">
                            <thead>
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th>Nazwa</th>
                                    <th>Plik JSON</th>
                                    <th>Limit</th>
									<th class="text-center">Godzina</th>
                                    <th class="text-center">Wczytuj</th>
                                    <th class="text-center">Akcje</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$categories item=c}
                                <tr>
                                    <td class="text-center">{$c.id}</td>
                                    <td>{$c.name}</td>
                                    <td>{$c.json_file}</td>
                                    <td>{if $c.json_limit}{$c.json_limit}{else}Wszystkie{/if}</td>
									<td class="text-center">{if isset($c.json_refresh_hour)}{$c.json_refresh_hour}{else}-{/if}</td>
                                    <td class="text-center">{if $c.create_missing_models}Tak{else}Nie{/if}</td>
                                    <td class="text-center">
                                        <a href="/admin/categories/edytuj/{$c.id}" class="orange hover-opacity" title="Edytuj"><span class="icon-content-edit"></span></a>
                                        <a href="/admin/categories/usun/{$c.id}" class="red hover-opacity ml-3" title="Usuń"><span class="icon-content-delete"></span></a>
										 <a href="/admin/categories/przeladuj-json/{$c.id}" class="btn btn-secondary btn-sm ml-3">Przeładuj JSON</a>
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

    <div class="row mt-4">
        <div class="col-12 col-lg-6">
            <h2 class="main-title"><span>Dodaj kategorię</span></h2>
            <form method="post" class="mb-5">
                <input type="hidden" name="add_category" value="1" />
                <div class="form-group">
                    <label>Nazwa</label>
                    <input name="name" class="form-control" />
                </div>
                <div class="form-group">
                    <label>Ścieżka do JSON</label>
                    <input name="json_file" class="form-control" />
                </div>
                <div class="form-group">
                    <label>Maksymalna liczba pozycji z JSON</label>
                    <select name="json_limit" class="form-control">
                        <option value="0">Wszystkie</option>
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="20">20</option>
                    </select>
                </div>	
                <div class="form-group form-check" id="json_top_wrapper" style="display:none;">
                    <input type="checkbox" class="form-check-input" id="json_top" name="json_top" value="1" />
                    <label class="form-check-label" for="json_top">Zaimportuj tylko pozycje z największą ilością głosów i ocen</label>
                </div>				
                <div class="form-group">
                    <label>Godzina odświeżania</label>
                    <select name="json_refresh_hour" class="form-control">
                        <option value="">Brak</option>
                        {for $i=0 to 23}
                        <option value="{$i}">{$i}</option>
                        {/for}
                    </select>
                </div>				
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="create_missing_models" name="create_missing_models" value="1" />
                    <label class="form-check-label" for="create_missing_models">Utwórz i wczytaj brakujące modele</label>
                </div>
                <button type="submit" class="btn btn-primary">Dodaj</button>
            </form>
        </div>
    </div>
</div>

{literal}
<script>
$(document).ready(function(){
    $('#table').DataTable({
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
        }
    });
	
    function toggleTopCheckbox(){
        var v = parseInt($('select[name="json_limit"]').val());
        if(v > 0){
            $('#json_top_wrapper').show();
        }else{
            $('#json_top_wrapper').hide();
            $('#json_top').prop('checked', false);
        }
    }
    $('select[name="json_limit"]').on('change', toggleTopCheckbox);
    toggleTopCheckbox();	
	
});
</script>
{/literal}