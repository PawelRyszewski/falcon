<form method="post" action="/mail.php" class="contact-form contact-form--linear" novalidate id="contactForm">
  <div class="contact-form__line">
    <div class="contact-form__field">
      <label class="form-label" for="contact_name">Imię i nazwisko</label>
      <input id="contact_name" name="name" type="text" class="form-control" required autocomplete="name">
    </div>
    <div class="contact-form__field">
      <label class="form-label" for="contact_phone">Numer telefonu</label>
      <input id="contact_phone" name="phone" type="tel" class="form-control" required autocomplete="tel">
    </div>
    <div class="contact-form__field">
      <label class="form-label" for="contact_email">E-mail</label>
      <input id="contact_email" name="email" type="email" class="form-control" required autocomplete="email">
    </div>
  </div>

  <div class="contact-form__field contact-form__field--message">
    <label class="form-label" for="contact_msg">Treść wiadomości</label>
    <textarea id="contact_msg" name="message" rows="2" class="form-control" required></textarea>
  </div>

  <div class="contact-form__consents">
    <div class="form-check mb-2">
      <input class="form-check-input consent-required" type="checkbox" value="1" id="consent_privacy" name="consent_privacy">
      <label class="form-check-label" for="consent_privacy">
        Oświadczam, że zapoznałem się z <a href="/polityka-prywatnosci" target="_blank" rel="noopener">Polityką prywatności</a> i akceptuje jej warunki.
      </label>
    </div>
    <div class="form-check mb-2">
      <input class="form-check-input consent-required" type="checkbox" value="1" id="consent_marketing" name="consent_marketing">
      <label class="form-check-label d-flex" for="consent_marketing">
        <p>Wyrażam zgodę na przetwarzanie moich danych osobowych wskazanych w powyższym formularzu
        w celu otrzymywania informacji marketingowych w tym wiadomości typu newsletter[<a href="/polityka-prywatnosci" target="_blank" rel="noopener">więcej...</a>]</p>
      </label>
	  
    </div>
    <div class="form-check mb-2">
      <input class="form-check-input" type="checkbox" value="1" id="consent_email" name="consent_email">
      <label class="form-check-label" for="consent_email">
        na wskazany przeze mnie adres mailowy
      </label>
    </div>
    <div class="form-check mb-2">
      <input class="form-check-input" type="checkbox" value="1" id="consent_phone" name="consent_phone">
      <label class="form-check-label" for="consent_phone">
        na wskazany przeze mnie numer telefonu
      </label>
    </div>
    <div id="consent-error" style="display:none;color:#c0392b;font-size:14px;margin-top:.25rem;">
      Proszę zaakceptować wymagane zgody (Politykę prywatności oraz zgodę marketingową).
    </div>
    <div id="consent-channel-error" style="display:none;color:#c0392b;font-size:14px;margin-top:.25rem;">
      Proszę wybrać co najmniej jeden kanał kontaktu (e-mail lub telefon).
    </div>
  </div>

  <div class="contact-form__actions">
    <button type="submit" class="btn btn-primary px-4">Wyślij</button>
  </div>
</form>
<script>
(function() {
  document.getElementById('contactForm').addEventListener('submit', function(e) {
    var privacy      = document.getElementById('consent_privacy');
    var marketing    = document.getElementById('consent_marketing');
    var consentEmail = document.getElementById('consent_email');
    var consentPhone = document.getElementById('consent_phone');
    var errEl        = document.getElementById('consent-error');
    var errChannel   = document.getElementById('consent-channel-error');

    var baseOk    = privacy.checked && marketing.checked;
    var channelOk = consentEmail.checked || consentPhone.checked;

    if (!baseOk || !channelOk) {
      e.preventDefault();
      errEl.style.display      = baseOk    ? 'none'  : 'block';
      errChannel.style.display = channelOk ? 'none'  : 'block';
      privacy.closest('.form-check').classList.toggle('danger',   !privacy.checked);
      marketing.closest('.form-check').classList.toggle('danger', !marketing.checked);
      consentEmail.closest('.form-check').classList.toggle('danger', !channelOk);
      consentPhone.closest('.form-check').classList.toggle('danger', !channelOk);
    } else {
      errEl.style.display = errChannel.style.display = 'none';
    }
  });
})();
</script>
