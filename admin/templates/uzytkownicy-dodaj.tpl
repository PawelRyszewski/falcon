	<div class="container-fluid">
		<div class="row mb-4">
			<div class="col-12 col-lg">
				<h1 class="main-title"><span>Dodaj użytkownika</span></h1>
			</div>
			<div class="col d-flex align-items-end flex-column">
                <a href="/admin/uzytkownicy" class="mt-auto p-2">
                    <button type="button" class="btn btn-primary">Powrót</button>
                </a>				
			</div>			
		</div>
		
		<div class="row block-white">
			<div class="col-12">
				<div class="content">
					<div class="table-responsive-md">
						<div class="table-wrapper">		

							<form class="p-3" name="add-user" method="post">
								<div class="form-group">
									<label>Login</label>
									<input type="text" class="form-control" name="login" autocomplete="username" id="login"
										onkeyup="javascript: validLogin()">
									<small id="login-error" class="red" style="display:none;">*Login musi być adresem email</small>
								</div>
								<div class="form-group">
									<label>Hasło</label>
									<label class="float-right create-url" onclick="javascript: generatePassword()">Generuj hasło
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
								<button type="submit" name="add_user" onClick="javascript: submitFormUser(event);" class="btn btn-success">Dodaj
									użytkownika</button>
							</form>

						</div>
					</div>
				</div>
			</div>				
		</div>				
	</div>							


{literal}
    <script>
        const validateEmail = (email) => {
            return email.match(
                /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            );
        };
        //SUBMIT FORM
        function submitFormUser(event) {
            const isVlaid = [validPassword(), validLogin()].reduce((isVlaid, item) => { return item ? isVlaid : item },
                true)
    
            if (!isVlaid) {
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
    
        function validLogin() {
            const login = $('#login').val();
            const isMail = validateEmail(login);

            if (isMail) {
                $("#login-error").css("display", 'none')
            } else {
                $("#login-error").css("display", 'block')
            }
            messagesValidationMenager(!isMail, "login")
    
            return isMail
        }
    
        function messagesValidationMenager(show, id) {
            const borderColor = show ? "red" : "#ced4da";
            $(`#${id}`).css('border-color', borderColor)
        }
    </script>
{/literal}