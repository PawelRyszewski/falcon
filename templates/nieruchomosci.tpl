<main>
	<section class="container" data-aos="fade-up">
	<header class="section-header" style="margin-top:20px !important">
		<div class="section-header__ribbon">
			{if $active_category_filter > 0}
			<h1 class="section-header__title mb-0">{$active_category_name}</h1>
			 {else}
			 <h1 class="section-header__title mb-0">Inwestycje EKO-DOM</h1>
			 {/if}
		</div>	
	</header>
	</section>

  {if $active_category_filter > 0 && $category_svg_map}
  {* ── SVG Property Map ── *}
  <section class="svgmap-section">
    <style>
    .svgmap-section { width: 100%; }
    .svgmap-viewport {
        width: 100%;
        position: relative;
        line-height: 0; /* collapse whitespace gap below inline img */
    }
    .svgmap-bg {
        display: block;
        width: 100%;
        height: auto; /* image drives container height — fully responsive */
    }
    .svgmap-overlay {
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        width: 100%; height: 100%;
        overflow: visible;
    }
    .svgmap-overlay polygon {
        cursor: pointer;
        transition: fill-opacity 0.2s;
    }
    .svgmap-overlay polygon:hover { fill-opacity: 0.55 !important; }
    .svgmap-cloud {
        position: absolute;
        z-index: 10;
        display: none;
        min-width: 160px;
        max-width: 220px;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        pointer-events: none;
    }
    .svgmap-cloud-status {
        padding: 6px 12px;
        font-size: 0.78rem;
        font-weight: 700;
        letter-spacing: .04em;
        color: #fff;
        text-transform: uppercase;
    }
    .svgmap-cloud-img { width: 100%; height: 110px; object-fit: cover; display: block; }
    .svgmap-cloud-name {
        padding: 6px 12px 8px;
        font-size: 0.82rem;
        font-weight: 600;
        color: #fff;
        line-height: 1.3;
    }
    </style>

    <div class="svgmap-viewport" id="svgmap-wrap">
      <img class="svgmap-bg"
           src="/uploads/{$category_svg_map.image_name}"
           alt="{$active_category_name}">
      <svg class="svgmap-overlay" id="svgmap-overlay"
           viewBox="0 0 {$category_svg_map.image_width} {$category_svg_map.image_height}"
           preserveAspectRatio="xMidYMid meet">
          {foreach from=$category_svg_map.shapes item=shape}
          {assign var=shapeColor value='#ffffff'}
          {if $shape.property_status == 'rezerwacja'}
            {assign var=shapeColor value='#e65100'}
          {elseif $shape.property_status == 'niedostepne'}
            {assign var=shapeColor value='#c62828'}
          {elseif $shape.property_status == 'wolne'}
            {assign var=shapeColor value='#2e7d32'}
          {/if}
          {assign var=tooltipSide value=$shape.tooltip_side|default:'right'}
          {assign var=propertyUrl value=$shape.property_url|default:''}
          <polygon
            class="svgmap-poly"
            points="{foreach from=$shape.points item=pt name=ptloop}{$pt.x},{$pt.y}{if !$smarty.foreach.ptloop.last} {/if}{/foreach}"
            fill="{$shapeColor}"
            fill-opacity="0.3"
            stroke="{$shapeColor}"
            stroke-width="2"
            stroke-opacity="0.7"
            data-href="{if $propertyUrl}/inwestycje/{$propertyUrl}{/if}"
            data-title="{$shape.property_title|escape}"
            data-status="{$shape.property_status|default:'wolne'}"
            data-img="{$shape.property_img_name|default:''}"
            data-tooltip-side="{$tooltipSide}"
          />
          {/foreach}
      </svg>
      <div class="svgmap-cloud" id="svgmap-cloud"></div>
    </div>
  </section>
  <script>
  (function() {
    var overlay = document.getElementById('svgmap-overlay');
    var cloud   = document.getElementById('svgmap-cloud');
    var wrap    = document.getElementById('svgmap-wrap');
    if (!overlay || !wrap) return;

    var STATUS_BG = { wolne: '#2e7d32', rezerwacja: '#e65100', niedostepne: '#c62828' };

    function getPolyPos(poly) {
        var bb   = poly.getBoundingClientRect();
        var wbb  = wrap.getBoundingClientRect();
        return {
            top:   bb.top    - wbb.top,
            left:  bb.left   - wbb.left,
            right: bb.right  - wbb.left,
            mid:   (bb.top + bb.bottom) / 2 - wbb.top
        };
    }

    function showCloud(poly) {
        var title       = poly.getAttribute('data-title')        || '';
        var status      = poly.getAttribute('data-status')       || 'wolne';
        var img         = poly.getAttribute('data-img')          || '';
        var side        = poly.getAttribute('data-tooltip-side') || 'right';
        var color       = STATUS_BG[status] || '#2e7d32';
        var statusLabel = { wolne: 'Wolne', rezerwacja: 'Rezerwacja', niedostepne: 'Niedostępne' }[status] || status;

        cloud.innerHTML =
            '<div class="svgmap-cloud-status" style="background:' + color + ';">' + statusLabel + '</div>' +
            (img ? '<img class="svgmap-cloud-img" src="/uploads/thumb/' + img + '" alt="">' : '') +
            '<div class="svgmap-cloud-name" style="background:' + color + ';">' + title + '</div>';

        cloud.style.display = 'block';
        var pos = getPolyPos(poly);
        cloud.style.top = pos.mid + 'px';
        cloud.style.transform = 'translateY(-50%)';
        if (side === 'left') {
            cloud.style.right = (wrap.offsetWidth - pos.left + 8) + 'px';
            cloud.style.left  = '';
        } else {
            cloud.style.left  = (pos.right + 8) + 'px';
            cloud.style.right = '';
        }
    }

    function hideCloud() { cloud.style.display = 'none'; }

    overlay.querySelectorAll('.svgmap-poly').forEach(function(poly) {
        poly.addEventListener('mouseenter', function() { showCloud(poly); });
        poly.addEventListener('mouseleave', hideCloud);
        poly.addEventListener('click', function() {
            var href = poly.getAttribute('data-href');
            if (href) window.location.href = href;
        });
    });
  })();
  </script>
  {/if}{* /category_svg_map *}

  {if $active_category_filter > 0}
    {if $category_img_name}
    <section>
      <div class="container" style="padding:0 !important;">
        <div class="rounded-4 overflow-hidden shadow-sm">
          <img src="/uploads/{$category_img_name}" alt="{$active_category_name}" class="w-100" style="object-fit:cover;">
        </div>
      </div>
    </section>
    {/if}
	
    {if $category_icons}
    <section class="py-4 icons-cat">
      <div class="container">
        <div class="d-flex flex-wrap gap-4 justify-content-center">
          {foreach from=$category_icons item=icon}
          <div class="text-center cont">
            <img src="/uploads/{$icon.img_name}" alt="{$icon.description|escape}">
            {if $icon.description}<p class="small text-muted mt-2 mb-0">{$icon.description}</p>{/if}
          </div>
          {/foreach}
        </div>
      </div>
    </section>
    {/if}
	
    {if $category_description}
    <section class="py-4 mt-5">
      <div class="container">
        <div class="category-description">{$category_description}</div>
      </div>
    </section>
    {/if}
	

  {else}

    {* #1: Category grid — W realizacji *}
    {if $categories_in_progress}
    <section class="py-5 hover-blocks">
      <div class="container">
		<header class="section-header" style="margin-top:20px !important">
			<div class="section-header__ribbon">
				<h2 class="section-header__title mb-0">W realizacji</h2>
			</div>
		</header>	 
		
        <div class="row g-4">
          {foreach from=$categories_in_progress item=cat}
          <div class="col-sm-6 col-lg-4">
            <a href="/inwestycje/{$cat.slug}" class="text-decoration-none text-dark d-block h-100">
              <div class="card border-0 shadow-sm h-100 overflow-hidden">
                {if $cat.img_name}
                  <img src="/uploads/thumb/{$cat.img_name}" alt="{$cat.name}" class="card-img-top" style="height:220px;object-fit:cover;">
                {else}
                  <div class="bg-secondary" style="height:220px;"></div>
                {/if}
                <div class="card-body">
                  <h3 class="h5 mb-0">{$cat.name}</h3>
                </div>
              </div>
            </a>
          </div>
          {/foreach}
        </div>
      </div>
    </section>
    {/if}

    {* #1: Category grid — Zrealizowane *}
    {if $categories_completed}
    <section class="hover-blocks">
      <div class="container">
	  
		<header class="section-header" style="margin-top:20px !important">
			<div class="section-header__ribbon">
				<h2 class="section-header__title mb-0">Zrealizowane</h2>
			</div>
		</header>		  		
		
        <div class="row g-4">
          {foreach from=$categories_completed item=cat}
          <div class="col-sm-6 col-lg-4">
            <a href="/inwestycje/{$cat.slug}" class="text-decoration-none text-dark d-block h-100">
              <div class="card border-0 shadow-sm h-100 overflow-hidden">
                {if $cat.img_name}
                  <img src="/uploads/thumb/{$cat.img_name}" alt="{$cat.name}" class="card-img-top" style="height:220px;object-fit:cover;">
                {else}
                  <div class="bg-secondary" style="height:220px;"></div>
                {/if}
                <div class="card-body">
                  <span class="badge text-bg-secondary mb-2">Zrealizowane</span>
                  <h3 class="h5 mb-0">{$cat.name}</h3>
                </div>
              </div>
            </a>
          </div>
          {/foreach}
        </div>
      </div>
    </section>
    {/if}

  {/if}

  {if $category_houses}
  <section class="py-5 border-top">
    <div class="container">
      <div style="background-color:#392f30;border-radius:4px 4px 0 0;padding:1rem 1.5rem;">
        <h2 class="h4 mb-0" style="color:#fff;font-weight:400;">Lista domów{if $active_category_name} &mdash; {$active_category_name}{/if}</h2>
      </div>
      <div class="table-responsive border border-top-0 rounded-bottom">
        <table class="table table-bordered mb-0 align-middle">
          <thead class="table-light">
            <tr>
              <th style="font-weight: 300;">Nazwa nieruchomości</th>
              <th></th>
              <th style="font-weight: 300;">Status nieruchomości</th>
              <th style="font-weight: 300;">Powierzchnia działki</th>
              <th style="font-weight: 300;">Powierzchnia użytkowa</th>
              <th><strong>Cena</strong></th>
            </tr>
          </thead>
          <tbody>
            {foreach from=$category_houses item=house}
            <tr>
              <td><strong><a href="/inwestycje/{$house.url}" class="text-decoration-none text-dark">{$house.title}</a></strong></td>
              <td style="width:80px;">
                {if $house.img_name}
                  <img src="/uploads/thumb/{$house.img_name}" alt="{$house.title}" style="width:64px;height:64px;object-fit:cover;border-radius:4px;">
                {/if}
              </td>
              <td>
                {if $house.house_status == 'rezerwacja'}
                  <span class="house-status-badge house-status-rezerwacja">REZERWACJA</span>
                {elseif $house.house_status == 'niedostepne'}
                  <span class="house-status-badge house-status-niedostepne">NIEDOSTĘPNE</span>
                {else}
                  <span class="house-status-badge house-status-wolne">WOLNE</span>
                {/if}
              </td>
              <td>{if $house.plot_area}{$house.plot_area}{else}&mdash;{/if}</td>
              <td>{if $house.usable_area}{$house.usable_area}{else}&mdash;{/if}</td>
              <td><strong>{if $house.house_price}{$house.house_price}{else}&mdash;{/if}</strong></td>
            </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
    </div>
  </section>
  {/if}

  {if $active_category_filter > 0 && $category_map_lat && $category_map_lng}
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
  <section class="py-5">
    <div class="container">
      <header class="section-header">
        <div class="section-header__ribbon">
          <h2 class="section-header__title mb-0">Lokalizacja osiedla &mdash; {$active_category_name}</h2>
        </div>
      </header>
    </div>
    <div class="map-estate">
      <div id="estate-map" style="height:400px;width:100%;"></div>
    </div>
  </section>
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
  {literal}
  <script>
  (function() {
    var lat = {/literal}{$category_map_lat}{literal};
    var lng = {/literal}{$category_map_lng}{literal};
    var zoom = {/literal}{$category_map_zoom|default:15}{literal};
    var map = L.map('estate-map').setView([lat, lng], zoom);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    L.marker([lat, lng]).addTo(map);
  })();
  </script>
  {/literal}
  {/if}

  	<section class="py-5" data-aos="fade-up">
    <div class="container">
        <header class="section-header">
			<div class="section-header__ribbon">
				<h2 class="section-header__title mb-0">Umów spotkanie. Zostaw swój numer!</h2>
			</div>
        </header>
          {include file='partials/contact_form.tpl'}
    </div>
  </section>
</main>

<style>
.house-status-badge {
  display: inline-block;
  padding: .35em .75em;
  border-radius: 50rem;
  font-size: .75rem;
  font-weight: 600;
  letter-spacing: .06em;
  border: 1px solid currentColor;
}
.house-status-wolne      { color: #2e7d32; background-color: #e8f5e9; }
.house-status-rezerwacja { color: #e65100; background-color: #fff3e0; }
.house-status-niedostepne{ color: #c62828; background-color: #fce4ec; }
</style>
