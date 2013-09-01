$(function(){
  // profile init
  $('body').scrollspy();
  
  $(window).scroll(function(){
    if ($(this).scrollTop() != 0)
      $(".content .profile-nav").addClass("fixed-top")
    else 
      $(".content .profile-nav").removeClass("fixed-top")
  });


  // $('.profile-header .details .detail-item .edit').click(function(){
  //   $(this).siblings('.edit-input').show().focus();
  // });
  // $('.profile-header .details .detail-item .edit-input').blur(function(){
  //   var val = $(this).val();
  //   $(this).hide()
  //   .siblings('p').html(val);
  // });

  // profile contact
  $("ul.contact li").each(function(i,obj){
    // var $a = $(obj).find("a");
    var $span = $(obj).find("span");
    // if (($a.attr("href") != "#") || (!$span.html()))
    //   $(obj).find("i").addClass("light"); 
    $(obj).click(function(){
      if ($span.html()) {
        $span.toggle();
        return false;
      }
    });
  });

  $('#inputImg').change(function(){
    var $img = $('.uploadavatar img');
    if ($(this).val()) {
      $(".uploadavatar span").hide();
      $img.show();
      var file = $(this)[0].files[0];
      var reader = new FileReader();
      reader.onload = function(evt){
        $img.attr("src", evt.target.result);
      };
      reader.readAsDataURL(file);
    } else {
      $img.attr("src","");
      $(".uploadavatar span").show();
    }
  });
  $.each($('.contact input[type="text"]'),function(i,obj){
    if ($(obj).val()) 
      $(obj).siblings(".add-on").find("i").addClass("light");
  });
  $('.contact input[type="text"]').change(function(){
    if ($(this).val()) 
      $(this).siblings(".add-on").find("i").addClass("light");
    else
      $(this).siblings(".add-on").find("i").removeClass("light");
  });
});