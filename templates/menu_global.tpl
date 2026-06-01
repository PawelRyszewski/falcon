<header class="container-fluid px-0 ekd-header{if $page.id==0} ekd-header--home{/if}">
  <div class="container ekd-header__container">
    <nav class="navbar navbar-expand-lg navbar-light ekd-nav{if $page.id==0} ekd-nav--home{/if}" aria-label="Menu główne">
      <a class="navbar-brand ekd-nav__brand" href="/" aria-label="EKO-DOM - strona główna">
        <img class="ekd-nav__logo" src="/utils/images/logo.png" alt="EKO-DOM" width="164" height="32">
      </a>

      <button class="navbar-toggler ekd-nav__toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu" aria-controls="navbarMenu" aria-expanded="false" aria-label="Pokaż/ukryj menu">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse ekd-nav__collapse" id="navbarMenu">
        <ul class="navbar-nav ekd-nav__menu{if $page.id==0} ekd-nav__menu--home{/if} mb-2 mb-lg-0 ms-auto align-items-lg-center">
			{if $page.id != 0}
          <li class="nav-item ekd-nav__item">
            <a class="nav-link ekd-nav__link" href="/">Start</a>
          </li>
			{/if}
			
         <li class="nav-item ekd-nav__item ekd-nav__item--has-submenu">
            <a class="nav-link ekd-nav__link ekd-nav__link--parent" href="/inwestycje">Inwestycje</a>
            <ul class="submenu ekd-nav__submenu">
              {if $investments_in_progress}
              <li class="submenu__item submenu__item--group">
                <span class="submenu__group-label">W realizacji</span>
                <ul class="submenu ekd-nav__submenu--nested">
                  {foreach $investments_in_progress as $investment}
                  <li class="submenu__item">
                    <a class="submenu__link" href="{$investment.url}">{$investment.title}</a>
                  </li>
                  {/foreach}
                </ul>
              </li>
              {/if}
              {if $investments_completed}
              <li class="submenu__item submenu__item--group">
                <span class="submenu__group-label">Zrealizowane</span>
                <ul class="submenu ekd-nav__submenu--nested">
                  {foreach $investments_completed as $investment}
                  <li class="submenu__item">
                    <a class="submenu__link" href="{$investment.url}">{$investment.title}</a>
                  </li>
                  {/foreach}
                </ul>
              </li>
              {/if}
            </ul>
          </li>

          <li class="nav-item ekd-nav__item">
            <a class="nav-link ekd-nav__link" href="/developer">Developer</a>
          </li>

          <li class="nav-item ekd-nav__item">
            <a class="nav-link ekd-nav__link" href="/kontakt">Kontakt</a>
          </li>

          <li class="nav-item ekd-nav__item ekd-nav__item--cta{if $page.id==0} ekd-nav__item--cta-home{/if} mt-2 mt-lg-0">
            <a class="btn btn-primary ekd-nav__cta{if $page.id==0} ekd-nav__cta--home{/if}" href="#contact-form">Umów spotkanie</a>
          </li>
        </ul>
      </div>
    </nav>
  </div>
</header>


<script>
(function () {
  function isMobile() { return window.innerWidth < 992; }
 
  // Mobile: tap "Inwestycje" to toggle L1 submenu
  var parentLink = document.querySelector('.ekd-nav__link--parent');
  if (parentLink) {
    parentLink.addEventListener('click', function (e) {
      if (!isMobile()) return;
      e.preventDefault();
      var li = this.closest('.ekd-nav__item--has-submenu');
      if (li) li.classList.toggle('is-open');
    });
  }
 
  // Mobile: tap group label to toggle L2 submenu
  document.querySelectorAll('.submenu__group-label').forEach(function (label) {
    label.addEventListener('click', function () {
      if (!isMobile()) return;
      var li = this.closest('.submenu__item--group');
      if (li) li.classList.toggle('is-open');
    });
  });
 
  // Close submenus when navbar collapses
  var navbarToggler = document.querySelector('.ekd-nav__toggler');
  if (navbarToggler) {
    navbarToggler.addEventListener('click', function () {
      document.querySelectorAll('.ekd-nav__item--has-submenu').forEach(function (el) {
        el.classList.remove('is-open');
      });
      document.querySelectorAll('.submenu__item--group').forEach(function (el) {
        el.classList.remove('is-open');
      });
    });
  }
 
  // Close navbar when tapping outside on mobile
  document.addEventListener('click', function (e) {
    if (!isMobile()) return;
    var nav = document.querySelector('.ekd-nav');
    if (!nav || nav.contains(e.target)) return;
    var collapseEl = document.getElementById('navbarMenu');
    if (collapseEl && collapseEl.classList.contains('show')) {
      var bsCollapse = bootstrap.Collapse.getInstance(collapseEl);
      if (bsCollapse) bsCollapse.hide();
    }
  });
  
}());
</script>