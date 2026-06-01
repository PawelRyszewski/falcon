<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Edytuj szablon</span></h1>
        </div>
        <div class="col d-flex align-items-end flex-column">
            <a href="/admin/newsletter/templates" class="mt-auto p-2">
                <button type="button" class="btn btn-primary">Powrót</button>
            </a>
        </div>
    </div>
    <div class="row block-white">
        <div class="col-12">
            <div class="content">
                <form class="p-3" method="POST">
                    <div class="form-group">
                        <label>Nazwa</label>
                        <input type="text" class="form-control" name="name" value="{$template.name}" required />
                    </div>
                    <div class="form-group mt-3">
                        <label>Tytuł wiadomości</label>
                        <input type="text" class="form-control" name="subject" value="{$template.subject}" required />
                    </div>
                    <div class="form-group mt-3">
                        <label>Treść</label>
                        <textarea id="tinymice" name="body" class="form-control">{$template.body}</textarea>
                    </div>
                    <button type="submit" name="edit_template" class="btn btn-success mt-3">Zapisz zmiany</button>
                </form>
            </div>
        </div>
    </div>
</div>