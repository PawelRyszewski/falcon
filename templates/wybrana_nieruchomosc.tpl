<main>
  {* #2: Composite title — "Kategoria — Nieruchomość" *}
	<section class="container" data-aos="fade-up">
	<header class="section-header" style="margin-top:20px !important">
		<div class="section-header__ribbon">
			{if $category_name}
			<h1 class="section-header__title mb-0">{$category_name} - {$realestate.title}</h1>
			 {else}
			 <h1 class="section-header__title mb-0">{$realestate.title}</h1>
			 {/if}
		</div>	
	</header>
	</section>


  {* #3: Full-width layout — no sidebar *}
  <section>
    <div class="container" style="padding-left:0 !important; padding-right:0 !important;">
      <div class="row">
        <div class="col-12">

          {* #4: Gallery slider — only if ≥2 images, auto-advances every 5s *}
          {if $images|@count >= 2}
                <div id="investmentGallery" class="carousel slide mb-3"
                     data-bs-ride="carousel"
                     data-bs-interval="5000">
                  <div class="carousel-inner overflow-hidden">
                    {foreach from=$images item=$image name=main_gallery}
                      <div class="carousel-item {if $smarty.foreach.main_gallery.first}active{/if}">
                        <a href="/uploads/{$image.name}" data-fancybox="preview" class="d-block">
                          <img src="/uploads/{$image.name}"
                               alt="{$image.title|default:$realestate.title}"
                               class="d-block w-100"
                               style="max-height:800px;object-fit:cover;">
                        </a>
                      </div>
                    {/foreach}
                  </div>
                  <button class="carousel-control-prev" type="button"
                          data-bs-target="#investmentGallery" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Poprzednie</span>
                  </button>
                  <button class="carousel-control-next" type="button"
                          data-bs-target="#investmentGallery" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Następne</span>
                  </button>
                </div>

                {* #4: Thumbnail strip — 3 per view, drag/swipe to scroll *}
                <div id="galleryThumbs" class="thumb-drag-viewport mt-2">
                  <div id="thumbsTrack" class="d-flex">
                    {foreach from=$images item=$image name=thumb_gallery}
                      <button class="btn p-0 border-0 rounded overflow-hidden thumb-btn {if $smarty.foreach.thumb_gallery.first}thumb-active{/if}"
                              type="button"
                              data-bs-target="#investmentGallery"
                              data-bs-slide-to="{$smarty.foreach.thumb_gallery.index}"
                              aria-label="Zdjęcie {$smarty.foreach.thumb_gallery.iteration}">
                        <img src="/uploads/thumb/{$image.name}"
                             alt="{$image.title|default:$realestate.title}"
                             style="width:100%;object-fit:cover;">
                      </button>
                    {/foreach}

                  </div>
                </div>
				</div></div></div>
          {/if}
		  
		  
    <div class="container">
      <div class="row">
        <div class="col-12">
          {* #5: Parter section *}
		  
          {if $floor.has_parter}

                <div class="row g-4 align-items-start mb-5 reverse-mobile">
                  {if $parter_img_name}
                    <div class="col-md-6 floor-img">
                      <img src="/uploads/{$parter_img_name}"
                           alt="Parter - {$realestate.title}"
                           class="img-fluid rounded">
                    </div>
                    <div class="col-md-6 floor-content">
					<h2 class="h4 mb-3 text-center" style="font-size:var( --font-size-body)">Parter</h2>
					  {$floor.parter_content}
                    </div>
                  {else}
                    <div class="col-12  floor-content">
						<h2 class="h4 mb-3 text-center" style="font-size:var( --font-size-body)">Parter</h2>
                      {$floor.parter_content}
                    </div>
                  {/if}                
                </div>

          {/if}

          {* #5: Piętro section *}
          {if $floor.has_pietro}

                <div class="row g-4 align-items-start reverse-mobile">
                  {if $pietro_img_name}
                    <div class="col-md-6 floor-img">
                      <img src="/uploads/{$pietro_img_name}"
                           alt="Piętro - {$realestate.title}"
                           class="img-fluid rounded">
                    </div>
                    <div class="col-md-6 floor-content">
						<h2 class="h4 mb-3 text-center" style="font-size:var( --font-size-body)">Piętro</h2>
                      {$floor.pietro_content}
                    </div>
                  {else}
                    <div class="col-12 floor-content">
						<h2 class="h4 mb-3 text-center" style="font-size:var( --font-size-body)">Piętro</h2>
                      {$floor.pietro_content}
                    </div>
                  {/if}
                </div>
				{if !$floor.has_poddasze}<hr style="margin:100px 0;">{/if}
          {/if}

          {* #5: Poddasze section *}
          {if $floor.has_poddasze}

                <div class="row g-4 align-items-start reverse-mobile">
                  {if $poddasze_img_name}
                    <div class="col-md-6 floor-img">
                      <img src="/uploads/{$poddasze_img_name}"
                           alt="Poddasze - {$realestate.title}"
                           class="img-fluid rounded">
                    </div>
                    <div class="col-md-6 floor-content">
                      <h2 class="h4 mb-3 text-center" style="font-size:var(--font-size-body)">Poddasze</h2>
                      {$floor.poddasze_content}
                    </div>
                  {else}
                    <div class="col-12 floor-content">
                      <h2 class="h4 mb-3 text-center" style="font-size:var(--font-size-body)">Poddasze</h2>
                      {$floor.poddasze_content}
                    </div>
                  {/if}
                </div>
                <hr style="margin:100px 0;">
          {/if}

          {* #6: Property description *}
          {if $realestate.content}
				<div>
					{$realestate.content}
					<hr style="margin:100px 0;">
				</div>
          {/if}

          {* Infrastructure — unchanged *}
          {if $infrastructure|@count > 0}

                <h2 class="h4 mb-3">Infrastruktura w okolicy</h2>
                <div class="row g-3">
                  {foreach from=$infrastructure item=infra}
                    <div class="col-6 col-md-4 col-xl-3">
                      <div class="border rounded p-3 h-100 text-center">
                        <div class="mb-2">
                          {if $infra.icon != ''}
                            <img src="/uploads/{$infra.icon}" alt="{$infra.name}" style="width:28px;height:28px;object-fit:contain;">
                          {else}
                            <span style="font-size:1.5rem;">📍</span>
                          {/if}
                        </div>
                        <div class="fw-semibold">{$infra.name}</div>
                        <small class="text-muted">{$infra.distance}</small>
                      </div>
                    </div>
                  {/foreach}
                </div>

          {/if}

          {* Rzuty budynku — unchanged *}
          {if $floorplans|@count > 0}

                <h2 class="h4 mb-3">Rzuty budynku</h2>
                <ul class="nav nav-tabs mb-3" role="tablist">
                  {foreach from=$floorplans item=plan name=floor_nav}
                    <li class="nav-item" role="presentation">
                      <button class="nav-link {if $smarty.foreach.floor_nav.first}active{/if}"
                              data-bs-toggle="tab"
                              data-bs-target="#floor-{$plan.key}"
                              type="button" role="tab">{$plan.name}</button>
                    </li>
                  {/foreach}
                </ul>
                <div class="tab-content">
                  {foreach from=$floorplans item=plan name=floor_content}
                    <div class="tab-pane fade {if $smarty.foreach.floor_content.first}show active{/if}"
                         id="floor-{$plan.key}" role="tabpanel">
                      <div class="d-flex justify-content-between align-items-center mb-2">
                        <h3 class="h6 mb-0">{$plan.name}</h3>
                        <span class="badge text-bg-light">Suma: {$plan.total_area_label}</span>
                      </div>
                      <div class="table-responsive">
                        <table class="table table-sm align-middle">
                          <thead>
                            <tr>
                              <th>Pomieszczenie</th>
                              <th class="text-end">Metraż</th>
                            </tr>
                          </thead>
                          <tbody>
                            {foreach from=$plan.rooms item=room}
                              <tr>
                                <td>{$room.name}</td>
                                <td class="text-end">{$room.area}</td>
                              </tr>
                            {/foreach}
                          </tbody>
                        </table>
                      </div>
                    </div>
                  {/foreach}
                </div>

          {/if}

          {* #7: Pliki do pobrania *}
          {if $downloads|@count > 0}

				<header class="section-header">
					<div class="section-header__ribbon">
						<h2 class="section-header__title mb-0">Pliki do pobrania</h2>
					</div>
				</header>				
                <div class="list-files" style="margin-bottom:100px">
                  {foreach from=$downloads item=file}
                    <a href="{$file.path}" target="_blank" rel="noopener">
                      <span>{$file.title}</span>
						  {*<span class="badge text-bg-primary text-uppercase">
                        {if $file.type != ''}{$file.type}{else}plik{/if}
						  </span>*}
                    </a>
                  {/foreach}
                </div>

          {/if}

          {* #8: Contact form (always shown) *}

		<section class="py-5" data-aos="fade-up" id="contact-form">
		<header class="section-header">
			<div class="section-header__ribbon">
				<h2 class="section-header__title mb-0">Umów spotkanie. Zostaw swój numer!</h2>
			</div>
		</header>
		  {include file='partials/contact_form.tpl'}
		 </section>
		  


        </div>{* /col-12 *}
      </div>{* /row *}
    </div>{* /container *}
  </section>
</main>
<link rel="stylesheet" href="/utils/css/fancybox.min.css">
<script src="/utils/js/fancybox.min.js"></script>
{literal}
<script>
function initInvestmentGallery() {
  var carousel = document.getElementById('investmentGallery');
  if (!carousel) return;

  if (typeof bootstrap === 'undefined' || !bootstrap.Carousel) {
    window.setTimeout(initInvestmentGallery, 50);
    return;
  }

  var viewport  = document.getElementById('galleryThumbs');
  var track     = document.getElementById('thumbsTrack');
  var thumbBtns = track ? Array.from(track.querySelectorAll('.thumb-btn')) : [];
  var VISIBLE   = 3;

  var bsCarousel = bootstrap.Carousel.getOrCreateInstance(carousel);

  var dragging = false;
  var startX = 0;
  var scrollStart = 0;
  var didDrag = false;

  function findActiveSlideIndex() {
    var items = carousel.querySelectorAll('.carousel-item');
    for (var i = 0; i < items.length; i++) {
      if (items[i].classList.contains('active')) return i;
    }
    return 0;
  }

  function setActiveThumb(index) {
    thumbBtns.forEach(function (btn, i) {
      btn.classList.toggle('thumb-active', i === index);
    });

    if (!viewport || !thumbBtns[index]) return;

    var thumbEl    = thumbBtns[index];
    var thumbLeft  = thumbEl.offsetLeft;
    var thumbRight = thumbLeft + thumbEl.offsetWidth;
    var viewLeft   = viewport.scrollLeft;
    var viewRight  = viewLeft + viewport.clientWidth;

    if (thumbLeft < viewLeft) {
      viewport.scrollTo({ left: thumbLeft, behavior: 'smooth' });
    } else if (thumbRight > viewRight) {
      viewport.scrollTo({ left: thumbRight - viewport.clientWidth, behavior: 'smooth' });
    }
  }

  thumbBtns.forEach(function (btn, index) {
    btn.addEventListener('click', function (e) {
      if (didDrag) {
        e.preventDefault();
        e.stopPropagation();
        didDrag = false;
        return;
      }

      e.preventDefault();
      bsCarousel.to(index);
      setActiveThumb(index);
    });
  });

  if (viewport) {
    viewport.addEventListener('pointerdown', function (e) {
      dragging = true;
      didDrag = false;
      startX = e.clientX;
      scrollStart = viewport.scrollLeft;
      viewport.classList.add('is-dragging');
    });

    viewport.addEventListener('pointermove', function (e) {
      if (!dragging) return;

      var dx = e.clientX - startX;
      if (Math.abs(dx) > 5) didDrag = true;
      viewport.scrollLeft = scrollStart - dx;
    });

    function stopDragging() {
      dragging = false;
      viewport.classList.remove('is-dragging');
    }

    viewport.addEventListener('pointerup', stopDragging);
    viewport.addEventListener('pointercancel', stopDragging);
    viewport.addEventListener('pointerleave', stopDragging);
  }

  carousel.addEventListener('slid.bs.carousel', function (e) {
    var idx = (typeof e.to === 'number') ? e.to : findActiveSlideIndex();
    setActiveThumb(idx);
  });

  if (window.jQuery && jQuery.fn.fancybox) {
    $('[data-fancybox="preview"]').fancybox({
      thumbs: { autoStart: true }
    });
  }

  setActiveThumb(findActiveSlideIndex());
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initInvestmentGallery);
} else {
  initInvestmentGallery();
}
</script>
{/literal}

<style>
#investmentGallery {
	margin-top:0 !important;
}
#galleryThumbs {
	margin-top:-12px !important;
	margin-bottom:100px;
}



#galleryThumbs img {
	height:200px;
}

#galleruThumbs button, .thumb-btn {
	border-radius: 0 !important;
}

.thumb-drag-viewport {
  overflow-x: scroll;
  overflow-y: hidden;
  cursor: grab;
  user-select: none;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.thumb-drag-viewport::-webkit-scrollbar { display: none; }
.thumb-drag-viewport.is-dragging { cursor: grabbing; }
 
.thumb-btn { flex: 0 0 calc(100% / 3); width: calc(100% / 3); transition: opacity .15s, outline .15s; opacity: .5; }
.thumb-btn.thumb-active,
.thumb-btn:hover { opacity: 1; outline: 2px solid #0d6efd; outline-offset: 2px; border-radius: 6px; }

.thumb-btn.thumb-active, .thumb-btn:hover {
	border:0 !important;
	outline:0 !important;
}

@media (max-width:991px) {
	#galleryThumbs {
		margin-bottom:0 !important;
	}
	
	#galleryThumbs img {
		height:100px;
	}

}
</style>
