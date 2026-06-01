<div class="container-fluid">
    <div class="content">
        <div class="row mb-4">
            <div class="col-12 col-lg">
                <h1 class="main-title"><span>Kolejność w menu</span></h1>
            </div>
            <div class="col d-flex align-items-end flex-column">
                <a href="/admin/podstrony" class="mt-auto p-2">
                    <button type="button" class="btn btn-primary">Powrót</button>
                </a>
            </div>
        </div>
    </div>
    <div class="row block-white" style="justify-content: center;">
        <div class="col-12">
            <p class="red">Przeciągnij tytuł podstrony aby zmienić kolejność</p>
        </div>
        <div class="col-4">
            <div class="content">
                <div class="table-responsive-md">
                    <div class="table-wrapper">
                        <table class="table table-myborder table-hover">
                            <thead>
                                <th class="text-center" style="width: 30px;">Lp</th>
                                <th class="text-center" style="width: 200px;">Tytuł</th>
                            </thead>
                            <tbody id="sortable">
                                {foreach from=$pages item=item key=key}
                                    <tr class="sortableElement">
                                        <td class="text-center">{$key+1}.</td>
                                        <td>{$item.title}</td>
                                        <input type="hidden" name="id_gallery" value="{$item.id}" class="page_id" />
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
<style>
    #sortable {
        cursor: grab;
    }
</style>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>
    $(function() {
        $("#sortable").sortable({
            update: (event, ui) => {
                $("#spinner").css("display", "flex")

                const elems = $(".sortableElement")
                const data = {}
                let i = 0

                for (let item of elems) {
                    const id = $(item).find(".page_id").val()
                    data[i] = id
                    i++
                }
                $.ajax({
                    url: "./../utils/php/ajax-change-pages-menu-queue.php",
                    type: "POST",
                    data: data,
                    success: function(response) {
                        if (response === 'ok') {
                            location.reload();
                        }
                    }
                });                
            }
        });
        $("#sortable").disableSelection();
    });
</script>