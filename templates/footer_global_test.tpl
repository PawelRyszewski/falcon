<div class="contianer-fluid">
	<footer class="row d-flex flex-wrap justify-content-between align-items-top py-3 border-top bg-dark2 text-light mx-0 mb-0">
		<p class="col-md-4 mb-0 text-white-50" style="font-size:12px;">© {$smarty.now|date_format:"%Y"}  <br/> 
		{if $page.id==0}
			Wszelkie prawa zastrzeżone 
		{/if}
		{if $page.category==3}
			Wszelkie prawa zastrzeżone 
		{else if $page.category==4}
			All rights reserved
		{else if $page.category==5}
			Konzeption und Umsetzung
		{else if $page.category==6}		
			Дизайн и реализация
		{/if}	
		</p>


		<a href="https://weo.pl" title="Strony na abonament" style="flex:auto; font-size:12px;" class="col-md-4 d-flex flex-wrap flex-direction-column align-items-center justify-content-end mb-3 mb-md-0 me-md-auto link-dark text-decoration-none icon-container">
			<p class="w-100 mb-0 text-end text-white-50">
			{if $page.id==0}
				Projekt i realizacja
			{/if}			
			{if $page.category==3}
				Projekt i realizacja
			{else if $page.category==4}
				Design and implementation
			{else if $page.category==5}
				Konzeption und Umsetzung
			{else if $page.category==6}		
				Дизайн и реализация
			{/if}
			</p>
				
			<span class="icon weo"></span>
		</a>

	</footer>
</div>	
{literal}
<script src="https://sugestie.weo.pl/popup" type="text/javascript" async></script>
<script>
	const shouldHideCookiesAlert = localStorage.getItem('shouldHideCookiesAlert');

	if (!shouldHideCookiesAlert) {
	$('#cookies-info').css('display','block');
	}

	function closeCookiesInfo() {
	$('#cookies-info').css('display','none');
	localStorage.setItem('shouldHideCookiesAlert', true);
	}
</script>


<script>
  if (window.innerWidth >= 768) {
    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = '/utils/css/aos.css';
    document.head.appendChild(link);

    var script = document.createElement('script');
    script.src = '/utils/js/aos.js';
    script.onload = function () {
      AOS.init({
        offset: 120,
        delay: 0,
        duration: 800,
        easing: 'ease-in-out',
        once: true,
      });
    };
    document.head.appendChild(script);
  }
  
  
const LCP_SUB_PARTS = [
  'Time to first byte',
  'Resource load delay',
  'Resource load duration',
  'Element render delay',
];

new PerformanceObserver((list) => {
  const lcpEntry = list.getEntries().at(-1);
  const navEntry = performance.getEntriesByType('navigation')[0];
  const lcpResEntry = performance
    .getEntriesByType('resource')
    .filter((e) => e.name === lcpEntry.url)[0];

  // Ignore LCP entries that aren't images to reduce DevTools noise.
  // Comment this line out if you want to include text entries.
  if (!lcpEntry.url) return;

  // Compute the start and end times of each LCP sub-part.
  // WARNING! If your LCP resource is loaded cross-origin, make sure to add
  // the `Timing-Allow-Origin` (TAO) header to get the most accurate results.
  const ttfb = navEntry.responseStart;
  const lcpRequestStart = Math.max(
    ttfb,
    // Prefer `requestStart` (if TOA is set), otherwise use `startTime`.
    lcpResEntry ? lcpResEntry.requestStart || lcpResEntry.startTime : 0
  );
  const lcpResponseEnd = Math.max(
    lcpRequestStart,
    lcpResEntry ? lcpResEntry.responseEnd : 0
  );
  const lcpRenderTime = Math.max(
    lcpResponseEnd,
    // Use LCP startTime (the final LCP time) because there are sometimes
    // slight differences between loadTime/renderTime and startTime
    // due to rounding precision.
    lcpEntry ? lcpEntry.startTime : 0
  );

  // Clear previous measures before making new ones.
  // Note: due to a bug, this doesn't work in Chrome DevTools.
  LCP_SUB_PARTS.forEach((part) => performance.clearMeasures(part));

  // Create measures for each LCP sub-part for easier
  // visualization in the Chrome DevTools Performance panel.
  const lcpSubPartMeasures = [
    performance.measure(LCP_SUB_PARTS[0], {
      start: 0,
      end: ttfb,
    }),
    performance.measure(LCP_SUB_PARTS[1], {
      start: ttfb,
      end: lcpRequestStart,
    }),
    performance.measure(LCP_SUB_PARTS[2], {
      start: lcpRequestStart,
      end: lcpResponseEnd,
    }),
    performance.measure(LCP_SUB_PARTS[3], {
      start: lcpResponseEnd,
      end: lcpRenderTime,
    }),
  ];

  // Log helpful debug information to the console.
  console.log('LCP value: ', lcpRenderTime);
  console.log('LCP element: ', lcpEntry.element, lcpEntry.url);
  console.table(
    lcpSubPartMeasures.map((measure) => ({
      'LCP sub-part': measure.name,
      'Time (ms)': measure.duration,
      '% of LCP': `${
        Math.round((1000 * measure.duration) / lcpRenderTime) / 10
      }%`,
    }))
  );
}).observe({type: 'largest-contentful-paint', buffered: true});
  
</script>
{/literal}

</main>
</body>
</html>