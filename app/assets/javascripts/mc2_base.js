(function() {
  $(window).scroll(function() {
    if ($(this).scrollTop() != 0)
      $(".navbar ul.nav, .read-more").hide();
    else
      $(".navbar ul.nav, .read-more").show();
    var scrollBottom = $(this).scrollTop() + $(this).height();
    if (scrollBottom == $(document).height())
      $('.navbar .brand').slideUp();
    else
      $('.navbar .brand').slideDown();
  });

$(".navbar .container").hover(
  function(){
    $(".navbar ul.nav").show();
  },function(){
    if ($(window).scrollTop() != 0)
      $(".navbar ul.nav").hide();
  });

})();
