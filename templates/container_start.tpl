<main class="home-start">

  {if $homepage_slides}
  <section class="homepage-hero-slider">
    <div id="homepageHeroSlider" class="carousel slide" data-bs-ride="carousel" data-bs-interval="5000">
      <div class="carousel-inner">
        {foreach from=$homepage_slides item=slide name=hslider}
        <div class="carousel-item {if $smarty.foreach.hslider.first}active{/if}"
             style="background-image: url('{$slide.image_url}');">
          <div class="slide-content-wrap">
            <div class="hero-banner__content">
              {if $slide.text_p1}<p class="p1">{$slide.text_p1|escape}</p>{/if}
              {if $slide.text_p2}<p class="p2">{$slide.text_p2|escape}</p>{/if}
              {if $slide.text_p3}<p class="p3"><a href="/inwestycje/{$slide.category_url}">{$slide.text_p3|escape}</a></p>{/if}
            </div>
          </div>
        </div>
        {/foreach}
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#homepageHeroSlider" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Poprzednie</span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#homepageHeroSlider" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Następne</span>
      </button>
    </div>
  </section>
  {/if}

  <section class="hero-banner" data-aos="fade-top">
    {if $hero_bg_image_url}
      <div class="hero-banner__wrap" style="background-image: url('{$hero_bg_image_url}');">
        <div class="container">
          <div class="hero-banner__content">
            {$hero_overlay_content nofilter}
          </div>
        </div>
      </div>
    {/if}
  </section>

  {if $homepage_content}
  <section class="homepage-intro py-5" data-aos="fade-up">
    <div class="container">
      <div class="homepage-intro__body">
        {$homepage_content nofilter}
      </div>
    </div>
  </section>
  {/if}

  {if $investments_in_progress}
  <section id="inwestycje-realizacji" class="investment-section py-5" data-aos="fade-up">
    <div class="container">
      <header class="section-header">
        <div class="section-header__ribbon">
          <h2 class="section-header__title mb-0">Inwestycje w trakcie realizacji</h2>
        </div>
      </header>

      {foreach from=$investments_in_progress item=category name=inProgress}
        <article class="investment-row {if ($first_side_in_progress == 'left' && $smarty.foreach.inProgress.iteration % 2 == 0) || ($first_side_in_progress == 'right' && $smarty.foreach.inProgress.iteration % 2 != 0)}investment-row--reverse{/if}">
          <div class="investment-row__media">
            <img src="{$category.image_url}" class="img-fluid investment-row__image" alt="{$category.title|escape}">
          </div>
          <div class="investment-row__body">
            <div class="investment-row__content">
              <h3>{$category.title}</h3>
              {if $category.subtitle}<p>{$category.subtitle}</p>{/if}
              <a class="btn btn-primary investment-row__cta" href="/inwestycje/{$category.url}">Dowiedz się więcej</a>
            </div>
          </div>
        </article>
      {/foreach}
    </div>
  </section>
  {/if}

  {if $investments_completed}
  <section class="investment-section investment-section--light py-5" data-aos="fade-up">
    <div class="container">
      <header class="section-header">
        <div class="section-header__ribbon">
          <h2 class="section-header__title mb-0">Inwestycje zrealizowane</h2>
        </div>
      </header>

      {foreach from=$investments_completed item=category name=completed}
        <article class="investment-row {if ($first_side_completed == 'left' && $smarty.foreach.completed.iteration % 2 == 0) || ($first_side_completed == 'right' && $smarty.foreach.completed.iteration % 2 != 0)}investment-row--reverse{/if}">
          <div class="investment-row__media">
            <img src="{$category.image_url}" class="img-fluid investment-row__image" alt="{$category.title|escape}">
          </div>
          <div class="investment-row__body">
            <div class="investment-row__content">
              <h3>{$category.title}</h3>
              {if $category.subtitle}<p>{$category.subtitle}</p>{/if}
              <a class="btn btn-primary investment-row__cta" href="/inwestycje/{$category.url}">Dowiedz się więcej</a>
            </div>
          </div>
        </article>
      {/foreach}
    </div>
  </section>
  {/if}

  <section class="py-5" data-aos="fade-up" id="contact-form">
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
