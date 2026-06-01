<main>
  <section class="hero position-relative overflow-hidden text-center" data-aos="fade-top">
    <div class="container py-5">
      <h1 class="display-4">Najlepszy program do KSeF – ranking i porównanie 2026</h1>
      <p class="lead">Program-do-ksef.pl pomaga wybrać narzędzie do Krajowego Systemu e-Faktur: porównujemy funkcje, ceny, integracje i wygodę obsługi.</p>
      <div class="d-flex justify-content-center flex-wrap gap-2 mt-4">
        <span class="badge rounded-pill text-bg-light px-3 py-2">⚡ Integracje KSeF</span>
        <span class="badge rounded-pill text-bg-light px-3 py-2">🔒 Bezpieczeństwo danych</span>
        <span class="badge rounded-pill text-bg-light px-3 py-2">📊 Rzetelny ranking 2026</span>
      </div>
      <a href="#ranking-ksef" class="btn btn-primary btn-lg mt-3 px-5 py-3 fs-3">Zobacz ranking programów</a>
      <div class="hero-stats">
        <div class="hero-stats-item"><span class="stat-val">30+</span><span class="stat-lbl">Programów w bazie</span></div>
        <div class="hero-stats-item"><span class="stat-val">2026</span><span class="stat-lbl">Aktualny ranking</span></div>
        <div class="hero-stats-item"><span class="stat-val">100%</span><span class="stat-lbl">Niezależna ocena</span></div>
      </div>
    </div>
  </section>

  <section id="ranking-ksef" class="py-5 top-models" data-aos="fade-up">
    <div class="container">
      <h2 class="mb-4 title">TOP 3 programy do KSeF</h2>
      <div class="row g-4">
        <div class="col-md-4">
          <div class="card h-100 text-center shadow-sm border-0 p-3">
            <p class="mb-1 text-muted">#1</p>
            <h3 class="h4">afaktury.pl</h3>
            <p>Rozbudowany program do faktur z obsługą KSeF, automatyzacją wysyłki dokumentów i wygodnym panelem dla biur rachunkowych.</p>
            <a class="btn btn-outline-primary mt-auto" href="https://afaktury.pl" target="_blank" rel="nofollow noopener">Przejdź do afaktury.pl</a>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card h-100 text-center shadow-sm border-0 p-3">
            <p class="mb-1 text-muted">#2</p>
            <h3 class="h4">faktury.pl</h3>
            <p>Popularne rozwiązanie dla firm, które potrzebują szybkiego wystawiania faktur, integracji księgowych i zgodności z KSeF.</p>
            <a class="btn btn-outline-primary mt-auto" href="https://faktury.pl" target="_blank" rel="nofollow noopener">Przejdź do faktury.pl</a>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card h-100 text-center shadow-sm border-0 p-3">
            <p class="mb-1 text-muted">#3</p>
            <h3 class="h4">faktura-online.pl</h3>
            <p>Lekki system online do fakturowania i KSeF, dobry dla mikrofirm oraz osób szukających prostego startu bez wdrożenia IT.</p>
            <a class="btn btn-outline-primary mt-auto" href="https://faktura-online.pl" target="_blank" rel="nofollow noopener">Przejdź do faktura-online.pl</a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="pt-5 categories" data-aos="fade-up">
    <div class="container">
      <h2 class="mb-4 title">Jak wybrać program do KSeF?</h2>
      <div class="row g-4">
        <div class="col-md-6">
          <div class="p-4 border rounded-4 h-100">
            <h3 class="h5">Najważniejsze kryteria</h3>
            <ul>
              <li>stabilna integracja z API KSeF i kolejką wysyłki,</li>
              <li>podgląd statusów faktur (przyjęta/odrzucona),</li>
              <li>obsługa uprawnień użytkowników i oddziałów,</li>
              <li>automatyzacje: cykliczne faktury, przypomnienia, raporty.</li>
            </ul>
          </div>
        </div>
        <div class="col-md-6">
          <div class="p-4 border rounded-4 h-100">
            <h3 class="h5">Dla kogo jest ranking?</h3>
            <p>Dla przedsiębiorców, biur rachunkowych i działów finansowych, które chcą szybko porównać najlepsze programy do KSeF i wybrać narzędzie dopasowane do skali firmy.</p>
            <p class="mb-0"><strong>Program-do-ksef.pl</strong> jest serwisem informacyjnym i porównawczym.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="news pb-4" data-aos="fade-up">
    <div class="container">
      <h2 class="mb-4 title">Aktualności o KSeF</h2>
      <div class="row row-cols-1 row-cols-md-3 g-4">
        {foreach from=$latest_news item=item}
        <div class="col">
          <div class="card h-100 shadow-sm border-0">
            <div class="card-body">
              <p class="text-muted mb-1 date-public">{$item.created_at|date_format:"%d.%m.%Y"}</p>
              <p>{$item.title|truncate:80}</p>
            </div>
            <a href="/blog/{$item.category}/{$item.url}" class="stretched-link"></a>
          </div>
        </div>
        {/foreach}
      </div>
    </div>
  </section>

  <section class="py-5" data-aos="fade-up">
    <div class="container newsletter-block px-4 pb-3-mob" style="padding: 2rem 2.5rem;">
      <div class="row">
        <div class="col-lg-5"><p class="py-4 mb-0 fs-3" style="font-weight: 600; color:#062961;">Newsletter: zmiany w KSeF i porównania programów</p></div>
        <div class="col-lg-7">
          <form id="newsletter-form" class="row d-flex align-items-center flex-wrap h-100" method="POST">
            <div class="col-md-4 mb-mob">
              <input type="text" name="name" class="form-control fs-5" placeholder="Imię">
            </div>
            <div class="col-md-4 mb-mob">
              <input type="email" name="email" class="form-control fs-5" placeholder="E-mail">
            </div>
            <div class="col-md-4 mb-mob">
              <button type="submit" class="btn btn-primary w-100 fs-5">Zapisz się</button>
            </div>
          </form>
          <div id="newsletter-alert" class="alert d-none mt-3" role="alert"></div>
        </div>
      </div>
    </div>
  </section>
</main>
