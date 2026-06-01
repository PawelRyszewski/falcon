<div class="container-fluid">
    <div class="content">
        <div class="row mb-4">
            <div class="col-12 col-lg">
                <h1 class="main-title"><span> Lista osiedli</span></h1>
            </div>
            <div class="col d-flex align-items-end flex-column">
                <a href="/admin/nieruchomosci" class="mt-auto p-2">
                    <button type="button" class="btn btn-primary">Powrót</button>
                </a>
            </div>
        </div>
    </div>
    <div class="row block-white">
        <div class="col-6">
            <div class="content">

                <div class="mb-4">
                    <div class="d-flex align-items-center mb-2 gap-2">
                        <h2 class="h5 fw-bold mb-0">W realizacji</h2>
                        <div class="ms-auto" style="margin-left:auto;">
                            <small class="text-muted me-2">Pierwsze zdjęcie:</small>
                            <button type="button" class="btn btn-sm cat-side-btn {if $first_side_in_progress == 'left'}btn-primary{else}btn-outline-primary{/if}"
                                    data-status="0" data-side="left">Od lewej</button>
                            <button type="button" class="btn btn-sm cat-side-btn {if $first_side_in_progress == 'right'}btn-primary{else}btn-outline-primary{/if}"
                                    data-status="0" data-side="right">Od prawej</button>
                        </div>
                    </div>
                    <div class="table-responsive-md">
                        <div class="table-wrapper">
                            <table class="table table-myborder table-hover sortable-categories" data-status="0">
                                <thead>
                                    <th class="text-center" style="width:40px;"></th>
                                    <th class="text-center">Lp</th>
                                    <th class="text-center">Nazwa osiedla</th>
                                    <th class="text-center">Edytuj</th>
                                    <th class="text-center">Usuń</th>
                                </thead>
                                <tbody>
                                    {foreach from=$categories_in_progress item=item key=key name=ipName}
                                        <tr class="sortable-cat-row" data-id="{$item.id}">
                                            <td class="text-center cat-drag-handle" title="Przeciągnij aby zmienić kolejność" style="cursor:grab;">≡</td>
                                            <td class="text-center cat-lp">{$key+1}</td>
                                            <td class="text-center">{$item.name}</td>
                                            <td class="text-center">
                                                <a href="/admin/nieruchomosci/kategorie-edytuj/{$item.id}" class="orange hover-opacity">
                                                    <span class="icon-content-edit"></span>
                                                </a>
                                            </td>
                                            <td class="text-center">
                                                <a href="/admin/nieruchomosci/kategorie-usun/{$item.id}" class="red hover-opacity text-center">
                                                    <span class="icon-content-delete"></span>
                                                </a>
                                            </td>
                                        </tr>
                                    {foreachelse}
                                        <tr><td colspan="5" class="text-muted text-center">Brak osiedli w realizacji.</td></tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="d-flex align-items-center mb-2 gap-2">
                        <h2 class="h5 fw-bold mb-0">Zrealizowano</h2>
                        <div class="ms-auto" style="margin-left:auto;">
                            <small class="text-muted me-2">Pierwsze zdjęcie:</small>
                            <button type="button" class="btn btn-sm cat-side-btn {if $first_side_completed == 'left'}btn-primary{else}btn-outline-primary{/if}"
                                    data-status="1" data-side="left">Od lewej</button>
                            <button type="button" class="btn btn-sm cat-side-btn {if $first_side_completed == 'right'}btn-primary{else}btn-outline-primary{/if}"
                                    data-status="1" data-side="right">Od prawej</button>
                        </div>
                    </div>
                    <div class="table-responsive-md">
                        <div class="table-wrapper">
                            <table class="table table-myborder table-hover sortable-categories" data-status="1">
                                <thead>
                                    <th class="text-center" style="width:40px;"></th>
                                    <th class="text-center">Lp</th>
                                    <th class="text-center">Nazwa osiedla</th>
                                    <th class="text-center">Edytuj</th>
                                    <th class="text-center">Usuń</th>
                                </thead>
                                <tbody>
                                    {foreach from=$categories_completed item=item key=key name=cpName}
                                        <tr class="sortable-cat-row" data-id="{$item.id}">
                                            <td class="text-center cat-drag-handle" title="Przeciągnij aby zmienić kolejność" style="cursor:grab;">≡</td>
                                            <td class="text-center cat-lp">{$key+1}</td>
                                            <td class="text-center">{$item.name}</td>
                                            <td class="text-center">
                                                <a href="/admin/nieruchomosci/kategorie-edytuj/{$item.id}" class="orange hover-opacity">
                                                    <span class="icon-content-edit"></span>
                                                </a>
                                            </td>
                                            <td class="text-center">
                                                <a href="/admin/nieruchomosci/kategorie-usun/{$item.id}" class="red hover-opacity text-center">
                                                    <span class="icon-content-delete"></span>
                                                </a>
                                            </td>
                                        </tr>
                                    {foreachelse}
                                        <tr><td colspan="5" class="text-muted text-center">Brak zrealizowanych osiedli.</td></tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div id="cat-queue-indicator" style="position:fixed;bottom:20px;right:20px;z-index:9999;display:none;">
                    <span class="badge bg-success p-2" id="cat-queue-saved-msg">✓ Zapisano</span>
                    <span class="badge bg-secondary p-2" id="cat-queue-saving-msg" style="display:none;">Zapisuję...</span>
                </div>
            </div>
        </div>
        <div class="col-6">
            <form class="p-3" name="add-category-form" id="cat-add-form" method="post">

                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#ustawieniaSeoKat" aria-expanded="false" aria-controls="ustawieniaSeoKat">
                    Ustawienia SEO <span class="icon-arrow-right"></span>
                </button>
                <div class="collapse mb-3" id="ustawieniaSeoKat">
                    <div class="card card-body">
                        <div class="form-group">
                            <label>Title</label>
                            <input type="text" class="form-control" name="title_seo">
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <input type="text" class="form-control" name="meta_description">
                        </div>
                        <div class="form-group">
                            <label>Keywords</label>
                            <input type="text" class="form-control" name="keywords">
                        </div>
                        <div class="form-group">
                            <label>Adres URL</label>
                            <label class="float-right create-url" onclick="javascript: generatedUrlByTitile()">Generuj URL na podstawie tytułu</label>
                            <input type="text" class="form-control" name="url" placeholder="nazwa-twojej-osiedla" id="url">
                            <small>*Jeżeli pozostawisz to pole puste adres URL wygeneruje się automatycznie na podstawie nazwy</small>
                        </div>
                    </div>
                </div>
                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#homeDates" aria-expanded="false" aria-controls="homeDates">
                    Osiedle na stronie głównej<span class="icon-arrow-right"></span>
                </button>		
                <div class="collapse mb-3" id="homeDates">
                    <div class="card card-body">
						<div class="form-group">
							<label>Tytuł</label>
							<input type="text" name="homepage_title" class="form-control" placeholder="Domyślnie: nazwa osidela">
						</div>

						<div class="form-group">
							<label>Podtytuł </label>
							<input type="text" name="homepage_subtitle" class="form-control" placeholder="Krótki podtytuł / opis wyświetlany pod tytułem">
						</div>
						
						<div class="form-group">
							<input type="hidden" name="homepage_img" id="homepage_img" value="0">
							<div id="homepage_img_preview" class="mb-2" style="display:none;">
								<img id="homepage_img_thumb" src="" alt="" style="height:90px;object-fit:cover;border-radius:4px;border:2px solid #28a745;">
								<br><small class="text-muted">Wybrane zdjęcie</small>
							</div>
							<button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#homepageImgPickerModal">
								Wybierz zdjęcie
							</button>
						</div>	
					</div>
				</div>
				
                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#iconyCategoryAddSection" aria-expanded="false" aria-controls="iconyCategoryAddSection">
                    Ikony Osiedla <span class="icon-arrow-right"></span>
                </button>
                <div class="collapse mb-3" id="iconyCategoryAddSection">
                    <div class="card card-body">
                        <p class="text-muted mb-0">Ikony można dodać po zapisaniu osiedla. Po kliknięciu "Dodaj osiedle" zostaniesz przekierowany do panelu edycji, gdzie będziesz mógł wybrać ikony z galerii.</p>
                    </div>
                </div>

                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#sliderCategoryAddSection" aria-expanded="false" aria-controls="sliderCategoryAddSection">
                    Slider na stronie głównej <span class="icon-arrow-right"></span>
                </button>
                <div class="collapse mb-3" id="sliderCategoryAddSection">
                    <div class="card card-body">
                        <p class="text-muted mb-0">Slajdy slidera można dodać po zapisaniu osiedla. Po kliknięciu "Dodaj osiedle" zostaniesz przekierowany do panelu edycji, gdzie będziesz mógł dodać slajdy do slidera na stronie głównej.</p>
                    </div>
                </div>

                {if $has_category_map}
                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#mapLocationAddSection" aria-expanded="false" aria-controls="mapLocationAddSection">
                    Mapa lokalizacji <span class="icon-arrow-right"></span>
                </button>
                {/if}

                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#svgMapAddSection" aria-expanded="false" aria-controls="svgMapAddSection">
                    Mapa nieruchomości <span class="icon-arrow-right"></span>
                </button>
                <div class="collapse mb-3" id="svgMapAddSection">
                    <div class="card card-body">
                        <p class="text-muted mb-0">Mapę nieruchomości można dodać po zapisaniu osiedla. Po kliknięciu "Dodaj osiedle" zostaniesz przekierowany do panelu edycji, gdzie będziesz mógł skonfigurować interaktywną mapę z kształtami nieruchomości.</p>
                    </div>
                </div>

                {if $has_category_map}
                <div class="collapse mb-3" id="mapLocationAddSection">
                    <div class="card card-body">
                        <p class="text-muted small mb-2">Kliknij na mapie, aby ustawić pinezke lokalizacji osiedla.</p>
                        <input type="hidden" name="map_lat" id="map_lat_add" value="">
                        <input type="hidden" name="map_lng" id="map_lng_add" value="">
                        <input type="hidden" name="map_zoom" id="map_zoom_add" value="15">
                        <div class="input-group mb-2">
                            <input type="text" class="form-control" id="map-search-add" placeholder="Kraj, Miasto, Ulica" autocomplete="off">
                            <button class="btn btn-outline-secondary" type="button" onclick="searchMapLocationAdd()">Szukaj</button>
                        </div>
                        <div id="map-search-error-add" class="text-danger small mb-1" style="display:none;"></div>
                        <div id="admin-map-add" style="height:400px;border-radius:4px;position:relative;z-index:1;"></div>
                        <div class="d-flex align-items-center gap-2 mt-2">
                            <small class="text-muted" id="map-coords-label-add">Brak ustawionej lokalizacji — kliknij na mapie.</small>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="clearMapPinAdd()">Usuń pinezke</button>
                        </div>
                    </div>
                </div>
                {/if}

                <div class="form-group">
                    <label>Nazwa osiedla</label>
                    <input type="text" name="name" id="title" class="form-control" />
                </div>
                <div class="form-group">
                    <label>Nazwa w menu <small class="text-muted">(jeśli pusta — wyświetlana jest nazwa osiedla)</small></label>
                    <input type="text" name="menu_name" class="form-control" placeholder="Domyślnie: nazwa osiedla"/>
                </div>
                <div class="form-group">
                    <label>Status osiedla</label>
                    <select name="status" class="form-control">
                        <option value="0">W realizacji</option>
                        <option value="1">Zrealizowano</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Opis osiedla</label>
                    <textarea name="description" id="cat_description_add" rows="6" placeholder="Opis wyświetlany pod grafiką na stronie osiedla..."></textarea>
                </div>

                <div class="form-group">
                    <label>Grafika banera na podstronie osiedla:</label>
                    <input type="hidden" name="category_img" id="category_img" value="0">
                    <div id="category_img_preview" class="mb-2" style="display:none;">
                        <img id="category_img_thumb" src="" alt="" style="height:90px;object-fit:cover;border-radius:4px;border:2px solid #007bff;">
                        <br><small class="text-muted">Wybrane zdjęcie na stronie głównej</small>
                    </div>
                    <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#galleryPickerModal">
                        Wybierz zdjęcie
                    </button>
                    <button type="button" id="btn-clear-category-img" class="btn btn-outline-danger ml-1" onclick="clearCategoryImg()" style="display:none;">Usuń zdjęcie</button>
                </div>

                <hr>

                <button type="submit" class="btn btn-success" name="add_category">Dodaj osiedle</button>
            </form>
        </div>
    </div>
</div>

<!-- Gallery picker modal -->
<div class="modal fade" id="galleryPickerModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Wybierz zdjęcie z galerii</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <div class="border rounded p-2 mb-3 bg-light gallery-upload-box" data-gallery-id="60" data-target-grid="gallery-picker-grid" data-thumb-class="picker-thumb" data-thumb-style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:2px solid #dee2e6;" data-onclick-fn="selectCategoryImg">
                    <label class="form-label mb-1"><strong>Dodaj nowe zdjęcie do galerii</strong></label>
                    <div class="d-flex flex-wrap gap-2 align-items-center">
                        <input type="file" class="form-control form-control-sm gallery-upload-file" accept="image/png,image/jpeg,image/gif,image/webp" style="max-width:260px;">
                        <input type="text" class="form-control form-control-sm gallery-upload-title" placeholder="Tytuł (opcjonalny)" style="max-width:240px;">
                        <button type="button" class="btn btn-sm btn-success gallery-upload-btn">Dodaj zdjęcie</button>
                        <span class="gallery-upload-status text-muted small ms-2"></span>
                    </div>
                </div>
                <div id="gallery-picker-grid" style="display:flex;flex-wrap:wrap;gap:8px;max-height:400px;overflow-y:auto;">
                    {foreach from=$gallery_images item=gimg}
                    <div onclick="selectCategoryImg({$gimg.id}, '{$gimg.name|escape}')" style="cursor:pointer;" title="{$gimg.title}">
                        <img src="/uploads/thumb/{$gimg.name}" alt="{$gimg.title}"
                             style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:2px solid #dee2e6;"
                             class="picker-thumb" data-img-id="{$gimg.id}">
                    </div>
                    {/foreach}
                </div>
                {if !$gallery_images}
                <p class="text-muted gallery-empty-hint">Galeria jest pusta — dodaj pierwsze zdjęcie powyżej.</p>
                {/if}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
            </div>
        </div>
    </div>
</div>

<!-- Homepage image picker modal -->
<div class="modal fade" id="homepageImgPickerModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Wybierz zdjęcie na stronę główną</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <div class="border rounded p-2 mb-3 bg-light gallery-upload-box" data-gallery-id="60" data-target-grid="homepage-picker-grid" data-thumb-class="hp-picker-thumb" data-thumb-style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:2px solid #dee2e6;" data-onclick-fn="selectHomepageImg">
                    <label class="form-label mb-1"><strong>Dodaj nowe zdjęcie do galerii</strong></label>
                    <div class="d-flex flex-wrap gap-2 align-items-center">
                        <input type="file" class="form-control form-control-sm gallery-upload-file" accept="image/png,image/jpeg,image/gif,image/webp" style="max-width:260px;">
                        <input type="text" class="form-control form-control-sm gallery-upload-title" placeholder="Tytuł (opcjonalny)" style="max-width:240px;">
                        <button type="button" class="btn btn-sm btn-success gallery-upload-btn">Dodaj zdjęcie</button>
                        <span class="gallery-upload-status text-muted small ms-2"></span>
                    </div>
                </div>
                <div id="homepage-picker-grid" style="display:flex;flex-wrap:wrap;gap:8px;max-height:400px;overflow-y:auto;">
                    {foreach from=$gallery_images item=gimg}
                    <div onclick="selectHomepageImg({$gimg.id}, '{$gimg.name|escape}')" style="cursor:pointer;" title="{$gimg.title}">
                        <img src="/uploads/thumb/{$gimg.name}" alt="{$gimg.title}"
                             style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:2px solid #dee2e6;"
                             class="hp-picker-thumb" data-img-id="{$gimg.id}">
                    </div>
                    {/foreach}
                </div>
                {if !$gallery_images}
                <p class="text-muted gallery-empty-hint">Galeria jest pusta — dodaj pierwsze zdjęcie powyżej.</p>
                {/if}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
{literal}
<style>
.sortable-cat-row.ui-sortable-helper { background: #f8f9fa; box-shadow: 0 4px 12px rgba(0,0,0,.15); }
.sortable-cat-row.ui-sortable-placeholder { visibility: visible !important; background: #e9f0ff !important; height: 50px; }
</style>
<script>
$(function () {
    function showCatSavingIndicator(state) {
        $('#cat-queue-indicator').show();
        $('#cat-queue-saving-msg').hide();
        $('#cat-queue-saved-msg').hide();
        if (state === 'saving') {
            $('#cat-queue-saving-msg').show();
        } else if (state === 'saved') {
            $('#cat-queue-saved-msg').show();
            setTimeout(function () { $('#cat-queue-indicator').fadeOut(); }, 1500);
        } else if (state === 'error') {
            $('#cat-queue-saved-msg').text('✗ Błąd zapisu').removeClass('bg-success').addClass('bg-danger').show();
            setTimeout(function () {
                $('#cat-queue-indicator').fadeOut(function () {
                    $('#cat-queue-saved-msg').text('✓ Zapisano').removeClass('bg-danger').addClass('bg-success');
                });
            }, 2500);
        }
    }

    function refreshLp($table) {
        $table.find('tbody .sortable-cat-row').each(function (i) {
            $(this).find('.cat-lp').text(i + 1);
        });
    }

    $('table.sortable-categories tbody').sortable({
        items: '.sortable-cat-row',
        handle: '.cat-drag-handle',
        helper: function (e, tr) {
            var $originals = tr.children();
            var $helper = tr.clone();
            $helper.children().each(function (index) {
                $(this).width($originals.eq(index).width());
            });
            return $helper;
        },
        update: function () {
            var $table = $(this).closest('table.sortable-categories');
            refreshLp($table);
            var ids = [];
            $table.find('tbody .sortable-cat-row').each(function () {
                ids.push($(this).data('id'));
            });
            showCatSavingIndicator('saving');
            $.ajax({
                url: '/admin/utils/php/ajax-categories-queue.php',
                type: 'POST',
                dataType: 'json',
                data: { ids: ids },
                traditional: false,
                success: function (res) {
                    if (res && res.ok) { showCatSavingIndicator('saved'); }
                    else { showCatSavingIndicator('error'); }
                },
                error: function () { showCatSavingIndicator('error'); }
            });
        }
    }).disableSelection();

    $(document).on('click', '.cat-side-btn', function () {
        var $btn = $(this);
        var status = $btn.data('status');
        var side = $btn.data('side');
        var $group = $btn.parent();
        showCatSavingIndicator('saving');
        $.ajax({
            url: '/admin/utils/php/ajax-categories-first-side.php',
            type: 'POST',
            dataType: 'json',
            data: { status: status, side: side },
            success: function (res) {
                if (res && res.ok) {
                    $group.find('.cat-side-btn').removeClass('btn-primary').addClass('btn-outline-primary');
                    $btn.removeClass('btn-outline-primary').addClass('btn-primary');
                    showCatSavingIndicator('saved');
                } else {
                    showCatSavingIndicator('error');
                }
            },
            error: function () { showCatSavingIndicator('error'); }
        });
    });
});
</script>
<script>
function selectCategoryImg(imgId, imgName) {
    document.getElementById('category_img').value = imgId;
    var thumb = document.getElementById('category_img_thumb');
    thumb.src = '/uploads/thumb/' + imgName;
    document.getElementById('category_img_preview').style.display = 'block';
    document.getElementById('btn-clear-category-img').style.display = 'inline-block';
    document.querySelectorAll('.picker-thumb').forEach(function(t) {
        t.style.border = '2px solid #dee2e6';
    });
    document.querySelector('.picker-thumb[data-img-id="' + imgId + '"]').style.border = '2px solid #007bff';
    $('#galleryPickerModal').modal('hide');
}
function clearCategoryImg() {
    document.getElementById('category_img').value = '0';
    document.getElementById('category_img_preview').style.display = 'none';
    document.getElementById('btn-clear-category-img').style.display = 'none';
    document.querySelectorAll('.picker-thumb').forEach(function(t) {
        t.style.border = '2px solid #dee2e6';
    });
}
function selectHomepageImg(imgId, imgName) {
    document.getElementById('homepage_img').value = imgId;
    var thumb = document.getElementById('homepage_img_thumb');
    thumb.src = '/uploads/thumb/' + imgName;
    document.getElementById('homepage_img_preview').style.display = 'block';
    document.querySelectorAll('.hp-picker-thumb').forEach(function(t) {
        t.style.border = '2px solid #dee2e6';
    });
    document.querySelector('.hp-picker-thumb[data-img-id="' + imgId + '"]').style.border = '2px solid #28a745';
    $('#homepageImgPickerModal').modal('hide');
}

document.addEventListener('click', function (ev) {
    var btn = ev.target.closest('.gallery-upload-btn');
    if (!btn) return;
    var box = btn.closest('.gallery-upload-box');
    if (!box) return;
    var fileInput  = box.querySelector('.gallery-upload-file');
    var titleInput = box.querySelector('.gallery-upload-title');
    var statusEl   = box.querySelector('.gallery-upload-status');
    var grid       = document.getElementById(box.getAttribute('data-target-grid'));
    if (!fileInput || !grid) return;
    if (!fileInput.files || fileInput.files.length === 0) {
        statusEl.textContent = 'Wybierz plik';
        statusEl.className = 'gallery-upload-status text-danger small ms-2';
        return;
    }
    var fd = new FormData();
    fd.append('upload', fileInput.files[0]);
    fd.append('img_title', titleInput ? titleInput.value : '');
    fd.append('id_gallery', box.getAttribute('data-gallery-id') || '60');

    statusEl.textContent = 'Wgrywanie...';
    statusEl.className = 'gallery-upload-status text-muted small ms-2';
    btn.disabled = true;

    fetch('/admin/utils/php/ajax-gallery-upload.php', { method: 'POST', body: fd })
        .then(function (r) { return r.json(); })
        .then(function (res) {
            btn.disabled = false;
            if (!res || !res.ok) {
                statusEl.textContent = 'Błąd: ' + ((res && res.error) || 'nieznany');
                statusEl.className = 'gallery-upload-status text-danger small ms-2';
                return;
            }
            var hint = box.parentNode.querySelector('.gallery-empty-hint');
            if (hint) hint.remove();
            var thumbCls   = box.getAttribute('data-thumb-class') || '';
            var thumbStyle = box.getAttribute('data-thumb-style') || '';
            var fnName     = box.getAttribute('data-onclick-fn') || '';
            var wrap = document.createElement('div');
            wrap.style.cursor = 'pointer';
            wrap.title = res.title || '';
            wrap.setAttribute('onclick', fnName + '(' + res.id + ', "' + res.name.replace(/"/g, '&quot;') + '")');
            var img = document.createElement('img');
            img.src = '/uploads/thumb/' + res.name;
            img.alt = res.title || '';
            img.className = thumbCls;
            img.setAttribute('data-img-id', res.id);
            img.setAttribute('style', thumbStyle);
            wrap.appendChild(img);
            grid.appendChild(wrap);
            fileInput.value = '';
            if (titleInput) titleInput.value = '';
            statusEl.textContent = '✓ Dodano';
            statusEl.className = 'gallery-upload-status text-success small ms-2';
            setTimeout(function () { statusEl.textContent = ''; }, 2500);
        })
        .catch(function () {
            btn.disabled = false;
            statusEl.textContent = 'Błąd połączenia';
            statusEl.className = 'gallery-upload-status text-danger small ms-2';
        });
});
</script>
{/literal}
{literal}
<script>
document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('cat-add-form');
    if (form) {
        form.addEventListener('submit', function() {
            if (typeof tinymce !== 'undefined') tinymce.triggerSave();
        });
    }
});
if (typeof tinymce !== 'undefined') {
    tinymce.init({
        language: 'pl',
        selector: '#cat_description_add',
        width: '100%',
        height: 300,
        plugins: 'advlist autolink link lists charmap preview searchreplace wordcount visualblocks code fullscreen table emoticons paste',
        toolbar: 'undo redo | styleselect | bold italic | alignleft aligncenter alignright | bullist numlist | link | forecolor backcolor | code',
        menubar: false,
        content_css: [
            '../../../utils/css/bootstrap.css',
            '../../../utils/css/style-min.css'
        ]
    });
}
</script>
{/literal}

{if $has_category_map}
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
{literal}
<script>
var _adminMapAdd = null;
var _adminMarkerAdd = null;

function initAdminMapAdd() {
    if (_adminMapAdd) { _adminMapAdd.invalidateSize(); return; }
    _adminMapAdd = L.map('admin-map-add').setView([52.2297, 21.0122], 12);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(_adminMapAdd);
    _adminMapAdd.on('zoomend', function() {
        document.getElementById('map_zoom_add').value = _adminMapAdd.getZoom();
    });
    _adminMapAdd.on('click', function(e) {
        var lat = e.latlng.lat.toFixed(7);
        var lng = e.latlng.lng.toFixed(7);
        document.getElementById('map_lat_add').value = lat;
        document.getElementById('map_lng_add').value = lng;
        document.getElementById('map-coords-label-add').textContent = 'Pinezka: ' + lat + ', ' + lng;
        if (_adminMarkerAdd) {
            _adminMarkerAdd.setLatLng([lat, lng]);
        } else {
            _adminMarkerAdd = L.marker([lat, lng]).addTo(_adminMapAdd);
        }
    });
    document.getElementById('map-search-add').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') { e.preventDefault(); searchMapLocationAdd(); }
    });
}
function clearMapPinAdd() {
    document.getElementById('map_lat_add').value = '';
    document.getElementById('map_lng_add').value = '';
    document.getElementById('map-coords-label-add').textContent = 'Brak ustawionej lokalizacji — kliknij na mapie.';
    if (_adminMarkerAdd && _adminMapAdd) {
        _adminMapAdd.removeLayer(_adminMarkerAdd);
        _adminMarkerAdd = null;
    }
}
function searchMapLocationAdd() {
    var query = document.getElementById('map-search-add').value.trim();
    if (!query) return;
    var errEl = document.getElementById('map-search-error-add');
    errEl.style.display = 'none';
    fetch('https://nominatim.openstreetmap.org/search?format=json&limit=1&q=' + encodeURIComponent(query))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data && data.length > 0) {
                var lat = parseFloat(data[0].lat);
                var lng = parseFloat(data[0].lon);
                _adminMapAdd.setView([lat, lng], 15);
            } else {
                errEl.textContent = 'Nie znaleziono lokalizacji. Spróbuj podać dokładniejszy adres.';
                errEl.style.display = 'block';
            }
        })
        .catch(function() {
            errEl.textContent = 'Błąd połączenia z serwisem geocodowania.';
            errEl.style.display = 'block';
        });
}
(function() {
    var section = document.getElementById('mapLocationAddSection');
    if (section && typeof $ !== 'undefined') {
        $(section).on('shown.bs.collapse', function() { initAdminMapAdd(); });
    }
})();
</script>
{/literal}
{/if}