<div id="addImgModal">
  <div id="addImgForm">
    <svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-x icon-close" fill="currentColor" xmlns="http://www.w3.org/2000/svg" onclick="closeAddImgModal()">
      <path fill-rule="evenodd" d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"></path>
    </svg>

    <h2>Dodaj zdjęcie</h2>
	<input type="file" style="display:none !important;" name="add_img_tinymice" class="mt-1" id="add_img_tinymice" />
    <div class="form-group mt-3">
      <label>Link do obrazu</label>
      <input type="text" class="form-control" id="img_url" placeholder="https://example.com/obrazek.jpg">
    </div>

    <div class="form-group mt-3">
      <label>Nazwa zdjęcia</label>
      <input type="text" class="form-control" id="img_name">
    </div>

    <div class="form-group mt-3">
      <label>Tytuł zdjęcia</label>
      <input type="text" class="form-control" id="img_title">
    </div>

    <div class="form-group mt-3" id="galleryContainer" style="max-height: 200px; overflow-y: auto; border: 1px solid #ccc; padding: 5px;"></div>

	 <button class="btn btn-primary mt-3" onClick="addImg()">Dodaj zdjęcie</button>
    <button class="btn btn-danger mt-3 float-right" onclick="closeAddImg()">Anuluj</button>
  </div>
</div>

<style>
  #addImgModal {
    width: 100%;
    height: 100vh;
    background-color: #00000096;
    z-index: 10;
    position: fixed;
    top: 0;
    left: 0;
    display: none;
    justify-content: center;
    align-items: center;
    flex-direction: row;
  }

  #addImgForm {
    background-color: white;
    padding: 15px;
    width: 400px;
    position: relative;
  }

  .icon-close {
    position: absolute;
    right: 13px;
    font-size: 26px;
    color: #dc3545;
    cursor: pointer;
    width: auto;
  }

  .gallery-thumb {
    width: 60px;
    height: 60px;
    object-fit: cover;
    margin: 5px;
    cursor: pointer;
    border: 1px solid #ccc;
  }
</style>


{literal}
    <script>
		function closeAddImgModal() {
		  $('#addImgModal').fadeOut();
		  closeAddImg();
		}

		function closeAddImg() {
		  $("#addImgModal").css("display", "none");
		  $('#add_img_tinymice').val("");
		  $('#img_title').val("");
		  $('#img_name').val("");
		  $('#img_url').val("");
		}

		function openAddImgModal() {
		  loadGalleryImages();
		  $('#addImgModal').css("display", "flex");
		}
				
		function loadGalleryImages() {
		  const galleryContainer = document.getElementById('galleryContainer');
		  galleryContainer.innerHTML = '';

		  $.ajax({
				url: "../../../admin/utils/php/ajax-get-images.php",
				method: "GET",
				dataType: "json",
                        success: function(data) {
                          if (data && data.images && data.images.length > 0) {
                                data.images.forEach(function(image) {
                                        const thumbUrl = image.thumb;
                                        const fullUrl = image.full;

						  const imgEl = document.createElement('img');
						  imgEl.src = thumbUrl;
						  imgEl.className = 'gallery-thumb';
						  imgEl.title = fullUrl;
						  imgEl.addEventListener('click', function() {
								document.getElementById('img_url').value = fullUrl;
						  });

						  galleryContainer.appendChild(imgEl);
						});
				  } else {
						galleryContainer.innerHTML = '<p>Brak obrazków do wyświetlenia.</p>';
				  }
				},
				error: function(xhr, status, error) {
				  console.error("Błąd pobierania obrazków:", error);
				  galleryContainer.innerHTML = '<p>Wystąpił błąd podczas ładowania obrazków.</p>';
				}
		  });
		}

        // TOP MENU
        $(function() {
            setNavigation();
        });
    
		function setNavigation() {
		  var path = window.location.pathname;
		  path = path.replace(/\/$/, "");
		  path = decodeURIComponent(path);

		  $("ul.menu a").each(function() {
			var href = $(this).attr('href');
			if (path.substring(0, href.length) === href && href !== "/") {
			  $(this).closest('a').addClass('active');
			}
		  });
		}
    
        // MENU GALLERY
		$('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
		  var hash = $(e.target).attr('href');
		  if (history.pushState) {
			history.pushState(null, null, hash);
		  } else {
			location.hash = hash;
		  }
		});
    
        var hash = window.location.hash;
        if (hash) {
            $('.nav-link[href="' + hash + '"]').tab('show');
        }
    
        // MENU MOBILE
        jQuery('div.burger-menu').click(function() {
            jQuery('div.side-bar ul.menu').toggleClass('active');
        })
    
		
		function insertImgLink() {
		  const link = document.getElementById('imgLink').value;
		  if (link) {
			tinymce.activeEditor.insertContent(`<img src="${link}" alt="" />`);
		  }
		  document.getElementById('addImgModal').style.display = 'none';
		}
		
		 function addImg() {
		  const file = $("#add_img_tinymice").get(0).files[0];
		  const imageUrl = document.getElementById('img_url').value;
		  const imageName = document.getElementById('img_name').value || '';
		  const imageTitle = document.getElementById('img_title').value || '';


		  if (file) {
			const validFormats = ['jpg', 'jpeg', 'png', 'gif'];
			const filenameToArray = file.name.split('.');
			const fileExt = filenameToArray[filenameToArray.length - 1];

			if (!validFormats.includes(fileExt.toLowerCase())) {
			  return alert("Poprawne formaty zdjęć to " + validFormats.join(", "));
			}

			const jform = new FormData();
			jform.append('img', file);
			jform.append('img_title', imageTitle);
			jform.append('img_name', imageName);

			$.ajax({
			  url: "/admin/utils/php/ajax-tinymce-add-img.php",
			  type: 'POST',
			  data: jform,
			  mimeType: 'multipart/form-data',
			  contentType: false,
			  cache: false,
			  processData: false,
			  success: function(data, status, jqXHR) {
				const img = JSON.parse(data);
				tinymce.activeEditor.insertContent(
				  `<img src="/ai-materials/uploads/thumb/${img.img_name}" title="${img.img_title}" alt="${img.img_title}"/>`
				);
				closeAddImg();
			  },
			});
		  }

		  else if (imageUrl) {
			tinymce.activeEditor.insertContent(
			  `<img src="${imageUrl}" alt="${imageName}" title="${imageTitle}" />`
			);
			closeAddImg();
		  }

		  else {
			alert("Nie wybrano zdjęcia ani linku do zdjęcia");
		  }
		}

		tinymce.init({
		  language: 'pl',
		  selector: '#tinymice',
		  width: "100%",
		  height: 500,
		  plugins: [
			'advlist autolink link image lists charmap print preview hr anchor pagebreak',
			'searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking',
			'table emoticons template paste help'
		  ],
		  toolbar: [
			'undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link | print preview media fullpage | forecolor backcolor emoticons | help',
			'addImage add1col add2col add3col add4col add6col addBtn addParagraph addH1 addH2 addH3 addH4 marginMenu paddingMenu borderMenu addHr'
		  ],
		  menubar: 'favs file edit view insert format tools table help',
		  content_css: [
			'../../../utils/css/bootstrap.css',
			'../../../utils/css/style-min.css',
			'../../../utils/css/tinymce.css'
		  ],
		  setup: function(editor) {
			  
			  editor.ui.registry.addButton('addImage', {
				icon: 'image',
				tooltip: 'Dodaj obrazek',
				onAction: function() {
				  document.getElementById('addImgModal').style.display = 'flex';
				  loadGalleryImages();
				},
				onSetup: function(api) {
				  setTimeout(function() {
					var buttonEl = api.getEl();
					if (buttonEl) {
					  buttonEl.classList.add('custom-icon-container');
					}
				  }, 0);
				}
			  });
			  
			editor.ui.registry.addButton('add1col', {
			  text: '1 kolumny',
			  onAction: function() {
				const snippet = `\n<div class=\"row\">\n  <div class=\"col-md-12\"><p>Twoja treść</p></div>\n </div>\n<p>Twoja treść</p>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('add2col', {
			  text: '2 kolumny',
			  onAction: function() {
				const snippet = `\n<div class=\"row\">\n  <div class=\"col-md-6\"><p>Twoja treść</p></div>\n  <div class=\"col-md-6\"><p>Twoja treść</p></div>\n</div>\n<p>Twoja treść</p>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('add3col', {
			  text: '3 kolumny',
			  onAction: function() {
				const snippet = `\n<div class=\"row\">\n  <div class=\"col-md-4\"><p>Twoja treść</p></div>\n  <div class=\"col-md-4\"><p>Twoja treść</p></div>\n  <div class=\"col-md-4\"><p>Twoja treść</p></div>\n</div>\n<p>Twoja treść</p>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('add4col', {
			  text: '4 kolumny',
			  onAction: function() {
				const snippet = `\n<div class=\"row\">\n  <div class=\"col-md-3\"><p>Twoja treść</p></div>\n  <div class=\"col-md-3\"><p>Twoja treść</p></div>\n  <div class=\"col-md-3\"><p>Twoja treść</p></div>\n  <div class=\"col-md-3\"><p>Twoja treść</p></div>\n</div>\n<p>Twoja treść</p>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('add6col', {
			  text: '6 kolumny',
			  onAction: function() {
				const snippet = `\n<div class=\"row\">\n  <div class=\"col-md-2\"><p>Twoja treść</p></div>\n  <div class=\"col-md-2\"><p>Twoja treść</p></div>\n  <div class=\"col-md-2\"><p>Twoja treść</p></div>\n  <div class=\"col-md-2\"><p>Twoja treść</p></div>\n  <div class=\"col-md-2\"><p>Twoja treść</p></div>\n  <div class=\"col-md-2\"><p>Twoja treść</p></div>\n</div>\n<p>Twoja treść</p>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('addBtn', {
			  text: 'Przycisk',
			  onAction: function() {
				const snippet = `<a href=\"#\" id=\"tmp-btn\" class=\"btn btn-success btn-lg w-100\">Przycisk</a>`;
				editor.insertContent(snippet);
				editor.focus();
				const btnElement = editor.dom.select('#tmp-btn')[0];
				if (btnElement) {
				  editor.selection.select(btnElement);
				  editor.dom.setAttrib(btnElement, 'id', null);
				  editor.execCommand('mceLink');
				}
			  }
			});

			editor.ui.registry.addButton('addParagraph', {
			  text: 'Paragraf',
			  onAction: function() {
				const snippet = `<p>Treść akapitu...</p>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('addH1', {
			  text: 'H1',
			  onAction: function() {
				const snippet = `<h1 class=\"mt-2 mb-3 pb-3 border-bottom\">Nagłówek H1</h1>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('addH2', {
			  text: 'H2',
			  onAction: function() {
				const snippet = `<h2 class=\"mt-2 mb-3 pb-3 border-bottom\">Nagłówek H2</h2>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('addH3', {
			  text: 'H3',
			  onAction: function() {
				const snippet = `<h3 class=\"mt-2 mb-3 pb-3 border-bottom\">Nagłówek H3</h3>`;
				editor.insertContent(snippet);
			  }
			});

			editor.ui.registry.addButton('addH4', {
			  text: 'H4',
			  onAction: function() {
				const snippet = `<h4 class=\"mt-2 mb-3 pb-3 border-bottom\">Nagłówek H4</h4>`;
				editor.insertContent(snippet);
			  }
			});

			// Menu marginesów
			editor.ui.registry.addMenuButton('marginMenu', {
			  text: 'Marginesy',
			  fetch: function(callback) {
				const items = [
				  {
					type: 'menuitem',
					text: 'm-0',
					onAction: function() {
					  addClassToSelection(editor, 'm-0');
					}
				  },
				  {
					type: 'menuitem',
					text: 'm-1',
					onAction: function() {
					  addClassToSelection(editor, 'm-1');
					}
				  },
				  {
					type: 'menuitem',
					text: 'm-2',
					onAction: function() {
					  addClassToSelection(editor, 'm-2');
					}
				  },
				  {
					type: 'menuitem',
					text: 'm-3',
					onAction: function() {
					  addClassToSelection(editor, 'm-3');
					}
				  },
				  {
					type: 'menuitem',
					text: 'm-4',
					onAction: function() {
					  addClassToSelection(editor, 'm-4');
					}
				  },
				  {
					type: 'menuitem',
					text: 'm-5',
					onAction: function() {
					  addClassToSelection(editor, 'm-5');
					}
				  }
				];
				callback(items);
			  }
			});

			// Menu paddingów
			editor.ui.registry.addMenuButton('paddingMenu', {
			  text: 'Padding',
			  fetch: function(callback) {
				const items = [
				  {
					type: 'menuitem',
					text: 'p-0',
					onAction: function() {
					  addClassToSelection(editor, 'p-0');
					}
				  },
				  {
					type: 'menuitem',
					text: 'p-1',
					onAction: function() {
					  addClassToSelection(editor, 'p-1');
					}
				  },
				  {
					type: 'menuitem',
					text: 'p-2',
					onAction: function() {
					  addClassToSelection(editor, 'p-2');
					}
				  },
				  {
					type: 'menuitem',
					text: 'p-3',
					onAction: function() {
					  addClassToSelection(editor, 'p-3');
					}
				  },
				  {
					type: 'menuitem',
					text: 'p-4',
					onAction: function() {
					  addClassToSelection(editor, 'p-4');
					}
				  },
				  {
					type: 'menuitem',
					text: 'p-5',
					onAction: function() {
					  addClassToSelection(editor, 'p-5');
					}
				  }
				];
				callback(items);
			  }
			});

			// Menu borderów
			editor.ui.registry.addMenuButton('borderMenu', {
			  text: 'Obramowanie',
			  fetch: function(callback) {
				const items = [
				  {
					type: 'menuitem',
					text: 'border',
					onAction: function() {
					  addClassToSelection(editor, 'border');
					}
				  },
				  {
					type: 'menuitem',
					text: 'border-top',
					onAction: function() {
					  addClassToSelection(editor, 'border-top');
					}
				  },
				  {
					type: 'menuitem',
					text: 'border-end',
					onAction: function() {
					  addClassToSelection(editor, 'border-end');
					}
				  },
				  {
					type: 'menuitem',
					text: 'border-bottom',
					onAction: function() {
					  addClassToSelection(editor, 'border-bottom');
					}
				  },
				  {
					type: 'menuitem',
					text: 'border-start',
					onAction: function() {
					  addClassToSelection(editor, 'border-start');
					}
				  }
				];
				callback(items);
			  }
			});

			// Dodaj przycisk <hr>
			editor.ui.registry.addButton('addHr', {
			  text: 'Linia (hr)',
			  onAction: function() {
				editor.insertContent('<hr/>');
			  }
			});

			// Funkcja do dodawania klas z Bootstrapa do zaznaczonego elementu
			function addClassToSelection(editor, className) {
			  const selectedNode = editor.selection.getNode();
			  const currentClass = selectedNode.getAttribute('class') || '';
			  if (currentClass.indexOf(className) === -1) {
				const newClass = (currentClass + ' ' + className).trim();
				selectedNode.setAttribute('class', newClass);
			  }
			}
		  }
		});


    </script>
{/literal}