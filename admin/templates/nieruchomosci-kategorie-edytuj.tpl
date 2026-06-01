<div class="container-fluid">
    <div class="row block-white justify-content-md-center">
        <div class="col-7">
        <div class="content">
            <form method="POST" id="cat-edit-form">
                <h4>Edycja "{$name}"</h4>
                <br />

                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#ustawieniaSeoKat" aria-expanded="false" aria-controls="ustawieniaSeoKat">
                    Ustawienia SEO <span class="icon-arrow-right"></span>
                </button>
                <div class="collapse mb-3" id="ustawieniaSeoKat">
                    <div class="card card-body">
                        <div class="form-group">
                            <label>Title</label>
                            <input type="text" class="form-control" name="title_seo" value="{$title_seo}">
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <input type="text" class="form-control" name="meta_description" value="{$meta_description}">
                        </div>
                        <div class="form-group">
                            <label>Keywords</label>
                            <input type="text" class="form-control" name="keywords" value="{$keywords}">
                        </div>
                        <div class="form-group">
                            <label>Adres URL</label>
                            <label class="float-right create-url" onclick="javascript: generatedUrlByTitile()">Generuj URL na podstawie tytułu</label>
                            <input type="text" class="form-control" name="url" placeholder="nazwa-twojej-osiedla" id="url" value="{$seo_url}">
                            <small>*Jeżeli pozostawisz to pole puste adres URL wygeneruje się automatycznie na podstawie nazwy</small>
                        </div>
                    </div>
                </div>
				
                <button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#homeDates" aria-expanded="false" aria-controls="homeDates">
                    Osiedle na stronie głównej <span class="icon-arrow-right"></span>
                </button>		
                <div class="collapse mb-3" id="homeDates">
                    <div class="card card-body">
						<div class="form-group">
							<label>Zdjęcie na stronie głównej</label>
							<input type="hidden" name="homepage_img" id="homepage_img" value="{$current_homepage_img}">
							<div id="homepage_img_preview" class="mb-2" {if !($current_homepage_img > 0 && $current_homepage_img_name)}style="display:none;"{/if}>
								<img id="homepage_img_thumb" src="{if $current_homepage_img > 0 && $current_homepage_img_name}/uploads/thumb/{$current_homepage_img_name}{/if}" alt=""
									 style="height:90px;object-fit:cover;border-radius:4px;border:2px solid #28a745;">
								<br><small class="text-muted">Wybrane zdjęcie</small>
							</div>
							<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#homepageImgPickerModal">
								Wybierz zdjęcie na stronę główną
							</button>
							{if $current_homepage_img > 0}
							<button type="button" class="btn btn-outline-danger btn-sm ml-1" onclick="clearHomepageImg()">Usuń zdjęcie</button>
							{/if}
						</div>

						<div class="form-group">
							<label>Tytuł</label>
							<input type="text" name="homepage_title" class="form-control" value="{$homepage_title}" placeholder="Domyślnie: nazwa kategorii">
						</div>

						<div class="form-group">
							<label>Podtytuł </label>
							<input type="text" name="homepage_subtitle" class="form-control" value="{$homepage_subtitle}" placeholder="Krótki podtytuł / opis wyświetlany pod tytułem">
						</div>
					</div>
				</div>
				
				{if $has_icons_table}
				<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#iconyCategorySection" aria-expanded="false" aria-controls="iconyCategorySection">
					Ikony Osiedla <span class="icon-arrow-right"></span>
				</button>
				<div class="collapse mb-3" id="iconyCategorySection">
					<div class="card card-body">
						<p class="text-muted small mb-3">Ikony wyświetlają się pod banerem osiedla na stronie inwestycji. Wybierz ikonę z galerii i opcjonalnie dodaj opis.</p>

						{if $category_icons}
						<div class="d-flex flex-wrap gap-3 mb-3">
							{foreach from=$category_icons item=icon}
							<div class="card" style="width:130px;">
								<div class="card-body p-2 text-center">
									<img src="/uploads/thumb/{$icon.img_name}" alt="" style="width:64px;height:64px;object-fit:contain;">
									{if $icon.description}<p class="small text-muted mt-1 mb-1" style="word-break:break-word;">{$icon.description}</p>{/if}
									<div class="mt-1">
										<button type="button" onclick="deleteIcon({$icon.id})" class="btn btn-outline-danger btn-sm w-100">Usuń</button>
									</div>
								</div>
							</div>
							{/foreach}
						</div>
						{else}
						<p class="text-muted mb-3">Brak ikon. Dodaj pierwszą ikonę poniżej.</p>
						{/if}

						<button type="button" class="btn btn-outline-secondary" data-toggle="modal" data-target="#iconPickerModal">
							+ Dodaj ikonę
						</button>
					</div>
				</div>
				{/if}

				{if $has_slider_table}
				<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#sliderCategorySection" aria-expanded="false" aria-controls="sliderCategorySection" id="slider-section-btn">
					Slider na stronie głównej <span class="icon-arrow-right"></span>
				</button>
				<div class="collapse mb-3" id="sliderCategorySection">
					<div class="card card-body">
						<p class="text-muted small mb-1">Slajdy wyświetlają się w sliderze na stronie głównej (pełnoekranowym). Slider pojawia się, gdy dodano co najmniej jeden slajd dla dowolnego osiedla.</p>
						<p class="mb-3"><strong>Osiedle: {$name}</strong> <small class="text-muted">— poniższe slajdy należą wyłącznie do tej kategorii.</small></p>

						{if $category_slider_slides}
						<div class="d-flex flex-wrap gap-3 mb-3">
							{foreach from=$category_slider_slides item=slide}
							<div class="card" style="width:210px;">
								<div class="card-body p-2">
									{if $slide.img_name}
									<img src="/uploads/thumb/{$slide.img_name}" alt="" style="width:100%;height:80px;object-fit:cover;border-radius:4px;margin-bottom:6px;">
									{else}
									<div style="width:100%;height:80px;background:#dee2e6;border-radius:4px;margin-bottom:6px;display:flex;align-items:center;justify-content:center;"><small class="text-muted">Brak zdjęcia</small></div>
									{/if}
									<p class="small mb-1"><strong>Pozycja: {$slide.slide_order}</strong></p>
									{if $slide.text_p1}<p class="small text-muted mb-0" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">P1: {$slide.text_p1}</p>{/if}
									{if $slide.text_p2}<p class="small text-muted mb-0" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">P2: {$slide.text_p2}</p>{/if}
									{if $slide.text_p3}<p class="small text-muted mb-0" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">Przycisk: {$slide.text_p3}</p>{/if}
									<div class="d-flex gap-1 mt-2">
										<button type="button"
											class="btn btn-outline-primary btn-sm flex-fill"
											onclick="openEditSlide({$slide.id}, {$slide.image_id|default:0}, '{$slide.img_name|default:''|escape}', {$slide.slide_order}, '{$slide.text_p1|default:''|escape}', '{$slide.text_p2|default:''|escape}', '{$slide.text_p3|default:''|escape}')">
											Edytuj
										</button>
										<button type="button" onclick="deleteSlide({$slide.id})" class="btn btn-outline-danger btn-sm flex-fill">Usuń</button>
									</div>
								</div>
							</div>
							{/foreach}
						</div>
						{else}
						<p class="text-muted mb-3">Brak slajdów. Dodaj pierwszy slajd poniżej.</p>
						{/if}

						<button type="button" class="btn btn-outline-secondary" data-toggle="modal" data-target="#addSlideModal">
							+ Dodaj slajd
						</button>
					</div>
				</div>
				{/if}

				{if $has_category_map}
				<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="collapse" data-target="#mapLocationSection" aria-expanded="false" aria-controls="mapLocationSection">
					Mapa lokalizacji <span class="icon-arrow-right"></span>
				</button>
				{/if}

				{if $has_svg_map_table}
				<button class="btn btn-primary mb-3 right-ico collapsed" type="button" data-toggle="modal" data-target="#svgMapBuilderModal">
					Mapa nieruchomości <span class="icon-arrow-right"></span>
				</button>
				{/if}

				{if $has_category_map}
				<div class="collapse mb-3" id="mapLocationSection">
					<div class="card card-body">
						<p class="text-muted small mb-2">Kliknij na mapie, aby ustawić pinezke lokalizacji osiedla. Mapa wyświetli się na stronie kategorii.</p>
						<input type="hidden" name="map_lat" id="map_lat" value="{$category_map_lat|default:''}">
						<input type="hidden" name="map_lng" id="map_lng" value="{$category_map_lng|default:''}">
						<input type="hidden" name="map_zoom" id="map_zoom" value="{$category_map_zoom|default:15}">
						<div class="input-group mb-2">
							<input type="text" class="form-control" id="map-search" placeholder="Kraj, Miasto, Ulica" autocomplete="off">
							<button class="btn btn-outline-secondary" type="button" onclick="searchMapLocation()">Szukaj</button>
						</div>
						<div id="map-search-error" class="text-danger small mb-1" style="display:none;"></div>
						<div id="admin-map" style="height:400px;border-radius:4px;position:relative;z-index:1;"></div>
						<div class="d-flex align-items-center gap-2 mt-2">
							<small class="text-muted" id="map-coords-label">
								{if $category_map_lat && $category_map_lng}
									Pinezka: {$category_map_lat}, {$category_map_lng}
								{else}
									Brak ustawionej lokalizacji — kliknij na mapie.
								{/if}
							</small>
							<button type="button" class="btn btn-outline-secondary btn-sm" onclick="clearMapPin()">Usuń pinezke</button>
						</div>
					</div>
				</div>
				{/if}

                <div class="form-group">
                    <label>Nazwa osiedla</label>
                    <input type="text" name="name" id="title" class="form-control" value="{$name}"/>
                </div>
                <div class="form-group">
                    <label>Nazwa w menu <small class="text-muted">(jeśli pusta — wyświetlana jest nazwa osiedla)</small></label>
                    <input type="text" name="menu_name" class="form-control" value="{$menu_name}" placeholder="{$name}"/>
                </div>
                <div class="form-group">
                    <label>Status osiedla</label>
                    <select name="status" class="form-control">
                        <option value="0" {if (int)$status === 0}selected{/if}>W realizacji</option>
                        <option value="1" {if (int)$status === 1}selected{/if}>Zrealizowano</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Opis kategorii</label>
                    <textarea name="description" id="cat_description_edit" rows="6" placeholder="Opis wyświetlany pod grafiką na stronie kategorii...">{$description}</textarea>
                </div>

                <div class="form-group">
                    <label>Grafika banera</label>
                    <input type="hidden" name="category_img" id="category_img" value="{$current_img}">
                    <div id="category_img_preview" class="mb-2" {if !($current_img > 0 && $current_img_name)}style="display:none;"{/if}>
                        <img id="category_img_thumb" src="{if $current_img > 0 && $current_img_name}/uploads/thumb/{$current_img_name}{/if}" alt=""
                             style="height:90px;object-fit:cover;border-radius:4px;border:2px solid #007bff;">
                        <br><small class="text-muted">Wybrane zdjęcie</small>
                    </div>
                    <button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#galleryPickerModal">
                        Wybierz zdjęcie z galerii
                    </button>
                    <button type="button" id="btn-clear-category-img" class="btn btn-outline-danger btn-sm ml-1" onclick="clearCategoryImg()" {if !($current_img > 0 && $current_img_name)}style="display:none;"{/if}>Usuń zdjęcie</button>
                </div>
				
				<hr>

                <a href="/admin/nieruchomosci/kategorie"><button class="btn btn-primary" type="button">Powrót do listy</button></a>
                <button type="submit" name="confirm_edit" class="btn btn-success float-right">Zapisz zmiany</button>
            </form>

        </div>
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
                             style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:2px solid {if $current_img == $gimg.id}#007bff{else}#dee2e6{/if};"
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

<!-- Icon picker modal -->
{if $has_icons_table}
<div class="modal fade" id="iconPickerModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Dodaj ikonę</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <form method="POST">
                <div class="modal-body">
                    <div class="form-group mb-3">
                        <label><strong>Wybierz ikonę z galerii</strong></label>
                        <input type="hidden" name="icon_image_id" id="icon_image_id" value="0">
                        <div id="icon-selected-preview" class="mb-2" style="display:none;">
                            <img id="icon-selected-thumb" src="" alt="" style="width:64px;height:64px;object-fit:contain;border:2px solid #007bff;border-radius:4px;">
                            <small class="d-block text-muted">Wybrana ikona</small>
                        </div>
                        {if $gallery_images}
                        <div style="display:flex;flex-wrap:wrap;gap:8px;max-height:320px;overflow-y:auto;border:1px solid #dee2e6;border-radius:4px;padding:8px;">
                            {foreach from=$gallery_images item=gimg}
                            <div onclick="selectIcon({$gimg.id}, '{$gimg.name|escape}')" style="cursor:pointer;" title="{$gimg.title}">
                                <img src="/uploads/thumb/{$gimg.name}" alt="{$gimg.title}"
                                     style="width:72px;height:72px;object-fit:contain;border-radius:4px;border:2px solid #dee2e6;"
                                     class="icon-picker-thumb" data-img-id="{$gimg.id}">
                            </div>
                            {/foreach}
                        </div>
                        {else}
                        <p class="text-muted">Brak zdjęć w galerii (id=60).</p>
                        {/if}
                    </div>
                    <div class="form-group">
                        <label>Opis ikony <small class="text-muted">(opcjonalny, wyświetlany pod ikoną)</small></label>
                        <input type="text" name="icon_description" id="icon_description" class="form-control" placeholder="np. Szkoła 500 m">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
                    <button type="submit" name="add_category_icon" class="btn btn-primary" id="icon-add-btn" disabled>Dodaj ikonę</button>
                </div>
            </form>
        </div>
    </div>
</div>
{/if}

<!-- Slider image picker modal -->
{if $has_slider_table}
<div class="modal fade" id="sliderImgPickerModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Wybierz zdjęcie tła slajdu</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                {if $gallery_images}
                <div style="display:flex;flex-wrap:wrap;gap:8px;max-height:400px;overflow-y:auto;">
                    {foreach from=$gallery_images item=gimg}
                    <div onclick="selectSliderImg({$gimg.id}, '{$gimg.name|escape}')" style="cursor:pointer;" title="{$gimg.title}">
                        <img src="/uploads/thumb/{$gimg.name}" alt="{$gimg.title}"
                             style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:2px solid #dee2e6;"
                             class="slider-picker-thumb" data-img-id="{$gimg.id}">
                    </div>
                    {/foreach}
                </div>
                {else}
                <p class="text-muted">Brak zdjęć w galerii.</p>
                {/if}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
            </div>
        </div>
    </div>
</div>
{/if}

<!-- Add slide modal -->
{if $has_slider_table}
<div class="modal fade" id="addSlideModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Dodaj slajd — <strong>{$name}</strong></h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <form method="POST">
                <div class="modal-body">
                    <div class="form-group mb-2">
                        <label class="small font-weight-bold">Zdjęcie tła slajdu</label>
                        <input type="hidden" name="slider_image_id" id="slider_image_id" value="0">
                        <div id="slider_img_preview" class="mb-2" style="display:none;">
                            <img id="slider_img_thumb" src="" alt="" style="height:80px;object-fit:cover;border-radius:4px;border:2px solid #6610f2;">
                            <br><small class="text-muted">Wybrane zdjęcie</small>
                        </div>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="openSliderImgPickerFor('add')">
                            Wybierz zdjęcie tła
                        </button>
                    </div>
                    <div class="form-group mb-2">
                        <label class="small font-weight-bold">Pozycja slajdu</label>
                        <select name="slider_slide_order" class="form-control form-control-sm" style="width:auto;">
                            {for $i=1 to $total_categories_count}
                            <option value="{$i}">{$i}</option>
                            {/for}
                        </select>
                    </div>
                    <div class="form-group mb-2">
                        <label class="small">Tekst P1 <small class="text-muted">(np. Domy jednorodzinne)</small></label>
                        <input type="text" name="slider_text_p1" class="form-control form-control-sm" placeholder="Tekst nagłówkowy">
                    </div>
                    <div class="form-group mb-2">
                        <label class="small">Tekst P2 <small class="text-muted">(np. Osiedle Podkowy)</small></label>
                        <input type="text" name="slider_text_p2" class="form-control form-control-sm" placeholder="Nazwa osiedla / tytuł">
                    </div>
                    <div class="form-group mb-2">
                        <label class="small">Tekst przycisku P3 <small class="text-muted">(link prowadzi do tej kategorii)</small></label>
                        <input type="text" name="slider_text_p3" class="form-control form-control-sm" placeholder="np. Zobacz domy">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
                    <button type="submit" name="add_slider_slide" class="btn btn-primary">Dodaj slajd</button>
                </div>
            </form>
        </div>
    </div>
</div>
{/if}

<!-- Edit slide modal -->
{if $has_slider_table}
<div class="modal fade" id="editSlideModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edycja slajdu</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <form method="POST">
                <div class="modal-body">
                    <input type="hidden" name="edit_slide_id" id="edit_slide_id" value="0">
                    <div class="form-group mb-2">
                        <label class="small font-weight-bold">Zdjęcie tła slajdu</label>
                        <input type="hidden" name="edit_slider_image_id" id="edit_slider_image_id" value="0">
                        <div id="edit_slider_img_preview" class="mb-2" style="display:none;">
                            <img id="edit_slider_img_thumb" src="" alt="" style="height:80px;object-fit:cover;border-radius:4px;border:2px solid #6610f2;">
                            <br><small class="text-muted">Wybrane zdjęcie</small>
                        </div>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="openSliderImgPickerFor('edit')">
                            Wybierz zdjęcie tła
                        </button>
                    </div>
                    <div class="form-group mb-2">
                        <label class="small font-weight-bold">Pozycja slajdu</label>
                        <select name="edit_slider_slide_order" id="edit_slider_slide_order" class="form-control form-control-sm" style="width:auto;">
                            {for $i=1 to $total_categories_count}
                            <option value="{$i}">{$i}</option>
                            {/for}
                        </select>
                    </div>
                    <div class="form-group mb-2">
                        <label class="small">Tekst P1 <small class="text-muted">(np. Domy jednorodzinne)</small></label>
                        <input type="text" name="edit_slider_text_p1" id="edit_slider_text_p1" class="form-control form-control-sm" placeholder="Tekst nagłówkowy">
                    </div>
                    <div class="form-group mb-2">
                        <label class="small">Tekst P2 <small class="text-muted">(np. Osiedle Podkowy)</small></label>
                        <input type="text" name="edit_slider_text_p2" id="edit_slider_text_p2" class="form-control form-control-sm" placeholder="Nazwa osiedla / tytuł">
                    </div>
                    <div class="form-group mb-2">
                        <label class="small">Tekst przycisku P3 <small class="text-muted">(link prowadzi do tej kategorii)</small></label>
                        <input type="text" name="edit_slider_text_p3" id="edit_slider_text_p3" class="form-control form-control-sm" placeholder="np. Zobacz domy">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
                    <button type="submit" name="edit_slider_slide" class="btn btn-primary">Zapisz zmiany</button>
                </div>
            </form>
        </div>
    </div>
</div>
{/if}

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
                             style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:2px solid {if $current_homepage_img == $gimg.id}#28a745{else}#dee2e6{/if};"
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

{literal}
<script>
function selectCategoryImg(imgId, imgName) {
    document.getElementById('category_img').value = imgId;
    var thumb = document.getElementById('category_img_thumb');
    thumb.src = '/uploads/thumb/' + imgName;
    document.getElementById('category_img_preview').style.display = 'block';
    var clearBtn = document.getElementById('btn-clear-category-img');
    if (clearBtn) clearBtn.style.display = 'inline-block';
    document.querySelectorAll('.picker-thumb').forEach(function(t) {
        t.style.border = '2px solid #dee2e6';
    });
    document.querySelector('.picker-thumb[data-img-id="' + imgId + '"]').style.border = '2px solid #007bff';
    $('#galleryPickerModal').modal('hide');
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
function clearHomepageImg() {
    document.getElementById('homepage_img').value = '0';
    document.getElementById('homepage_img_preview').style.display = 'none';
}
function clearCategoryImg() {
    document.getElementById('category_img').value = '0';
    document.getElementById('category_img_preview').style.display = 'none';
    document.getElementById('btn-clear-category-img').style.display = 'none';
    document.querySelectorAll('.picker-thumb').forEach(function(t) {
        t.style.border = '2px solid #dee2e6';
    });
}
function deleteIcon(iconId) {
    if (!confirm('Usuń ikonę?')) return;
    var form = document.createElement('form');
    form.method = 'POST';
    var i1 = document.createElement('input');
    i1.type = 'hidden'; i1.name = 'icon_id'; i1.value = iconId;
    var i2 = document.createElement('input');
    i2.type = 'hidden'; i2.name = 'delete_category_icon'; i2.value = '1';
    form.appendChild(i1);
    form.appendChild(i2);
    document.body.appendChild(form);
    form.submit();
}
function deleteSlide(slideId) {
    if (!confirm('Usuń slajd?')) return;
    var form = document.createElement('form');
    form.method = 'POST';
    var i1 = document.createElement('input');
    i1.type = 'hidden'; i1.name = 'slide_id'; i1.value = slideId;
    var i2 = document.createElement('input');
    i2.type = 'hidden'; i2.name = 'delete_slider_slide'; i2.value = '1';
    form.appendChild(i1);
    form.appendChild(i2);
    document.body.appendChild(form);
    form.submit();
}
var _sliderPickerContext = 'add';
function openSliderImgPickerFor(ctx) {
    _sliderPickerContext = ctx;
    $('#sliderImgPickerModal').modal('show');
}
function selectSliderImg(imgId, imgName) {
    var prefix = _sliderPickerContext === 'edit' ? 'edit_slider' : 'slider';
    document.getElementById(prefix + '_image_id').value = imgId;
    var thumb = document.getElementById(prefix + '_img_thumb');
    thumb.src = '/uploads/thumb/' + imgName;
    document.getElementById(prefix + '_img_preview').style.display = 'block';
    document.querySelectorAll('.slider-picker-thumb').forEach(function(t) {
        t.style.border = '2px solid #dee2e6';
    });
    var active = document.querySelector('.slider-picker-thumb[data-img-id="' + imgId + '"]');
    if (active) active.style.border = '2px solid #6610f2';
    $('#sliderImgPickerModal').modal('hide');
}
function openEditSlide(id, imgId, imgName, order, p1, p2, p3) {
    document.getElementById('edit_slide_id').value = id;
    document.getElementById('edit_slider_image_id').value = imgId;
    document.getElementById('edit_slider_slide_order').value = order;
    document.getElementById('edit_slider_text_p1').value = p1;
    document.getElementById('edit_slider_text_p2').value = p2;
    document.getElementById('edit_slider_text_p3').value = p3;
    var thumb = document.getElementById('edit_slider_img_thumb');
    var preview = document.getElementById('edit_slider_img_preview');
    if (imgId > 0 && imgName) {
        thumb.src = '/uploads/thumb/' + imgName;
        preview.style.display = 'block';
    } else {
        thumb.src = '';
        preview.style.display = 'none';
    }
    $('#editSlideModal').modal('show');
}
function selectIcon(imgId, imgName) {
    document.getElementById('icon_image_id').value = imgId;
    var thumb = document.getElementById('icon-selected-thumb');
    thumb.src = '/uploads/thumb/' + imgName;
    document.getElementById('icon-selected-preview').style.display = 'block';
    document.querySelectorAll('.icon-picker-thumb').forEach(function(t) {
        t.style.border = '2px solid #dee2e6';
    });
    var active = document.querySelector('.icon-picker-thumb[data-img-id="' + imgId + '"]');
    if (active) active.style.border = '2px solid #007bff';
    document.getElementById('icon-add-btn').disabled = false;
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
if (window.location.hash === '#map-location') {
    var elMap = document.getElementById('mapLocationSection');
    if (elMap && typeof $ !== 'undefined') { $(elMap).collapse('show'); }
}
if (window.location.hash === '#category-icons') {
    var el = document.getElementById('iconyCategorySection');
    if (el && typeof $ !== 'undefined') { $(el).collapse('show'); }
}
if (window.location.hash === '#slider-section') {
    var elSlider = document.getElementById('sliderCategorySection');
    if (elSlider && typeof $ !== 'undefined') { $(elSlider).collapse('show'); }
}
document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('cat-edit-form');
    if (form) {
        form.addEventListener('submit', function() {
            if (typeof tinymce !== 'undefined') tinymce.triggerSave();
        });
    }
});
if (typeof tinymce !== 'undefined') {
    tinymce.init({
        language: 'pl',
        selector: '#cat_description_edit',
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
<script>
var _adminMap = null;
var _adminMarker = null;
var _adminMapInitLat  = {if $category_map_lat}{$category_map_lat}{else}52.2297{/if};
var _adminMapInitLng  = {if $category_map_lng}{$category_map_lng}{else}21.0122{/if};
var _adminMapInitZoom = {if $category_map_zoom}{$category_map_zoom}{else}15{/if};
var _adminMapHasPin   = {if $category_map_lat && $category_map_lng}true{else}false{/if};
</script>
{literal}
<script>
function initAdminMap() {
    if (_adminMap) { _adminMap.invalidateSize(); return; }
    _adminMap = L.map('admin-map').setView([_adminMapInitLat, _adminMapInitLng], _adminMapHasPin ? _adminMapInitZoom : 12);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(_adminMap);
    if (_adminMapHasPin) {
        _adminMarker = L.marker([_adminMapInitLat, _adminMapInitLng]).addTo(_adminMap);
    }
    _adminMap.on('zoomend', function() {
        document.getElementById('map_zoom').value = _adminMap.getZoom();
    });
    _adminMap.on('click', function(e) {
        var lat = e.latlng.lat.toFixed(7);
        var lng = e.latlng.lng.toFixed(7);
        document.getElementById('map_lat').value = lat;
        document.getElementById('map_lng').value = lng;
        document.getElementById('map-coords-label').textContent = 'Pinezka: ' + lat + ', ' + lng;
        if (_adminMarker) {
            _adminMarker.setLatLng([lat, lng]);
        } else {
            _adminMarker = L.marker([lat, lng]).addTo(_adminMap);
        }
    });
    document.getElementById('map-search').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') { e.preventDefault(); searchMapLocation(); }
    });
}
function clearMapPin() {
    document.getElementById('map_lat').value = '';
    document.getElementById('map_lng').value = '';
    document.getElementById('map-coords-label').textContent = 'Brak ustawionej lokalizacji — kliknij na mapie.';
    if (_adminMarker && _adminMap) {
        _adminMap.removeLayer(_adminMarker);
        _adminMarker = null;
    }
}
function searchMapLocation() {
    var query = document.getElementById('map-search').value.trim();
    if (!query) return;
    var errEl = document.getElementById('map-search-error');
    errEl.style.display = 'none';
    fetch('https://nominatim.openstreetmap.org/search?format=json&limit=1&q=' + encodeURIComponent(query))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data && data.length > 0) {
                var lat = parseFloat(data[0].lat);
                var lng = parseFloat(data[0].lon);
                _adminMap.setView([lat, lng], 15);
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
    var section = document.getElementById('mapLocationSection');
    if (section && typeof $ !== 'undefined') {
        $(section).on('shown.bs.collapse', function() { initAdminMap(); });
    }
})();
</script>
{/literal}
{/if}

{* ============================================================ SVG MAP BUILDER ============================================================ *}
{if $has_svg_map_table}

<!-- SVG Map Builder Modal (full-screen) -->
<div class="modal fade" id="svgMapBuilderModal" tabindex="-1" role="dialog" aria-labelledby="svgMapBuilderLabel">
    <div class="modal-dialog svgmap-modal-fullscreen" role="document">
        <div class="modal-content" style="border-radius:0;min-height:100vh;">
            <div class="modal-header" style="background:#2c3e50;color:#fff;border-radius:0;">
                <h5 class="modal-title" id="svgMapBuilderLabel">Mapa nieruchomości — <strong>{$name}</strong></h5>
                <button type="button" class="close" data-dismiss="modal" style="color:#fff;opacity:1;"><span>&times;</span></button>
            </div>
            <div class="modal-body p-0" style="background:#1a1a2e;">

                <!-- Phase: no image selected -->
                <div id="svgmap-phase-empty" style="padding:40px;text-align:center;color:#ccc;">
                    <p class="mb-3" style="font-size:1.1rem;">Wybierz obraz bazowy mapy osiedla</p>
                    <button type="button" id="btn-svgmap-select-img" class="btn btn-primary btn-lg">
                        Wybierz obrazek
                    </button>
                </div>

                <!-- Phase: editor -->
                <div id="svgmap-phase-editor" style="display:none;">

                    <!-- Toolbar -->
                    <div id="svgmap-toolbar" style="background:#2c3e50;padding:10px 16px;display:flex;align-items:center;flex-wrap:wrap;gap:8px;">
                        <button type="button" id="btn-svgmap-change-img" class="btn btn-secondary btn-sm">
                            Zmień obrazek
                        </button>
                        <button type="button" id="btn-svgmap-draw" class="btn btn-info btn-sm">
                            Narysuj kształt
                        </button>
                        <span id="svgmap-draw-hint" style="display:none;color:#ffe082;font-size:0.85rem;margin-left:8px;">
                            Narysuj kształt nieruchomości. Aby zakończyć rysowanie naciśnij spację lub prawy przycisk myszy
                        </span>
                        <span id="svgmap-move-hint" style="display:none;color:#90caf9;font-size:0.85rem;margin-left:8px;"></span>
                        <button type="button" id="btn-svgmap-save" class="btn btn-success btn-sm ml-auto" style="display:none;">
                            Zapisz mapę
                        </button>
                    </div>

                    <!-- Canvas -->
                    <div id="svgmap-canvas-outer" style="width:100%;background:#111;display:flex;align-items:center;justify-content:center;overflow:auto;min-height:200px;max-height:80vh;padding:16px;box-sizing:border-box;">
                        <div id="svgmap-canvas-container" style="position:relative;display:inline-block;line-height:0;flex-shrink:0;">
                            <img id="svgmap-bitmap-img" src="" alt="" style="display:block;max-width:calc(100vw - 32px);max-height:75vh;width:auto;height:auto;user-select:none;pointer-events:none;">
                            <svg id="svgmap-svg"
                                 style="position:absolute;top:0;left:0;width:100%;height:100%;overflow:visible;"
                                 preserveAspectRatio="xMidYMid meet">
                            </svg>

                            <!-- Property select panel -->
                            <div id="svgmap-panel-property"
                                 style="display:none;position:absolute;z-index:30;background:#fff;border:2px solid #007bff;border-radius:6px;padding:12px 14px;min-width:260px;box-shadow:0 4px 16px rgba(0,0,0,0.4);">
                                <p class="mb-2 font-weight-bold" style="font-size:0.9rem;">Wybierz nieruchomość:</p>
                                <select id="svgmap-prop-select" class="form-control form-control-sm mb-2">
                                    <option value="">-- Wybierz nieruchomość --</option>
                                </select>
                                <button type="button" class="btn btn-primary btn-sm w-100" onclick="svgMapConfirmProperty()">Potwierdź</button>
                            </div>

                            <!-- Tooltip side panel -->
                            <div id="svgmap-panel-tooltip"
                                 style="display:none;position:absolute;z-index:30;background:#fff;border:2px solid #28a745;border-radius:6px;padding:12px 14px;min-width:240px;box-shadow:0 4px 16px rgba(0,0,0,0.4);">
                                <p class="mb-2 font-weight-bold" style="font-size:0.9rem;">Pozycja chmurki z informacjami:</p>
                                <div class="btn-group w-100">
                                    <button type="button" id="svgmap-tooltip-left"  class="btn btn-outline-secondary btn-sm" onclick="svgMapConfirmTooltip('left')">Chmurka po lewej</button>
                                    <button type="button" id="svgmap-tooltip-right" class="btn btn-outline-secondary btn-sm" onclick="svgMapConfirmTooltip('right')">Chmurka po prawej</button>
                                </div>
                            </div>

                            <!-- Edit shape panel -->
                            <div id="svgmap-panel-edit"
                                 style="display:none;position:absolute;z-index:30;background:#fff;border:2px solid #fd7e14;border-radius:6px;padding:12px 14px;min-width:260px;box-shadow:0 4px 16px rgba(0,0,0,0.4);">
                                <p class="mb-2 font-weight-bold" style="font-size:0.9rem;">Edycja kształtu:</p>
                                <label class="small mb-1">Nieruchomość:</label>
                                <select id="svgmap-edit-prop-select" class="form-control form-control-sm mb-2">
                                    <option value="">-- Wybierz nieruchomość --</option>
                                </select>
                                <label class="small mb-1">Pozycja chmurki:</label>
                                <div class="btn-group w-100 mb-2">
                                    <button type="button" id="svgmap-edit-tooltip-left"  class="btn btn-outline-secondary btn-sm" onclick="svgMapSetEditTooltip('left')">Po lewej</button>
                                    <button type="button" id="svgmap-edit-tooltip-right" class="btn btn-outline-secondary btn-sm" onclick="svgMapSetEditTooltip('right')">Po prawej</button>
                                </div>
                                <button type="button" class="btn btn-warning btn-sm w-100" onclick="svgMapConfirmEdit()">Zapisz zmiany kształtu</button>
                            </div>

                        </div><!-- /svgmap-canvas-container -->
                    </div><!-- /svgmap-canvas-outer -->

                </div><!-- /phase-editor -->

            </div><!-- /modal-body -->
        </div>
    </div>
</div>

<!-- Bitmap picker modal (inside SVG Map context) -->
<div class="modal fade" id="svgmapBitmapPickerModal" tabindex="-1" role="dialog" style="z-index:1060;">
    <div class="modal-dialog modal-xl" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Wybierz obraz bazowy mapy</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                {if $gallery_images}
                <div style="display:flex;flex-wrap:wrap;gap:8px;max-height:500px;overflow-y:auto;">
                    {foreach from=$gallery_images item=gimg}
                    <div onclick="svgMapSelectBitmap({$gimg.id}, '{$gimg.name|escape}')" style="cursor:pointer;" title="{$gimg.title}">
                        <img src="/uploads/thumb/{$gimg.name}" alt="{$gimg.title}"
                             style="width:110px;height:110px;object-fit:cover;border-radius:4px;border:2px solid #dee2e6;"
                             class="svgmap-picker-thumb" data-img-id="{$gimg.id}">
                    </div>
                    {/foreach}
                </div>
                {else}
                <p class="text-muted">Brak zdjęć w galerii.</p>
                {/if}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
            </div>
        </div>
    </div>
</div>

<style>
.svgmap-modal-fullscreen {
    max-width: 100%;
    width: 100%;
    margin: 0;
}
.svgmap-modal-fullscreen .modal-content {
    min-height: 100vh;
}
#svgmap-svg polygon { transition: fill-opacity 0.15s; }
.btn-xs { padding: 2px 7px; font-size: 11px; border-radius: 3px; }
</style>

<script>
var _svgMapCategoryId  = {$category_id};
var _svgMapSaveUrl     = '/admin/api/svg-map-save.php?cat={$category_id}';
var _svgMapProperties  = {$category_properties_json};
var _svgMapExisting    = {if $svg_map_data}{ldelim}"image_id":{$svg_map_data.image_id|default:0},"image_name":"{$svg_map_data.image_name|escape:'javascript'}","image_width":{$svg_map_data.image_width|default:0},"image_height":{$svg_map_data.image_height|default:0},"shapes":{if $svg_map_data.shapes}{$svg_map_data.shapes}{else}[]{/if}{rdelim}{else}null{/if};
</script>
<script src="/utils/js/svg-map-admin.js?v=3"></script>
{literal}
<script>
document.addEventListener('DOMContentLoaded', function() {
    svgMapAdminInit(_svgMapCategoryId, _svgMapSaveUrl, _svgMapProperties, _svgMapExisting);

    // Populate property selects from JS data
    function buildPropOptions(selectEl, currentId) {
        selectEl.innerHTML = '<option value="">-- Wybierz nieruchomość --</option>';
        _svgMapProperties.forEach(function(p) {
            var opt = document.createElement('option');
            opt.value = p.id;
            opt.textContent = p.title + (p.house_status ? ' [' + p.house_status + ']' : '');
            if (p.id == currentId) opt.selected = true;
            selectEl.appendChild(opt);
        });
    }

    var propSel     = document.getElementById('svgmap-prop-select');
    var editPropSel = document.getElementById('svgmap-edit-prop-select');
    if (propSel)     buildPropOptions(propSel, 0);
    if (editPropSel) buildPropOptions(editPropSel, 0);

    // Re-populate edit select when it opens (picks current value)
    document.getElementById('svgMapBuilderModal').addEventListener('show.bs.modal', function() {});
});

function svgMapSetEditTooltip(side) {
    document.getElementById('svgmap-edit-tooltip-left').classList.toggle('active',  side === 'left');
    document.getElementById('svgmap-edit-tooltip-right').classList.toggle('active', side === 'right');
}
</script>
{/literal}

{/if}{* /has_svg_map_table *}