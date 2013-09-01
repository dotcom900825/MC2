$(function(){
  // show init
  // if ($(".sidenav .follow a").hasClass("followed"))
  //   $('.sidenav a[href="#tweets"]').tab('show');
  $('#project .morefeeds a').click(function(){
    $('.sidenav a[href="#tweets"]').tab('show');
  });
  $("#gift .actions li .share").click(function(){
    $(this).closest("li").siblings("li.share-tool").toggle();
    return false;
  });

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

  $('#project .detail a').attr("target","_blank");
  
  $("#modal .feed-category .btn").click(function(){
    var category_val = $(this).data("value");
    $(this).button('toggle');
    $('#modal .flash').hide();
    $('input[name="article[category_id]"]').val(category_val);
    $('#modal #inputContribute, #modal #inputName').hide().removeAttr("name");
    if ($(this).data("value") == 8) {
      $('#modal #inputContribute').show().focus().attr("name","article[title]");
    } else {
      removeContributor();
      $('#modal #inputName').show().focus().attr("name","article[title]");
    }
    return false;
  });
  var removeContributor = function(){
    $('input[name="users"]').val("");
    $('.newtweet-title>span').remove();
    $('#inputContribute').val("");
    $('input[name="article[title]"]').val("");
  }
  // input Contributor
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
    removeContributor();
    $('#inputContribute').show();
    return false;
  });

  $('.tweet-tool').click(function(){
    var title = $(this).attr('title');
    $('.modal .modal-header h4').html(title);
  });

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

  // show modal
  var editor = KindEditor.create('#modal-editor',{
    resizeType: 1,
    width: '100%',
    height: '400px',
    items : [
    'bold','italic','underline','header','|','media','image'
    ],
    allowFileManager: true,
    uploadJson:"/kindeditor/upload",
    fileManagerJson: "/kindeditor/filemanager",
    allowMediaUpload: false,
    allowFileManager: false,
    allowImageRemote: false,
    pasteType: 1
    // autoHeightMode : true,
    // afterCreate : function() {
    //   this.loadPlugin('autoheight');
    // }
  });

  // feed comment
  $('.comments .comment-number').click(function(){
    $('.comments .comment-wrap').slideToggle();
    return false;
  });

  // modal
  $('form').submit(function(e){
    if ($('#modal input[name="article[category_id]"]').val() == "8" ) {
      if (!$('.modal input[name="users"]').val()) {
        $('.modal .flash').show();
        $('.modal .flash .error').html("请输入贡献者名字").show();
        return false
      }
    } else {
      if (!$('.modal input[name="article[title]"]').val()) {
        $('.modal .flash').show();
        $('.modal .flash .error').html("请输入标题").show();
        return false
      }
    }
    return true
  });
});
