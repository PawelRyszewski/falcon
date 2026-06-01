	<div class="container-fluid">
		<div class="row block-white">
		<form class="p-4 col-12" method="POST">
			<div class="col-12">
				<div class="content">
					<h4>Czy usunąć nieruchomość <span class="red">"{$title}"</span> ?</h4>
					<br/>
					<a href="/admin/nieruchomosci"><button class="btn btn-primary" type="button">Nie, powrót do listy</button></a>
					<button type="submit" name="confirm_delete" class="btn btn-danger float-right">Tak, usuń</button>
				</div>
			</div>	
		</form>
		</div>
	</div>