	<header class="border-bottom container-fluid">
		<div class="container">
			<nav class="navbar navbar-expand-lg w-100 py-0">
				<a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none justify-content-center" alt="Producent folii stretch Folpol" title="Producent folii stretch Folpol">
					<img class="bi me-2 me-xs-0" width="200" height="34" src="/utils/images/logo.svg" alt="Folia stretch, sianokiszonki"/>
				</a>
				
				<button class="navbar-toggler bg-dark navbar-dark mt-xs-2 mb-xs-2 w-100-mob" type="button" role="button" data-bs-toggle="collapse" data-bs-target="#navbar1" aria-controls="navbar1" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
		
				<div class="collapse navbar-collapse justify-content-end" id="navbar1">
					<ul class="nav nav-pills align-items-center justify-content-center">
							<li class="nav-item dropdown">
								<a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false" alt="Firma" title="Firma">Firma</a>
								
								<ul class="dropdown-menu dropdown-submenu">
									<li>
										<a class="dropdown-item" href="/rozwiazania/53" alt="Rozwiązania" title="Rozwiązania">Rozwiązania</a>
									</li>
									<li>
										<a class="dropdown-item" href="/referencje/54" alt="Referencje" title="Referencje">Referencje</a>
									</li>
									<li>
										<a class="dropdown-item" href="/praca/55" alt="Praca" title="Praca">Praca</a>
									</li>
									<li>
										<a class="dropdown-item" href="/faq/56" alt="FAQ" title="FAQ">FAQ</a>
									</li>
								</ul>
							</li>	
							<li class="nav-item dropdown">
								<a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false" alt="Oferta" title="Oferta">Oferta</a>
								
								<ul class="dropdown-menu dropdown-submenu">
									<li>
										<a class="dropdown-item" href="/folia_stretch/57" alt="Folia stretch" title="Folia stretch"><span>Folia stretch</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/folia-do-sianokiszonki/58" alt="Folia do sianokiszonki" title="Folia do sianokiszonki"><span>Folia do sianokiszonki</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/folia-ldpe/179" alt="Folia LDPE - termokurczliwa" title="Folia LDPE - termokurczliwa"><span>Folia LDPE - termokurczliwa</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/folia-pvc/180" alt="Folia PVC" title="Folia PVC"><span>Folia PVC</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/folia-pp/181" alt="Folia PP" title="Folia PP"><span>Folia PP</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/folia-babelkowa/182" alt="Folia bąbelkowa" title="Folia bąbelkowa"><span>Folia bąbelkowa</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/folia-barierowa/183" alt="Folia barierowa" title="Folia barierowa"><span>Folia barierowa</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/folia-poliolefinowa/65" alt="Folia poliolefinowa" title="Folia poliolefinowa"><span>Folia poliolefinowa</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/worki-foliowe/60" alt="Worki foliowe" title="Worki foliowe"><span>Worki foliowe</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/tasmy-pakowe/61" alt="Taśmy pakowe" title="Taśmy pakowe"><span>Taśmy pakowe</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/kartony/62" alt="Kartony" title="Kartony"><span>Kartony</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/owijarki-do-palet/63" alt="Owijarki do palet" title="Owijarki do palet"><span>Owijarki do palet</span></a>
									</li>
									<li>
										<a class="dropdown-item" href="/pozostale-produkty/64" alt="Pozostałe produkty" title="Pozostałe produkty"><span>Pozostałe produkty</span></a>
									</li>											
										
								</ul>
							</li>								
							{foreach from=$menuPages item=item}
								{if $item.category==3}
								<li class="nav-item w-100-mob text-center">
									<a class="nav-link" href="/{$item.url}/{$item.id}" title="{$item.title}">{$item.title}</a>
								</li>
								{/if}
							{/foreach} 
							
							<li class="nav-item dropdown choose-lang">
							<a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">PL</a>
								<ul class="dropdown-menu dropdown-submenu">
									<li>
										<a class="dropdown-item" href="/eng" alt="ENG - Angielski" title="ENG - Angielski">ENG - Angielski</a>
									</li>
									<li>
										<a class="dropdown-item" href="/de" alt="DE - Niemiecki" title="DE - Niemiecki">DE - Niemiecki</a>
									</li>	
									<li>
										<a class="dropdown-item" href="/ru" alt="RU - Rosyjski" title="RU - Rosyjski">RU - Rosyjski</a>
									</li>										
								</ul>	
							</li>
				
					</ul>
									
				</div>
				
				<div class="collapse navbar-collapse justify-content-end" id="lang-mobile">
					<ul class="nav nav-pills align-items-center justify-content-center"> 
						<li class="nav-item dropdown choose-lang">
						<a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">PL</a>
							<ul class="dropdown-menu dropdown-submenu">
								<li>
									<a class="dropdown-item" href="/eng" alt="ENG - Angielski" title="ENG - Angielski">ENG - Angielski</a>
								</li>
								<li>
									<a class="dropdown-item" href="/de" alt="DE - Niemiecki" title="DE - Niemiecki">DE - Niemiecki</a>
								</li>	
								<li>
									<a class="dropdown-item" href="/ru" alt="RU - Rosyjski" title="RU - Rosyjski">RU - Rosyjski</a>
								</li>										
							</ul>	
						</li>					
					</ul>					
				</div>
			</nav>
		</div>
</header>