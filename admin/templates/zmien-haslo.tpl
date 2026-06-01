<div class="page-wrapper">

  <section class="section">
    <div id="login-content" {if (isset($auth_error) || isset($captcha_error))} style="height: 470px;" {/if}>
      {if $isUser}
        <h2>Zmień hasło</h2>
        {if isset($new_password_send)}
          <p>Link do zmiany hasła został wysłany na podany adres emial</p>
        {else}
          <form method="post">
            <div class="form-group">
              <label>Podaj nowe hasło</label>
              </label>
              <small id="generated-password-msg" style="display:none;">Wygenerowane hasło to: <b
                  id="generated-password"></b></small>
              <input type="password" class="form-control" name="password" id="password" autocomplete="new-password"
                onkeyup="javascript: validPassword()">
              <small id="hasLowercase-error" class="red" style="display:none;">*Hasło musi posiadać min 1 małą
                literę</small>
              <small id="hasUpperrcase-error" class="red" style="display:none;">*Hasło musi posiadać min 1 duża
                literę</small>
              <small id="hasNumber-error" class="red" style="display:none;">*Hasło musi posiadać min 1
                cyfrę</small>
              <small id="hasSpecialChar-error" class="red" style="display:none;">*Hasło musi posiadać min 1 znak
                specialny !@#$%^&+()</small>
              <small id="hasLength-error" class="red" style="display:none;">*Hasło musi posiadać min 10 znaków</small>
            </div>
            <button type="submit" name="new_password" class="btn btn-primary btn-block btn-dark" onClick="javascript: submitChangePassword(event);">Zmień hasło</button>
          </form>
        {/if}
      {/if}
      {if !$isUser}
        <h2>Zmień hasło</h2>
        <p>Wystąpił błąd, link do zmiany hasła jest aktywny tylko 20 minut.</p>
        <p>Zrestartuj hasło ponownie, jeżeli problem pojawi się ponowniem prosimy o kontakt:</p>
        <p>kontakt@weo.pl</p>
        <br>
        <p style="text-align: center;"><a href="/admin/przypomnij-haslo">Zrestartuj hasło ponownie</a></p>
      {/if}
    </div>
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
    width: 425px;
    margin: auto;
    padding: 30px;
    background: white;
    top: -120px;
    bottom: 0px;
    height: 330px;
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
{literal}
<script>
  $('.mobile-menu').click(function() {
    $('.sidebar nav ul').toggleClass('active');
  })
</script>
<script>
const validateEmail = (email) => {
    return email.match(
        /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    );
};

function validLogin() {
    const login = $('#login').val();
    const isMail = validateEmail(login)

    if (isMail) {
        $("#login-error").css("display", 'none')
    } else {
        $("#login-error").css("display", 'block')
    }

    messagesValidationMenager(!isMail, "login")

    return hasLength
}

function submitChangeLogin(event) {
    const isValid = validLogin()

    if (!isValid) {
        event.preventDefault()
    }
}

function messagesValidationMenager(show, id) {
    const borderColor = show ? "red" : "#ced4da";
    $(`#${id}`).css('border-color', borderColor)
}

function submitChangePassword(event) {
    const isValid = validPassword()

    if (!isValid) {
        event.preventDefault()
    }
}

function generatePassword() {
    var length = 3,
        charsetLower = "abcdefghijklmnopqrstuvwxyz",
        charsetUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        charsetNumber = "0123456789",
        specialChar = "!@#$%^&+()",
        specialCharIndex = Math.floor(Math.random() * 10);
    retVal = "";
    for (var i = 0, n = charsetLower.length; i < length; ++i) {
        retVal += charsetLower.charAt(Math.floor(Math.random() * n));
    }
    for (var i = 0, n = charsetUpper.length; i < length; ++i) {
        retVal += charsetUpper.charAt(Math.floor(Math.random() * n));
    }
    for (var i = 0, n = charsetNumber.length; i < length; ++i) {
        retVal += charsetNumber.charAt(Math.floor(Math.random() * n));
    }
    retVal += specialChar[specialCharIndex];
    $("#generated-password").text(retVal);
    $("#generated-password-msg").css("display", 'block')
}

function validPassword() {
    const password = $('#password').val();
    const hasNumber = { value: /\d/g, id: "hasNumber-error" };
    const hasLowercase = { value: /[a-z]/g, id: "hasLowercase-error" };
    const hasUpperrcase = { value: /[A-Z]/g, id: "hasUpperrcase-error" };
    const hasSpecialChar = { value: /[!@#$%^&+()]/g, id: "hasSpecialChar-error" };
    const characterValidation = [hasNumber, hasLowercase, hasUpperrcase, hasSpecialChar];
    const hasCorrenctLength = password.length >= 10;

    let isVlaid = characterValidation.reduce((isValid, currentValue) => {
        if (currentValue.value.test(password)) {
            $('#' + currentValue.id).css("display", 'none')
            return isValid
        } else {
            $('#' + currentValue.id).css("display", 'block')
            return false
        }
    }, true);
    if (hasCorrenctLength) {
        $('#hasLength-error').css("display", 'none')
    } else {
        $('#hasLength-error').css("display", 'block')
        isVlaid = false
    }
    messagesValidationMenager(!isVlaid, 'password')
    return isVlaid
}
</script>
{/literal}