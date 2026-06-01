<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <h1 class="main-title"><span>Panel administracyjny</span></h1>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-12 mt-4 col-lg-9 mt-lg-0 block-dark-green ">
            <div class="content row no-mar-hor">
                <div class="col-12 col-lg-2 no-pad-hor">
                    <h4>Wyświetlenia<br /> {$polishMonth}</h4>
                    <div class="qua" id="monthCount">0</div>
                    <h4>W tym strona główna</h4>
                    <div class="qua">{$mainPageViewMonth}</div>
                </div>
                <div class="col-12 col-lg-10 no-pad-hor">
                    <canvas id="mybar" style="width:100%; height:160px;"></canvas>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-3 block-green">
            <div class="content">
                <h4>Wyświetlenia <br /> w poprzednim miesiącu</h4>
                <div class="qua">{$visitInPreviousMonth}</div>
            </div>
        </div>
    </div>

    <div class="row block-white mb-4">
        <div class="col-12">
            <div class="content">
                <h2 class="title"><span class="icon-menu-galeria ico-tit"></span>Nowo dodane zdjęcia</h2>

                <ul class="gallery d-flex justify-content-center flex-wrap">
                    {foreach from=$images item=img}
                        <li class="col">
                            <div class="img">
                                <a class="gallery-image-link" href="{$img.img_path}">
                                    <img src="{$img.thumb_path}" title="Nazwa: {$img.name}, Tytuł: {$img.title}" />
                                </a>
                            </div>
                        </li>
                    {/foreach}
                </ul>

            </div>
        </div>
    </div>

    <div class="row block-white mb-4">
       {* <div class="col-12 col-md-12 col-xl-5 col-xxl-12 mb-xxl-4">
            <div class="content">
                <h2 class="title"><span class="icon-menu-aktualnosci ico-tit"></span>Najpopularniejsze aktualności</h2>

                <div class="table-responsive-lg">
                    <div class="table-wrapper">
                        <table class="table table-myborder table-hover">
                            <thead>
                                <tr class="d-flex">
                                    <th scope="col" class="col-6">Temat</th>

                                    <th scope="col" class="col-4 text-center">Dodane</th>
                                    <!--<th scope="col">Link</th>-->
                                    <th scope="col" class="col-2 text-center">Wyświetleń</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$news item=item key=key name=name}
                                    <tr class="d-flex">
                                        <td class="col-6"><a href="/admin/aktualnosci/edytuj/{$item.id}" target="blank">{$item.title}</a></td>
                                        <td class="col-4 text-center">{$item.created_at}</td>
                                        <!--<td><a href="{$item.url}" target="blank">{$item.url}</a></td>-->
                                        <td class="col-2 text-center">{$item.visit}</td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>

                    </div>
                </div>

                <div class="d-flex flex-row">
                    <div class="p-2"><a href="/admin//aktualnosci" class="btn btn-dark">Zobacz więcej</a></div>
                </div>

            </div>
        </div> *}
        <div class="col-12 col-md-12 col-xl-12 col-xxl-12">
            <div class="content">
                <h2 class="title"><span class="icon-menu-podstrony ico-tit"></span>Podstrony</h2>
                <div class="table-responsive-lg">
                    <div class="table-wrapper">
                        <table class="table table-myborder table-hover">
                            <thead>
                                <tr class="d-flex">
                                    <th scope="col" class="col-1 text-center">Lp</th>
                                    <th scope="col" class="col-6 ">Nazwa</th>
                                    <th scope="col" class="col-1 text-center">Uzup.</th>
                                    <!--<th scope="col">Link</th>-->
                                    <th scope="col" class="col-2 text-center">Wyśw.</th>
                                    <th scope="col" class="col-1 text-center">Edytuj</th>
                                    <th scope="col" class="col-1 text-center">Usuń</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$pages item=item key=key name=name}
                                    <tr class="d-flex">
                                        <td class="text-center col-1">{$key+1}.</td>
                                        <td class="col-6"><a href="/admin/podstrony/edytuj/{$item.id}" target="blank">{$item.title}</a></td>
                                        <td class="text-center col-1">{if isset($users[$item.who_fill])} {$users[$item.who_fill].0} {else} Brak użytkownika{/if}</td>
                                        <!--<td><a href="{$item.url}" target="blank">{$item.url}</a></td>-->
                                        <td class="text-center col-2">{$item.visit}</td>
                                        <td class="text-center col-1">
                                            <a href="/admin/podstrony/edytuj/{$item.id}" class="orange hover-opacity">
                                                <span class="icon-content-edit"></span>
                                            </a>
                                        </td>
                                        <td class="text-center col-1">
                                            <a href="/admin/podstrony/usun/{$item.id}" class="red hover-opacity">
                                                <span class="icon-content-delete"></span>
                                            </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>

                <!--<div class="d-flex flex-row info">
					  <div class="p-2"><span class="icon-content-edit"></span> Edytuj podstronę</div>
					  <div class="p-2"><span class="icon-content-delete"></span> Usuń podstronę</div>
					</div>-->

            </div>
        </div>
    </div>

</div>


<script>
    // GALERIA
    $('.gallery-image-link').magnificPopup({
        type: 'image',
        mainClass: 'mfp-with-zoom',
        zoom: {
            enabled: true,
            duration: 300,
            easing: 'ease-in-out',
            opener: function(openerElement) {
                return openerElement.is('img') ? openerElement : openerElement.find('img');
            }
        }
    });


    /*
    	// TABELA
    	
    		$(document).ready(function(){
    		$('[data-toggle="tooltip"]').tooltip();
    		var actions = $("table td:last-child").html();
    		
    		// Dodanie wiersza zmienionego
    		$(document).on("click", ".add", function(){
    			var empty = false;
    			var input = $(this).parents("tr").find('input[type="text"]');
    			input.each(function(){
    				if(!$(this).val()){
    					$(this).addClass("error");
    					empty = true;
    				} else{
    					$(this).removeClass("error");
    				}
    			});
    			$(this).parents("tr").find(".error").first().focus();
    			if(!empty){
    				input.each(function(){
    					$(this).parent("td").html($(this).val());
    				});			
    				$(this).parents("tr").find(".add, .edit").toggle();
    				$(".add-new").removeAttr("disabled");
    			}		
    		});
    		// Edycja wiersza
    		$(document).on("click", ".edit", function(){		
    			$(this).parents("tr").find("td:not(:first-child):not(:last-child):not(:nth-child(4)):not(:nth-child(5))").each(function(){
    				$(this).html('<input type="text" class="form-control" value="' + $(this).text() + '">');
    			});		
    			$(this).parents("tr").find(".add, .edit").toggle();
    			$(".add-new").attr("disabled", "disabled");
    		});
    		//  Usuniecie wiersza
    		$(document).on("click", ".delete", function(){
    			$(this).parents("tr").remove();
    			$(".add-new").removeAttr("disabled");
    		});
    		});
    */
</script>


</div>

<div class="float-none"></div>

<script>
    const daysInCurrentMonth = {$daysInMonth}    
    const days = new Array(daysInCurrentMonth).fill().map((item, index) => index + 1)

    const views = {$views|@json_encode}
    const dataViews = days.map(day => views[day] ? views[day][0] : 0)
    const countViews = dataViews.reduce((a, b) => a + parseInt(b), 0)
    $("#monthCount").text(countViews)

    Chart.defaults.global.defaultFontFamily = "Poppins";
    var getDaysArray = function([year, month]) {
        var monthIndex = month - 1;
        var date = new Date(year, monthIndex, 1);
        var result = [];
        while (date.getMonth() == monthIndex) {
            result.push(date.getDate() + "-" + month);
            date.setDate(date.getDate() + 1);
        }
        return result;
    }

    const currentDate = moment().format("YYYY-MM")
    const datusInMonth = getDaysArray(currentDate.split("-"))


    new Chart(document.getElementById("mybar"), {
        type: 'bar',
        data: {
            labels: days,
            datasets: [{
                barPercentage: 0.5,
                barThickness: 8,
                maxBarThickness: 8,
                minBarLength: 2,
                label: "Wyświetlenia",
                type: 'bar',
                backgroundColor: "#c7ccbd",
                borderColor: "#c7ccbd",
                backgroundColorHover: "#c7ccbd",
                data: dataViews,
            }]
        },
        options: {
            scales: {
                xAxes: [{
                    labelFontColor: "#fff",
                    gridLines: {
                        lineWidth: 0,
                    },
                    ticks: {
                        display: true,
                        fontColor: "#fff",
                    }
                }],
                yAxes: [{
                    gridLines: {
                        lineWidth: 1,
                        borderDash: [5, 5],
                        color: "#c7ccbd"
                    },
                    ticks: {
                        maxTicksLimit: 5,
                        fontColor: '#fff',
                    }
                }]
            },
            legend: {
                display: true,
                labels: {
                    fontColor: '#fff'
                }
            },
            cornerRadius: 20,
            elements: { line: { fill: false } },
            responsive: true,
            legend: { display: false },
            title: {
                display: false,
                text: ''
            }
        }
    });

</script>
