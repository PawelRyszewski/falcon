<div class="page-wrapper">

  <section class="section">
    {if isset($new_password_send)}
      <div id="login-content2">
        <p>Na Twój adres e-mail została wysłana wiadomość z dalszymi instrukcjami.</p>
        <p>Sprawdź skrzynkę email. Powinieneś otrzymać od nas wiadomość z linkiem, który umożliwi nadanie nowego hasła.
        </p>
        <p>Jeżeli otrzymałeś kilka wiadomości z linkiem do odświeżenia hasła, kliknij na link z najnowszej wiadomości.</p>
        <p>Po kliknięciu w link zostaniesz przekierowany na stronę, na której będziesz mógł nadać nowe hasło.</p>
        <p>Tam znajdują się również dalsze instrukcje dotyczące zmiany hasła.</p>
      </div>
    {else}
      <div id="login-content" {if (isset($auth_error) || isset($captcha_error))} style="height: 470px;" {/if}>
        <h2>Odzyskiwanie hasła</h2>

        <form method="post">
          <div class="form-group">
            <label>Login</label>
            <input type="text" class="form-control" name="login">
          </div>
          <button type="submit" name="new_password" class="btn btn-primary btn-block btn-dark">Odzyskaj hasło</button>
        </form>
      </div>
    {/if}
  </section>
</div>

</body>

<footer class="footer container-fluid">

  <div class="row">
    <div class="col-12 col-lg-4">
      <span class="copyright">ⓒ {$smarty.now|date_format:"%Y"} weo.pl <br />
        wszelkie prawa zastrzeżone</span>
    </div>
    <div class="col-12 col-lg-8 text-right">
      <p>Projekt i realizacja</p>
      <a href="https://weo.pl" class="ml-4 mt-1" title="Strony na abonament"><img src="/utils/images/weo-pl-logo.png"
          alt="logo twórców strony Weo.pl"></a>
    </div>
  </div>

</footer>
<style>
  body {
    background-color: #bcbcbc;
  }

  #login-content {
    width: 400px;
    margin: auto;
    padding: 30px;
    background: white;
    top: -120px;
    bottom: 0px;
    height: 240px;
    left: 0px;
    right: 0px;
    position: absolute;
  }

  #login-content2 {
    width: 800px;
    margin: auto;
    padding: 30px;
    background: white;
    top: -120px;
    bottom: 0px;
    height: 365px;
    left: 0px;
    right: 0px;
    position: absolute;
  }

  .sidebar {
    background: white;
  }

  .footer {
    background: white;
    position: absolute;
    bottom: 0px;
  }
</style>
<script>
  $('.mobile-menu').click(function() {
    $('.sidebar nav ul').toggleClass('active');
  })
</script>