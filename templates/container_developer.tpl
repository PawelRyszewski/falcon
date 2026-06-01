<main>
  <section class="py-5 bg-light border-bottom">
    <div class="container">
      <h1 class="display-5 mb-0">{$page.title}</h1>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row g-4 align-items-start">
        <div class="col-lg-7">
          <div class="p-4 border rounded-4 h-100">
            {$page.content}
          </div>
        </div>
        <div class="col-lg-5">
          <div class="p-4 border rounded-4 bg-light h-100">
            <h2 class="h4 mb-3">Formularz kontaktowy</h2>
            <p class="text-muted">Masz pytania o inwestycję? Zostaw kontakt, a wrócimy z odpowiedzią.</p>
            {include file='partials/contact_form.tpl'}
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="py-4 border-top">
    <div class="container">
      <p class="mb-0 text-muted">EKO-DOM — deweloper domów jednorodzinnych i osiedli mieszkaniowych.</p>
    </div>
  </section>
</main>
