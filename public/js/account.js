$(function(){
  // ajax
  $("#signupform").Validform({
    tiptype : function(msg,o,cssctl){
      if (o.type==3) {
        $("#signupflash .error")
          .html(msg);
        $("#signupflash").show();
      }
    },
    ajaxPost:true,
    callback : function(data){
      if (data == false) {
        $("#signupflash .error")
          .html('该邮箱已注册，<a href="#login">直接登录</a>')
        $("#signupflash").show();
      } else {
        if (data.status==200) {
          var username = $('input[name="user[firstname]"]').val() + $('input[name="user[secondname]"]').val();
          $("#editprofile .username").html(username);
          $(".row-fluid").hide();
          $("#editprofile").show();
        }
      }
    }
  });
  // $("#editprofileform").Validform({
  //   tiptype : function(msg,o,cssctl){
  //   },
  //   ajaxPost:true,
  //   callback : function(data){
  //     window.location.href="/";
  //   }
  // });
  $("#loginform").Validform({
    tiptype : function(msg,o,cssctl){
      console.log(msg,o);
      if (o.type==3) {
        $("#loginflash .error")
          .html(msg);
        $("#loginflash").show();
      }
    },
    ajaxPost:true,
    callback : function(data){
      if (data == false) {
        $("#loginflash .error")
          .html('用户或密码错误')
        $("#loginflash").show();
      } else {
        var url = $("#loginform").find('input[type="submit"]').data("url");
        if (url.indexOf("account") >= 0) {
          url = "/"
        }
        window.location.href = url;
      }
    }
  });

  // init
  var hash = location.hash.substring(1);
  if (hash == "login") $("#signup,#login").toggle();
  $("#signup .gotologin,#login .gotosignup").click(function(){
    $("#signup,#login").toggle();
    return false
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

  $('.contact input[type="text"]').change(function(){
    if ($(this).val()) 
      $(this).siblings(".add-on").find("i").addClass("light");
  });
});