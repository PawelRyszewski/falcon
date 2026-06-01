

	<div class="page-wrapper">
		
		<section class="section">
		<div id="login-content" class="rounded" {if (isset($auth_error) || isset($captcha_error))} style="height: 470px;" {/if}>
			<h1>Zaloguj się</h1>
			{if isset($captcha_error)}
				<div class="alert alert-danger" role="alert">Kod z obrazka jest błędny</div>
			{/if}
			{if isset($auth_error)}
				<div class="alert alert-danger" role="alert">Login lub hasło jest błędne</div>
			{/if}
			<form method="post">
				<div class="form-group">
					<label>Login</label>
					<input type="text" class="form-control" name="login">
				</div>
				<div class="form-group">
					<label>Hasło</label>
					<input type="password" class="form-control" name="password">
				</div>
				<div class="form-group">
					<label>Wpisz tylko <strong style="color:#000">czarne</strong> znaki:</label>
					<img src="/admin/utils/captcha/captcha.php" alt="captcha image" style="margin-left:3px;">
					<input type="text" name="captcha" class="form-control" />
				</div>
				
				<div class="d-grid gap-2 col-6 mx-auto">
					<button type="submit" name="sign_in" class="btn btn-primary btn-block btn-dark mt-4">Zaloguj się</button>
				<div>
				</form>
				<div class="newPassword"><a href="/admin/przypomnij-haslo">Przypomnij hasło</a></div>
		</div>
		</section>
	</div>
	
	<div class="contianer-fluid">
		<footer class="row d-flex flex-wrap justify-content-between align-items-top py-3 my-4 border-top bg-dark text-light position-absolute bottom-0 left-0 w-100 mx-0 mb-0">
			<p class="col-md-4 mb-0 text-white-50" style="font-size:12px;">© {$smarty.now|date_format:"%Y"} weo.pl <br/> Wszelkie prawa zastrzeżone </p>

			<a href="/" title="Strony na abonament" style="flex:auto; font-size:12px;" class="col-md-4 d-flex flex-wrap flex-direction-column align-items-center justify-content-end mb-3 mb-md-0 me-md-auto link-dark text-decoration-none icon-container">
				<p class="w-100 mb-0 text-end text-white-50">Projekt i realizacja</p>
				<span class="icon weo"></span>
			</a>
		</footer>
	</div>	
	
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
        height: 450px;
        left: 0px;
        right: 0px;
		position: absolute;
    }
	.sidebar {
		background:white;
	}
	.footer { 
		background: white;
		position: absolute;
    	bottom: 0px;
	}
	.newPassword{
		text-align: center;
    font-size: 14px;
    margin-top: 10px;
	}
</style>
<script>
    $('.mobile-menu').click(function(){
        $('.sidebar nav ul').toggleClass('active');
    })
</script>	
	
</body>
