<div class="container-fluid">
    <div class="content">
        <div class="row mb-4">
            <div class="col-12 col-lg">
                <h1 class="main-title"><span>Lista kategorii</span></h1>
            </div>
            <div class="col d-flex align-items-end flex-column">
                <a href="/admin/podstrony" class="mt-auto p-2">
                    <button type="button" class="btn btn-primary">Powrót</button>
                </a>
            </div>
        </div>
    </div>
    <div class="row block-white">
        <div class="col-6">
            <div class="content">
                <div class="table-responsive-md">
                    <div class="table-wrapper">
                        <table class="table table-myborder table-hover">
                            <thead>
                                <th class="text-center">Lp</th>
                                <th class="text-center">Nazwa</th>
                                <th class="text-center">Edytuj</th>
                                <th class="text-center">Usuń</th>
                            </thead>
                            <tbody>
                                {foreach from=$categories item=item key=key name=name}
                                    <tr>
                                        <td class="text-center">{$key+1}</td>
                                        <td class="text-center">{$item.name}</td>
                                        <td class="text-center">
                                            <a href="/admin/podstrony/kategorie-edytuj/{$item.id}" class="orange hover-opacity">
                                                <span class="icon-content-edit"></span>
                                            </a>
                                        </td>
                                        <td class="text-center">
                                            <a href="/admin/podstrony/kategorie-usun/{$item.id}" class="red hover-opacity text-center">
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
        <div class="col-6">
            <form class="p-3" name="edit-page-form" id="edit-page-form" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Tytuł</label>
                    <input type="text" name="name" class="form-control" />
                </div>
                 <button type="submit" class="btn btn-success" name="add_category">Dodaj kategorię</button>
            </form>
        </div>
    </div>
</div>