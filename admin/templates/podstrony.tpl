<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Lista podstron</span></h1>
        </div>
        <div class="col d-flex align-items-end flex-column">
            <div class="mt-auto">
                <a href="/admin/podstrony/kolejnosc-w-menu" class="p-2">
                    <button type="button" class="btn btn-primary">Kolejność w menu</button>
                </a>
                <a href="/admin/jezyki" class="p-2">
                    <button type="button" class="btn btn-primary">Języki</button>
                </a>
                <a href="/admin/podstrony/kategorie" class="p-2">
                    <button type="button" class="btn btn-primary">Kategorie</button>
                </a>
                <a href="/admin/podstrony/dodaj" class=" p-2">
                    <button type="button" class="btn btn-primary">Dodaj podstronę</button>
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
                                <tr class="d-flex">
                                    <th scope="col" class="col-1 text-center">Lp</th>
                                    <th scope="col" class="col-1 text-center">Id</th>
                                    <th scope="col" class="col-3 ">Nazwa</th>
                                    {*<th scope="col" class="col-1 text-center">Uzupełnił</th>*}
                                    <th scope="col" class="col-1 text-center">Język</th>
									<th scope="col" class="col-2 text-center">Kategoria</th>
                                    <!--<th scope="col">Link</th>-->
                                    <th scope="col" class="col-1 text-center">Wyświetlenia</th>
									<th scope="col" class="col-1 text-center">Opublikowano</th>
                                    <th scope="col" class="col-1 text-center">Opcje</th>
                                    <th scope="col" class="col-1 text-center">Usuń</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$pages item=item key=key name=name}
                                    <tr class="d-flex">
                                        <td class="text-center col-1">{$key+1}.</td>
                                        <td class="text-center col-1">{$item.id}</td>
                                        <td class="col-3"><a href="/admin/podstrony/edytuj/{$item.id}" target="blank">{$item.title}</a></td>
										{*<td class="text-center col-1">{if isset($users[$item.who_fill])} {$users[$item.who_fill].0} {else} Brak użytkownika{/if}</td>*}
										<td class="text-center col-1">{$item.lang_name|default:'-'}</td>
										<td class="text-center col-2">{$item.category_name|default:'-'}</td>
                                        <!--<td><a href="{$item.url}" target="blank">{$item.url}</a></td>-->
                                        <td class="text-center col-1">{$item.visit}</td>
                                        <td class="text-center col-1">
                                            <form method="POST">
                                                <button type="submit" name="toggle_publish" class="blue hover-opacity" style="background: unset; border: none;">
                                                    {if $item.is_published == 0}
                                                        <svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-eye-slash-fill" fill="#3f9cff" xmlns="http://www.w3.org/2000/svg">
        	                                                    <path d="M10.79 12.912l-1.614-1.615a3.5 3.5 0 0 1-4.474-4.474l-2.06-2.06C.938 6.278 0 8 0 8s3 5.5 8 5.5a7.029 7.029 0 0 0 2.79-.588zM5.21 3.088A7.028 7.028 0 0 1 8 2.5c5 0 8 5.5 8 5.5s-.939 1.721-2.641 3.238l-2.062-2.062a3.5 3.5 0 0 0-4.474-4.474L5.21 3.089z" />
        	                                                    <path d="M5.525 7.646a2.5 2.5 0 0 0 2.829 2.829l-2.83-2.829zm4.95.708l-2.829-2.83a2.5 2.5 0 0 1 2.829 2.829z" />
        	                                                    <path fill-rule="evenodd" d="M13.646 14.354l-12-12 .708-.708 12 12-.708.708z" />
        	                                                </svg>
                                                    {else}
                                                        <svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-eye-fill" fill="#3f9cff" xmlns="http://www.w3.org/2000/svg">
        	                                                    <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z" />
        	                                                    <path fill-rule="evenodd" d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z" />
        	                                            </svg>
                                                    {/if}
                                                </button>
                                                <input type="hidden" name="is_published" value="{if $item.is_published == 1}0{else}1{/if}" />
                                                <input type="hidden" name="id_page" value="{$item.id}" />
                                            </form>
                                        </td>
                                        <td class="text-center col-1">
                                            <a href="/admin/podstrony/edytuj/{$item.id}" class="orange hover-opacity" alt="Edytuj" title="Edytuj">
                                                <span class="icon-content-edit"></span>
                                            </a>
											<a href="/admin/podstrony/duplikuj/{$item.id}" class="blue hover-opacity ml-4" alt="Duplikuj" title="Duplikuj">
												<img src="/admin/utils/img/duplicate.svg" style="max-width: 17px;">
											</a>											
                                        </td>
                                        <td class="text-center col-1">
                                            <a href="/admin/podstrony/usun/{$item.id}" class="red hover-opacity">
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

<script>
    $(document).ready(function() {
        $('#table').DataTable({
            "lengthMenu": [
                [25, 50, 100, -1],
                [25, 50, 100, "Wszystko"]
            ],
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
            fnDrawCallback: function() {
                if ($(this).find('.dataTables_empty').length == 1) {
                    $('#datatable1_info, #table_paginate, #datatable1_paginate, th').hide();
                    $('.dataTables_empty').css({ "border-top": "1px solid #111" });
                } else {
                    $('#datatable1_info, #table_paginate, #datatable1_paginate, th').show();
                }
            }

        });
    });
</script>