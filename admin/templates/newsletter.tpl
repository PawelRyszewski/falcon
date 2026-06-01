<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Lista subskrybentów</span></h1>
        </div>
    </div>
    <div class="row block-white">
        <div class="col-12">
            <div class="content">
                <form method="POST" id="send-form">
                    <div class="row mb-3 pb-3 border-bottom">
                        <div class="col-md-6">
							<div class="d-flex">
                            <select name="template_id" class="form-control" required>
                                <option value="">Wybierz szablon</option>
                                {foreach from=$templates item=t}
                                <option value="{$t.id}">{$t.name}</option>
                                {/foreach}
                            </select>
							<button type="submit" name="send_template" class="btn btn-success ml-3">Wyślij</button>
							<a href="#" id="template-preview-btn" class="btn btn-secondary template-preview d-none ml-2">Podgląd szablonu</a>
							</div>
                        </div>
                        <div class="col-md-6 text-right">
                            <a href="/admin/newsletter/templates" class="btn btn-primary">Zarządzaj szablonami</a>
							<a href="/admin/newsletter/emails" class="btn btn-primary ml-2">Zarządzaj treścią email</a>
                        </div>
						{foreach from=$templates item=t}
						<div id="preview-{$t.id}" class="mfp-hide">
							<h4>{$t.subject}</h4>
							<div>{$t.body nofilter}</div>
						</div>
						{/foreach}
                    </div>
                    <div class="table-responsive">
                        <div class="table-wrapper">
                            <table class="table table-myborder table-hover table-sm" id="table">
                                <thead>
                                    <tr>
                                        <th class="text-center"><input type="checkbox" id="select_all"/></th>
                                        <th class="text-center">Lp</th>
                                        <th>Email</th>
                                        <th>Imię i Naz.</th>
                                        <th>Telefon</th>
                                        <th class="text-center">zaz. email</th>
                                        <th class="text-center">zaz. tel.</th>
                                        <th class="text-center">Wiado.</th>
                                        <th>Data zapisu</th>
                                        <th class="text-center">Usuń</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach from=$subscribers item=item key=key}
                                    <tr>
                                        <td class="text-center"><input type="checkbox" class="recipient-checkbox" name="recipients[]" value="{$item.id}"/></td>
                                        <td class="text-center">{$key+1}.</td>
                                        <td>{$item.email}</td>
                                        <td>{$item.name}</td>
                                        <td>{$item.phone}</td>
                                        <td class="text-center">{if $item.consent_email}✓{else}—{/if}</td>
                                        <td class="text-center">{if $item.consent_phone}✓{else}—{/if}</td>
                                        <td class="text-center">
                                            {if $item.message}
                                            <button type="button" class="btn btn-sm btn-outline-secondary show-msg-btn"
                                                data-name="{$item.name|escape}" data-msg="{$item.message|escape}">
                                                Zobacz wiadomość
                                            </button>
                                            {else}—{/if}
                                        </td>
                                        <td>{$item.created_at}</td>
                                        <td class="text-center">
                                            <a href="/admin/newsletter/usun/{$item.id}" class="red hover-opacity">
                                                <span class="icon-content-delete"></span>
                                            </a>
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Message preview modal -->
<div class="modal fade" id="msgModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Wiadomość od: <span id="msgModalName"></span></h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <p id="msgModalBody" style="white-space:pre-wrap;"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Zamknij</button>
            </div>
        </div>
    </div>
</div>

{literal}
<script>
$(document).ready(function(){
    var table = $('#table').DataTable({
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

    var previewBtn = $('#template-preview-btn');
    $('select[name="template_id"]').on('change', function(){
        var val = $(this).val();
        if(val){
            previewBtn.removeClass('d-none').attr('href', '#preview-'+val);
        } else {
            previewBtn.addClass('d-none').attr('href', '#');
        }
    });
    previewBtn.magnificPopup({type:'inline', midClick:true});

    $('#select_all').on('click', function(){
        $('.recipient-checkbox').prop('checked', this.checked);
    });

    $('#send-form').on('submit', function(){
        var selected = $('.recipient-checkbox:checked').map(function(){
            return this.value;
        }).get();
        if(!selected.length || !$('select[name="template_id"]').val()){
            alert('Wybierz odbiorców i szablon');
            return false;
        }
        $(this).find('input[name="recipients[]"]').remove();
        selected.forEach(function(val){
            $('<input>').attr({type:'hidden', name:'recipients[]', value:val}).appendTo('#send-form');
        });
    });

    $(document).on('click', '.show-msg-btn', function(){
        var name = $(this).data('name');
        var msg  = $(this).data('msg');
        $('#msgModalName').text(name);
        $('#msgModalBody').text(msg);
        $('#msgModal').modal('show');
    });
});
</script>
{/literal}
