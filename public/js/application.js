$(function(){
  // gift.html and gift-edit.html
  if ($('.gift-media .tweet').hasClass('.active')) {
    $('#gift .actions .article-tool').hide();
  } else {     
    $('#gift .actions .tweet-tool').hide();
  }

  $('.gift-media').carousel({interval:false}).on('slide',function(){
    $('#gift .actions .edit').toggle();
    $(window).scrollTop(0);
  });

  // $('.read-more').click(function(){
  //   $(this).hide();
  //   $('.item').css({
  //     'height': 'auto'
  //   });
  //   $('#gift #gift-media').css({
  //     'max-height': '100%',
  //     'height': 'auto',
  //   });
  //   return false
  // });

  // user.html and myprofile.html
  $(window).scroll(function(){
    if ($(this).scrollTop() != 0)
      $(".content .profile-nav").addClass("fixed-top")
    else 
      $(".content .profile-nav").removeClass("fixed-top")
  });

  $('.profile-header .details .detail-item .edit').click(function(){
    $(this).siblings('.edit-input').show().focus();
  });
  $('.profile-header .details .detail-item .edit-input').blur(function(){
    var val = $(this).val();
    $(this).hide()
      .siblings('p').html(val);
  });

  // $('[data-toggle="tooltip"]').tooltip({
  //   // trigger:'manual'
  // });
  // $('.contact li a[data-toggle="tooltip"]').hover(function(){
  //   $('[data-toggle="tooltip"]').tooltip('hide');
  //   $(this).tooltip('show');
  // },function(){
  //   $(this).tooltip('hide');
  // });


  // profile.html
  $("ul.contact li").each(function(i,obj){
    var $a = $(obj).find("a");
    var $span = $(obj).find("span");
    if (($a.attr("href") != "#") || ($span.html()))
      $(obj).find("i").addClass("light"); 
    $(obj).click(function(){
      if ($span.html()) {
        $span.toggle();
        return false;
      }
    });
  })

  // gift-edit.html
  var editor = KindEditor.create('#modal-editor',{
    resizeType: 0,
    width: '100%',
    height: '400px',
    items : [
    'bold','italic','underline','header','|','media','image'
    ]
    // autoHeightMode : true,
    // afterCreate : function() {
    //   this.loadPlugin('autoheight');
    // }
  });

  // $('.tweet-tool').click(function(){
  //   var title = $(this).attr('title');
  //   $('.modal .modal-header h4').html(title);
  // });

  $('.tweet-browse-tool').click(function(){
    $('.modal .feedtitle').val('');
    editor.html('');
    var title = $(this).attr('title');
    $('.modal .modal-header h4').html(title);
    if ($(this).data('category') == 'edit') {
      var feedtitle = $('.tweet-title h3').text().replace(/(^\s*)|(\s*$)/g, "");
      var bodycontent = $('.tweet-body').html()
      $('.modal .feedtitle').val(feedtitle);
      editor.html(bodycontent);
    } else {
      
    }
  });

  // gift-question.html
  $('.comments .comment-number').click(function(){
    $('.comments .comment-wrap').slideToggle();
    return false;
  });

  // gift.html
  $(".sidenav .follow a").click(function(){
    var id = $(this).data("articleid");
    var token = $('meta[name="csrf-token"]').attr('content');
    $.post("/blog/articles/follow/"+id,{id: id,authenticity_token: token},function(data){console.log(data);
      if (data.followed) {
        $(".sidenav .follow a").addClass("followed").html('已关注 <span class="label">' + data.count + '</span>');
      } else {
        $(".sidenav .follow a").removeClass("followed").html('+ 关注 <span class="label">' + data.count + '</span>');
      }
    });
    return false;
  });
  $("#modal .feed-category .btn").click(function(){
    var category_val = $(this).data("value");
    $(this).button('toggle');
    $('input[name="article[category_id]"]').val(category_val);
    $('#modal #inputContribute, #modal #inputName').hide().removeAttr("name");
    if ($(this).data("value") == 8) {
      $('#modal #inputContribute').show().focus().attr("name","article[title]");
    } else {
      $('#modal #inputName').show().focus().attr("name","article[title]");
    }
    return false;
  });
  if ($(".sidenav .follow a").hasClass("followed"))
    $('.sidenav a[href="#tweets"]').tab('show');
  

  // new.html
  // $('#tags').autocomplete({
  //   source:function(query, process) {
  //     $.post("/blog/articles/gettaglist",{"search":query,"authenticity_token":$('.form-horizontal input[name="authenticity_token"]').val()},function(respData){
  //       return process(respData);
  //     });
  //   },
  //   formatItem:function(item){
  //     return item["tag"];
  //   },
  //   setValue:function(item){
  //     return {tag:item["name"]};
  //   },
  //   select: function(item){
  //     var val = this.$menu.find('.active').attr('data-value')
  //     this.$element
  //       .val("").attr("real-value",val)
  //       .change()
  //     this.afterSelect(val,val,null);
  //     return this.hide()
  //   },
  //   afterSelect: function(name,id,img){
  //     var tag = '<span class="tm-tag" id="tag_1"><span>'+ val +'</span><a href="#" class="remove" data-remove=""'>×</a></span>'
  //   }
  // });

  // gift.html
  $('#inputContribute').autocomplete({
    source:function(query, process) {
      $.post("/blog/coauthor/getuserlist",{"search":query,"authenticity_token":$('input[name="authenticity_token"]').val()},function(respData){
        return process(respData);
      });
    },
    formatItem:function(item){
      var img = '<img src="' + (item["avatar"]? item["avatar"]:"") + '">'
      return img + item["name"];
    },
    setValue:function(item){
      return {'data-value':item["name"],'real-value':item["id"],'data-pic':item["avatar"]};
    },
    afterSelect: function(name,id,img){
      // console.log(id,name,img);
      var span = '<span><img src="'+img+'" class="avatar"><span>'+name+'</span><a href="#" class="remove">×</a></span>';
      this.$element.before(span).hide();
      $('input[name="users"]').val(id);
      $('input[name="article[title]"]').val("感谢"+name+"对项目的贡献");
    }
  });
  $(document).on("click","#modal .newtweet-title a.remove",function(){
    var $span = $(this).closest("span");
    $('input[name="users"]').val("");
    $span.remove();
    $('#inputContribute').show();
    return false;
  });
});