<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Głosy użytkowników</span></h1>
        </div>
        <div class="col d-flex align-items-end flex-column">
            <div class="mt-auto d-flex">
                <a href="/admin/ai-models" class="p-2">
                    <button type="button" class="btn btn-secondary">Powrót do modeli</button>
                </a>
            </div>
        </div>		
    </div>

    {if $msg_success}<div class="alert alert-success">{$msg_success}</div>{/if}

    <div class="row block-white">
        <div class="col-12">
            <div class="content">
                <div class="table-responsive-md">
                    <div class="table-wrapper">
                        <table class="table table-myborder table-hover" id="table">
                            <thead>
                                <tr class="d-flex">
                                    <th class="col-3">Model</th>
                                    <th class="col-3">Kategoria</th>
                                    <th class="col-2 text-center">Głosy</th>
                                    <th class="col-4 text-center">Akcje</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$votes_counts item=v}
                                <tr class="d-flex">
                                    <td class="col-3">{$v.model_name}</td>
                                    <td class="col-3">{$v.category_name}</td>
                                    <td class="col-2 text-center">{$v.votes}</td>
                                    <td class="col-4 text-center">
                                        <form method="post" class="d-inline-block">
                                            <input type="hidden" name="model_id" value="{$v.model_id}" />
                                            <input type="hidden" name="category_id" value="{$v.category_id}" />
                                            <input type="hidden" name="reset_votes" value="1" />
                                            <button type="submit" class="btn btn-sm btn-warning">Zeruj</button>
                                        </form>
                                        <form method="post" class="d-inline-flex align-items-center">
                                            <input type="hidden" name="model_id" value="{$v.model_id}" />
                                            <input type="hidden" name="category_id" value="{$v.category_id}" />
                                            <input type="number" name="new_count" value="{$v.votes}" class="form-control form-control-sm mr-2" style="width:80px;" min="0" />
                                            <button type="submit" name="update_votes" class="btn btn-sm btn-primary">Zmień</button>
                                        </form>
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
        <div class="col-12 col-lg-6 mb-5">
            <h2 class="main-title"><span>Zmień liczbę głosów</span></h2>
            <form method="post">
                <input type="hidden" name="update_votes" value="1" />
                <div class="form-group">
                    <label>Kategoria</label>
                    <select id="category_select" name="category_id" class="form-control">
                        <option value="">Wybierz kategorię</option>
                        {foreach from=$categories item=c}
                        <option value="{$c.id}">{$c.name}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="form-group">
                    <label>Model</label>
                    <select id="model_select" name="model_id" class="form-control" disabled>
                        <option value="">Wybierz model</option>
                    </select>
                </div>				
                <div class="form-group">
                    <label>Liczba głosów</label>
                    <input type="number" id="votes_input" name="new_count" class="form-control" min="0" disabled />
                </div>
                <button type="submit" class="btn btn-primary">Zapisz</button>
            </form>
        </div>
        <div class="col-12 col-lg-6">
            <h2 class="main-title"><span>Zeruj wszystkie głosy</span></h2>
            <form method="post">
                <input type="hidden" name="reset_all" value="1" />
                <button type="submit" class="btn btn-danger">Zeruj wszystko</button>
            </form>
        </div>
    </div>
</div>



<script>
    const models = JSON.parse('{$models|@json_encode|escape:'javascript'}');
	{literal}
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

        const categorySelect = $('#category_select');
        const modelSelect = $('#model_select');
        const votesInput = $('#votes_input');

        categorySelect.on('change', function(){
            const catId = $(this).val();
            modelSelect.prop('disabled', true).empty().append('<option value="">Wybierz model</option>');
            votesInput.prop('disabled', true).val('');
            if(catId){
                const filtered = models.filter(m => m.category_id == catId);
                filtered.forEach(m => {
                    modelSelect.append(`<option value="${m.id}">${m.name}</option>`);
                });
                modelSelect.prop('disabled', filtered.length === 0);
            }
        });

        modelSelect.on('change', function(){
            votesInput.prop('disabled', !$(this).val());
        });
    });	
	{/literal}
</script>

