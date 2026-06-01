	<div class="container-fluid">
		<div class="row mb-4">
			<div class="col-12 col-lg">
				<h1 class="main-title"><span>Lista użytkowników</span></h1>
			</div>
			<div class="col d-flex align-items-end flex-column">
				<a href="/admin/uzytkownicy/dodaj" class="mt-auto p-2">
					<button type="button" class="btn btn-primary">Dodaj użytkownika</button>
				</a>				
			</div>			
		</div>
		
		<div class="row block-white">
			<div class="col-12">
				<div class="content">
					<div class="table-responsive-md">
						<div class="table-wrapper">		
							<table class="table table-myborder table-hover" id="table">
								<thead>
									<tr class="d-flex">
										<th scope="col" class="col-1 text-center">Lp</th>
										<th scope="col" class="col-6">Login</th>
										<th scope="col" class="col-3">Data utworzenia</th>
										<th scope="col" class="col-1 text-center">Edytuj</th>
										<th scope="col" class="col-1 text-center">Usuń</th>
									</tr>
								</thead>
								<tbody>
									{foreach from=$users item=item key=key name=name}
										<tr class="d-flex">
											<td class="col-1 text-center">{$key+1}.</td>
											<td class="col-6">
												<a href="/admin/uzytkownicy/edytuj/{$item.id}" class="hover-opacity">{$item.login}</a>
											</td>
											<td class="col-3">{$item.created_at}</td>
											<td class="col-1 text-center">
												<a href="/admin/uzytkownicy/edytuj/{$item.id}" class="orange hover-opacity">
													<span class="icon-content-edit"></span>
												</a>
											</td>
											<td class="col-1 text-center">
												<a href="/admin/uzytkownicy/usun/{$item.id}" class="red hover-opacity">
													<span class="icon-content-delete"></span>
												</a>
											</td>
										</tr>
									{/foreach}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>				
		</div>				
	</div>							

<script>

$(document).ready(function() {
	$('#table').DataTable( {
		"lengthMenu": [[25, 50, 100, -1], [25, 50, 100, "Wszystko"]],			
		"language": {
			"lengthMenu": "Wyświetl _MENU_ pozycji na stronie",
			"zeroRecords": "Nic nie znaleziono",
			"info": "Strona _PAGE_ z _PAGES_",
			"infoEmpty": "Brak wyników wyszukiwania",
			"sSearch": "Wyszukaj",
			"infoFiltered": "",
			"oPaginate": {
				"sFirst":    	"<<",
				"sPrevious": 	"<",
				"sNext":     	">",
				"sLast":     	">>"
			}				
		},
		fnDrawCallback: function () {
		if ($(this).find('.dataTables_empty').length == 1) {
			$('#datatable1_info, #table_paginate, #datatable1_paginate, th').hide();
			$('.dataTables_empty').css({ "border-top": "1px solid #111" });
		} else {
			$('#datatable1_info, #table_paginate, #datatable1_paginate, th').show();
		}
		}

	});
});

</script>

