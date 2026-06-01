<div class="container-fluid">
  <div class="content">
    <div class="row mb-4">
      <div class="col-12 col-lg">
        <h1 class="main-title"><span>Ustawienia menu</span></h1>
      </div>
      <div class="col d-flex align-items-end flex-column">
        <a href="/admin/start" class="mt-auto p-2">
          <button type="button" class="btn btn-primary">Powrót</button>
        </a>
      </div>
    </div>
  </div>
  <div class="row block-white">
    <div class="col-12">
      <form class="p-3" method="post">
        <div class="form-group">
          <label>Kod HTML przed menu</label>
          <textarea class="form-control" name="html_before" rows="3">{$before}</textarea>
        </div>
        <div class="form-group">
          <label>Kod HTML po menu</label>
          <textarea class="form-control" name="html_after" rows="3">{$after}</textarea>
        </div>
        <button type="submit" name="save_snippets" class="btn btn-success">Zapisz</button>
      </form>
    </div>
  </div>
</div>
