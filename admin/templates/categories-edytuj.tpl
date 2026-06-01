<div class="container-fluid">
    <div class="row block-white  justify-content-md-center">
        <div class="col-5">
            <div class="content">
                <form method="POST">
                    <div class="form-group">
                        <label>Nazwa</label>
                        <input type="text" name="name" class="form-control" value="{$category.name}" />
                    </div>
                    <div class="form-group">
                        <label>Ścieżka do JSON</label>
                        <input type="text" name="json_file" class="form-control" value="{$category.json_file}" />
                    </div>
                    <div class="form-group">
                        <label>Maksymalna liczba pozycji z pliku JSON</label>
                        <select name="json_limit" class="form-control">
                            <option value="0" {if $category.json_limit == 0 || $category.json_limit == ''}selected{/if}>Wszystkie</option>
                            <option value="5" {if $category.json_limit == 5}selected{/if}>5</option>
                            <option value="10" {if $category.json_limit == 10}selected{/if}>10</option>
                            <option value="15" {if $category.json_limit == 15}selected{/if}>15</option>
                            <option value="20" {if $category.json_limit == 20}selected{/if}>20</option>
                        </select>
                    </div>	
                    <div class="form-group form-check" id="json_top_wrapper" style="display:none;">
                        <input type="checkbox" class="form-check-input" id="json_top" name="json_top" value="1" {if $category.json_top}checked{/if} />
                        <label class="form-check-label" for="json_top">Zaimportuj tylko pozycje z największą ilością głosów i ocen</label>
                    </div>					
                    <div class="form-group">
                        <label>Godzina odświeżania</label>
                        <select name="json_refresh_hour" class="form-control">
                            <option value="">Brak</option>
                            {for $i=0 to 23}
                            <option value="{$i}" {if $category.json_refresh_hour == $i}selected{/if}>{$i}</option>
                            {/for}
                        </select>
                    </div>					
                    <div class="form-group form-check">
                        <input type="checkbox" class="form-check-input" id="create_missing_models" name="create_missing_models" value="1" {if $category.create_missing_models}checked{/if} />
                        <label class="form-check-label" for="create_missing_models">Utwórz i wczytaj brakujące modele</label>
                    </div>					
                    <a href="/admin/categories"><button class="btn btn-secondary" type="button">Anuluj</button></a>
                    <button type="submit" name="confirm_edit" class="btn btn-primary float-right">Zapisz</button>
                </form>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
$(function(){
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