setTimeout(function(){
  $('#wrapper').fadeOut();
  // $('.swiper-container-pics').fadeIn();
  bannerSwiper = new Swiper ('.swiper-container-pics', {
    	autoplay: 5000,
    	slidesPerView: 'auto',
    	loop: true
  });
}, 2000);