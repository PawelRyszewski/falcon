<div class="container-fluid">
    <div class="row block-white  justify-content-md-center">
        <div class="col-5">
            <div class="content">
                <form method="POST">
                    <h4>Czy usunąć kategorię <span class="red">"{$name}"</span> ?</h4>
                    <br />
                    <a href="/admin/categories"><button class="btn btn-primary" type="button">Nie, powrót do listy</button></a>
                    <button type="submit" name="confirm_delete" class="btn btn-danger float-right">Tak, usuń</button>
                </form>
            </div>
        </div>
    </div>
</div>