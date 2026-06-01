<div class="container-fluid">
    <div class="row block-white  justify-content-md-center"">
        <div class=" col-5">
        <div class="content">
            <form method="POST">
                <h4>Edycja "{$name}"</h4>
                <br />
                <div class="form-group">
                    <label>Nazwa</label>
                    <input type="text" name="name" class="form-control" value="{$name}"/>
                </div>
                <a href="/admin/jezyki"><button class="btn btn-primary" type="button">Powrót do listy</button></a>
                <button type="submit" name="confirm_edit" class="btn btn-success float-right">Edytuj</button>
            </form>
        </div>
    </div>
</div>
</div>
