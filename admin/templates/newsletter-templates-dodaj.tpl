<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Dodaj szablon</span></h1>
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
                        <input type="text" class="form-control" name="name" required />
                    </div>
                    <div class="form-group mt-3">
                        <label>Tytuł wiadomości</label>
                        <input type="text" class="form-control" name="subject" required />
                    </div>
                    <div class="form-group mt-3">
                        <label>Treść</label>
                        <textarea id="tinymice" name="body" class="form-control"></textarea>
                    </div>
                    <button type="submit" name="add_template" class="btn btn-success mt-3">Dodaj szablon</button>
                </form>
            </div>
        </div>
    </div>
</div>