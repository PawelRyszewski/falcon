    $('.google-map iframe').hover(function(){
        $(this).toggleClass('active');
    });

    $(document).ready(function() {
	
		var $dropdownButton = $('button[data-bs-toggle="dropdown"]');

		function updateButtonText() {
			if ($dropdownButton.attr('aria-expanded') === 'true') {
				$dropdownButton.text("Zwiń menu");
			} else {
				$dropdownButton.text("Rozwiń menu");
			}
		}

		$dropdownButton.on('click', function() {
			setTimeout(updateButtonText, 0);
		});

		$dropdownButton.on('show.bs.dropdown', function() {
			$dropdownButton.text("Zwiń menu");
		});

		$dropdownButton.on('hidden.bs.dropdown', function() {
			$dropdownButton.text("Rozwiń menu");
		});	


		$(function () {
		  const path = window.location.pathname.replace(/\/$/, '');

		  $('nav a').each(function () {
			const href = $(this).attr('href').replace(/\/$/, '');

			if (href === path) {
			  $(this).addClass('active');

			  $(this)
				.closest('.nav-item.dropdown')
				.addClass('active') 
				.children('.nav-link') 
				.addClass('active');
			}
		  });
		});
		
      });
	  

	  
    
    $('div.mobile-menu .burger').click(function(){
        $('.navigation nav').toggleClass('active');
    })
	
	/*
	jQuery(document).ready(function() {
		if (jQuery('body').length) {
			var scrollTrigger = 60, // px
				backToTop = function () {
					var scrollTop = jQuery(window).scrollTop();
					if (scrollTop > scrollTrigger) {
						jQuery('.back-to-top').addClass('show');
						jQuery('body').addClass('fixed');
					} else {
						jQuery('.back-to-top').removeClass('show');
						jQuery('body').removeClass('fixed');
					}
				};
			backToTop();
			jQuery(window).on('scroll', function () {
				backToTop();
			}); 
		}
	
		
		jQuery(window).scroll(function(){
			if(jQuery(window).scrollTop() + jQuery(window).height() > jQuery(document).height() - (jQuery(document).height() / 200)) {
				jQuery('.back-to-top').addClass('move');
			} else {
				jQuery('.back-to-top').removeClass('move');
			}
		});
		
		$(".back-to-top").click(function(){
			$("html, body").animate({ scrollTop: 0 }, "1");              
			$('html, body').stop(true, true);
			return false;   
		});
  });*/
  
document.addEventListener('DOMContentLoaded', function(){
  var dropdownLinks = document.querySelectorAll('.dropdown-toggle[data-bs-toggle="dropdown"]');
  dropdownLinks.forEach(function(link){
        link.addEventListener('click', function(e){
          if(window.innerWidth >= 992){
                window.location.href = link.getAttribute('href');
          }
        });
  });
});

$(function(){
  var $form = $('#newsletter-form');
  var $alert = $('#newsletter-alert');
  if($form.length){
    $form.on('submit', function(e){
      e.preventDefault();
      $.ajax({
        url: '/newsletter.php',
        method: 'POST',
        data: $form.serialize(),
        dataType: 'json',
        headers: {'X-Requested-With':'XMLHttpRequest'},
        success: function(res){
          if(res.status === 'ok'){
            $alert.removeClass('d-none alert-danger').addClass('alert-success').text('Dziękujemy za zapisanie do newslettera.');
            $form[0].reset();
          }else if(res.status === 'exists'){
            $alert.removeClass('d-none alert-success').addClass('alert-danger').text('Adres e-mail jest już zapisany.');
          }else{
            $alert.removeClass('d-none alert-success').addClass('alert-danger').text('Błędny adres e-mail.');
          }
        },
        error: function(){
          $alert.removeClass('d-none alert-success').addClass('alert-danger').text('Wystąpił błąd. Spróbuj ponownie.');
        }
      });
    });
  }
});
$(function(){
	$('form').on('click', 'button[name="vote"]', function(e){
	  var $btn = $(this);
	  if(!$btn.hasClass('captcha-shown')){
		e.preventDefault();

		$('form button[name="vote"].captcha-shown').not($btn).each(function(){
		  var $otherBtn = $(this);
		  var $otherForm = $otherBtn.closest('form');
		  var $otherBox = $otherForm.find('.captcha-container');
		  $otherBox.removeClass('active').addClass('d-none').find('input[name="captcha"]').val('');
		  $otherBtn.text('Głosuj').removeClass('captcha-shown').attr('type','button');
		});

		var $form = $btn.closest('form');
		var $box = $form.find('.captcha-container');
		var $img = $box.find('.captcha-img');
		var src = $img.data('src') || $img.attr('src');
		$img.attr('src', (src || '/admin/utils/captcha/captcha.php') + '?' + Date.now());
		$box.removeClass('d-none').addClass('active');
		$box.find('input[name="captcha"]').val('');
		$btn.text('Oddaj głos').addClass('captcha-shown').attr('type','submit');
	  }
	});
});
$(function(){
  var $slider = $('[data-hero-slider]').first();
  if(!$slider.length){
    return;
  }

  var $slides = $slider.find('[data-hero-slide]');
  var $prev = $slider.find('[data-hero-prev]');
  var $next = $slider.find('[data-hero-next]');
  var activeIndex = 0;

  function renderSlide(nextIndex){
    if(!$slides.length){
      return;
    }

    activeIndex = (nextIndex + $slides.length) % $slides.length;
    $slides.removeClass('is-active').attr('aria-hidden', 'true');
    $slides.eq(activeIndex).addClass('is-active').attr('aria-hidden', 'false');
  }

  $prev.on('click', function(){
    renderSlide(activeIndex - 1);
  });

  $next.on('click', function(){
    renderSlide(activeIndex + 1);
  });

  renderSlide(0);
});
