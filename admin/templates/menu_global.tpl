<header class="container-fluid px-0">
  <div class="container">
    <nav class="navbar navbar-expand-lg navbar-light">
      <a class="navbar-brand" href="/"><span>AI</span> TOOLS HUB</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarMenu">
        <ul class="navbar-nav mb-2 mb-lg-0">
		{*<li class="nav-item"><a class="nav-link" href="{page_url slug='blog'}">{t key='blog'}</a></li>*}
          {foreach from=$menuPages item=item}
            <li class="nav-item">
              <a class="nav-link" href="/{$item.url}" title="{$item.title}">
                {$item.title}
              </a>
            </li>
          {/foreach}
          <li class="nav-item dropdown lang">
            <a class="nav-link dropdown-toggle" href="#" id="langDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">{$currentLang|upper}</a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="langDropdown">
               {foreach from=$languages item=lang}
                {if $lang.name != $currentLang}
                  <li><a class="dropdown-item" href="/{$lang.name}">{$lang.name|upper}</a></li>
                {/if}
              {/foreach}
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </div>
</header>
