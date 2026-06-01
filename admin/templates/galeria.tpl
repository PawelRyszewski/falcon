<div class="container-fluid">
	<div class="row mb-4">
		<div class="col-12 col-lg">
			<h1 class="main-title"><span>Lista galerii</span></h1>
		</div>
		<div class="col d-flex align-items-end justify-content-end align-items-center">
		
			<div class="watermark">
				<form enctype="multipart/form-data" method="POST">
					<div class="d-flex align-items-center">
					<span>
						<label for="upload_file" class="btn btn-primary mb-0">Wybierz znak wodny</label>
							<p style="font-size: 10px; margin: 0px 5px; color: red;">Zalecane użycie formatu .webp</p>
						</span>
						<input name="watermark" id="upload_file" value="wybierz plik" type="file" style="display:none;"/>
						<div class="buttons ml-1 {if ($isWetmarkAdded == 1)}active{/if}">
							<button type="submit" class="btn btn-success btn-sm mb-1 {if ($isWetmarkAdded == 1)}hide{/if}" name="watermark">Dodaj znak wodny</button>
						{if ($isWetmarkAdded == 1)}<div class="btn btn-success btn-sm mb-1" name="showwatermark">Podgląd znaku wodnego</div>{/if}								
							<button type="submit" class="btn btn-danger btn-sm" name="del_watermark">Usuń znak wodny</button>
							</div>
					</div>
				</form>
				{if ($isWetmarkAdded == 1)}
				<div class="added-watermark">
					<img src="./watermark.png" width="300px" height="200px"/>
				</div>
				{/if}
			</div>
		
			<a href="/admin/galeria-zdjec/dodaj" class="my-0 p-2">
				<button type="button" class="btn btn-primary">Dodaj galerie</button>
			</a>
		</div>
	</div>
	<div class="row block-white">
		<div class="col-12">
			<div class="content">
				<p>Przeciągnij rząd aby ustawić kolejność</p>
				<div class="table-responsive-md">
					<div class="table-wrapper">

						<table class="table table-myborder table-hover" id="table">
							<thead>
								<tr class="d-flex">
									<th scope="col" class="col-1 text-center">Lp</th>
									<th scope="col" class="col-5">Nazwa</th>
									<!--<th scope="col">Link</th>-->
									<th scope="col" class="col-2 text-center">Wyświetlenia</th>
									<th scope="col" class="col-1 text-center">Liczba zdjęć</th>
									<th scope="col" class="col-1 text-center">Widoczność <br /> na stronie</th>
									<th scope="col" class="col-1 text-center">Edytuj</th>
									<th scope="col" class="col-1 text-center">Usuń</th>
								</tr>
							</thead>
							<tbody id="sortable">
								{foreach from=$galeries item=item key=key name=name}
									<tr class="d-flex sortableElement">
										<td class="col-1 text-center">{$key+1}.</td>
										<td class="col-5 text-center"><a href="/admin/galeria-zdjec/edytuj/{$item.id}" class="blue hover-opacity">{$item.title}</a></td>
										<!--<td class="text-center">{$item.url}</td>-->
										<td class="col-2 text-center">{$item.visit}</td>
										<td class="col-1 text-center">{(isset($imgCount[$item.id]))? $imgCount[$item.id] : 0}</td>
										<td class="col-1 text-center">
											<form method="POST">
												<button type="submit" name="toggle_hide" class="blue hover-opacity" style="background: unset; border: none;">
													{if !$item.is_hide}
														<svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-eye-fill" fill="#3f9cff" xmlns="http://www.w3.org/2000/svg">
															<path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z" />
															<path fill-rule="evenodd" d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z" />
														</svg>
	
													{else}
														<svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-eye-slash-fill" fill="#3f9cff" xmlns="http://www.w3.org/2000/svg">
															<path d="M10.79 12.912l-1.614-1.615a3.5 3.5 0 0 1-4.474-4.474l-2.06-2.06C.938 6.278 0 8 0 8s3 5.5 8 5.5a7.029 7.029 0 0 0 2.79-.588zM5.21 3.088A7.028 7.028 0 0 1 8 2.5c5 0 8 5.5 8 5.5s-.939 1.721-2.641 3.238l-2.062-2.062a3.5 3.5 0 0 0-4.474-4.474L5.21 3.089z" />
															<path d="M5.525 7.646a2.5 2.5 0 0 0 2.829 2.829l-2.83-2.829zm4.95.708l-2.829-2.83a2.5 2.5 0 0 1 2.829 2.829z" />
															<path fill-rule="evenodd" d="M13.646 14.354l-12-12 .708-.708 12 12-.708.708z" />
														</svg>
	
													{/if}
												</button>
												<input type="hidden" name="is_hide" value="{if $item.is_hide == 1}0{else}1{/if}" />
												<input type="hidden" name="id_gallery" value="{$item.id}" class="gallery_id" />
											</form>
										</td>
										<td class="col-1 text-center">
											<a href="/admin/galeria-zdjec/edytuj/{$item.id}" class="blue hover-opacity">
												<span class="icon-content-edit"></span>
											</a>
										</td>
										<td class="col-1 text-center">
											<a href="/admin/galeria-zdjec/usun/{$item.id}" class="red hover-opacity">
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


<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script>
	$(function() {
		$("#sortable").sortable({
			update: (event, ui) => {
				$("#spinner").css("display", "flex")
				const elems = $(".sortableElement")
				const data = {}
				let i = 0
				for (let item of elems) {
					const id = $(item).find(".gallery_id").val()
					data[i] = id
					i++
				}

				$.ajax({
					url: "./utils/php/ajax-change-gallery-queue.php",
					type: "POST",
					data: data,
					success: function(response) {
						if (response === 'ok') {
							location.reload();
						}
					}
				});
			}
		});
		$("#sortable").disableSelection();
	});

	$(document).ready(function() {
		$('#table').DataTable({
			"lengthMenu": [
				[25, 50, 100, -1],
				[25, 50, 100, "Wszystko"]
			],
			"language": {
				"lengthMenu": "Wyświetl _MENU_ pozycji na stronie",
				"zeroRecords": "Nic nie znaleziono",
				"info": "Strona _PAGE_ z _PAGES_",
				"infoEmpty": "Brak wyników wyszukiwania",
				"sSearch": "Wyszukaj",
				"infoFiltered": "",
				"oPaginate": {
					"sFirst": "<<",
					"sPrevious": "<",
					"sNext": ">",
					"sLast": ">>"
				}
			},
			fnDrawCallback: function() {
				if ($(this).find('.dataTables_empty').length == 1) {
					$('#datatable1_info, #table_paginate, #datatable1_paginate, th').hide();
					$('.dataTables_empty').css({ "border-top": "1px solid #111" });
				} else {
					$('#datatable1_info, #table_paginate, #datatable1_paginate, th').show();
				}
			}

		});
		
		jQuery.fn.extend({
			toggleText: function (a, b){
				let that = this;
					if (that.text() != a && that.text() != b){
						that.text(a);
					}
					else
					if (that.text() == a){
						that.text(b);
					}
					else
					if (that.text() == b){
						that.text(a);
					}
				return this;
			}
		});
					
		jQuery('#upload_file').each(function () {

			$('[name="showwatermark"]').on('click', function(event) {
				$('.watermark .added-watermark').toggleClass('active');
				$(this).toggleText('Schowaj znak wodny', 'Podgląd znaku wodnego');
			});
			
			$this = jQuery(this);
				  $this.on('change', function() {
					   const fsize = $this[0].files[0].size,
						   ftype = $this[0].files[0].type,
						   fname = $this[0].files[0].name,
						   fextension = fname.substring(fname.lastIndexOf('.')+1);
						   validExtensions = ["jpg","jpeg","gif","png", "webp"];

						if ($.inArray(fextension.toLocaleLowerCase(), validExtensions) == -1){
							alert("Błędny format pliku, dozwolone formaty: webp, jpg, jpeg, png, gif");
							this.value = "";
							return false;
						}else{
							$('.watermark .buttons').addClass('active');
							if(fsize > 1048576){
								alert("Zbyt duży plik, dozwolony rozmiar: 1mb");
								this.value = "";
								return false;
							}
							return true;
					   }

				 });
		});			
	});
</script>