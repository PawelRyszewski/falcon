<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Szablony newslettera</span></h1>
        </div>
        <div class="col d-flex align-items-end">
            <a href="/admin/newsletter" class="mt-auto ml-auto p-2">
                <button type="button" class="btn btn-primary">Powrót</button>
            </a>
            <a href="/admin/newsletter/templates-dodaj" class="p-2">
                <button type="button" class="btn btn-primary">Dodaj szablon</button>
            </a>
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
                                    <th class="text-center">Lp</th>
                                    <th>Nazwa</th>
                                    <th class="text-center">Podgląd</th>
									<th class="text-center">Opcje</th>
                                    <th class="text-center">Usuń</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$templates item=item key=key}
                                    <tr>
                                        <td class="text-center">{$key+1}</td>
                                        <td>{$item.name}</td>
                                        <td class="text-center">
                                            <a href="#preview-{$item.id}" class="template-preview blue hover-opacity">Podgląd</a>
                                            <div id="preview-{$item.id}" class="mfp-hide">
                                                <h4>{$item.subject}</h4>
                                                <div>{$item.body nofilter}</div>
                                            </div>
                                        </td>
                                        <td class="text-center">
										<div class="d-flex" style="align-items: center; justify-content: center;">
                                            <a href="/admin/newsletter/templates-edytuj/{$item.id}" alt="Edytuj" title="Edytuj" class="orange hover-opacity">
                                                <span class="icon-content-edit"></span>
                                            </a>
											<a href="/admin/newsletter/templates-duplikuj/{$item.id}" style="margin-left:5px !important" alt="Zduplikuj" title="Zduplikuj" class="blue hover-opacity ml-4">
												<img src="/admin/utils/img/duplicate.svg" style="max-width: 17px;">
											</a>
										</div>
                                        </td>
                                        <td class="text-center">
                                            <a href="/admin/newsletter/templates-usun/{$item.id}" class="red hover-opacity">
                                                <span class="icon-content-delete"></span>
                                            </a>
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
</div>
{literal}
<script>
$(document).ready(function(){
    $('.template-preview').magnificPopup({type:'inline', midClick:true});
    $('#table').DataTable({
        "lengthMenu": [[25, 50, 100, -1], [25, 50, 100, "Wszystko"]],
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
});
</script>
{/literal}