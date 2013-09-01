$(function() {
  if (window.location.href.indexOf("edit") != -1) {
    $(".gift-preview .gift-poster img").show();
    $("#inputPic").removeAttr("datatype");
  }
  var editor = KindEditor.create('#projectdetail',{
    resizeType: 1,
    // width: 'auto',
    height: '300px',
    items : [
    'bold','italic','underline','header','|','media','image'
    ],
    allowFileManager: true,
    uploadJson:"/kindeditor/upload",
    fileManagerJson: "/kindeditor/filemanager"
    // autoHeightMode : true,
    // afterCreate : function() {
    //   this.loadPlugin('autoheight');
    // }
  });

  $("#tags").tagsManager({
    maxTags: 5,
    hiddenTagListName: 'keywords',
    typeahead: true,
    typeaheadAjaxSource: "/blog/articles/gettaglist",
    typeaheadAjaxPolling: true,
    prefilled: $('input[name="keywords"]').val()
  });
  $(".control-group .tags-suggestion a").click(function(){
    var val = $(this).html();
    $("#tags").tagsManager('pushTag',val);
  });

  $("form").Validform({
    tiptype : function(msg,o,cssctl){
      if (o.type==3) {
        var $tips = o.obj.siblings(".error-block");
        if ($tips.length == 0) {
          var span = $("<span>").addClass("error-block").html(msg);
          o.obj.after(span);
        } else {
          $tips.html(msg);
        }
      }
    }
  });

  $('.control-group').on("keypress","input",function(event){
    if (event.which == 13) {
      $(this).blur();
      return false;
    }
  });
  $('#inputName').keyup(function(){
    var text = $(this).val();
    $('.gift-preview .title').html(text);
  });

  $('#selectStage').change(function(){
    var selection = $(this).val();
    $('.gift-preview .label').removeClass().addClass("label label-"+selection);
  });

  // NOT IE
  $('#inputPic').change(function(){
    var $img = $('.gift-preview .gift-poster img');
    if ($(this).val()) {
      $img.show();
      var file = $(this)[0].files[0];
      var reader = new FileReader();
      reader.onload = function(evt){
        $img.attr("src", evt.target.result);
      };
      reader.readAsDataURL(file);
    } else {
      $img.hide();
    }
  });

  $('#searchname').autocomplete({
    source:function(query, process) {
      $.post("/blog/coauthor/getuserlist",{"search":query,"authenticity_token":$('.form-horizontal input[name="authenticity_token"]').val()},function(respData){
        return process(respData);
      });
    },
    formatItem:function(item){
      var img = '<img src="' + (item["avatar"]? item["avatar"]:"") + '">'
      return img + item["name"];
    },
    setValue:function(item){
      return {'data-value':item["name"],'real-value':item["id"],'data-pic':item["avatar"]};
    }
  });
  $(document).on("click",".members>li>.name>.remove",function(){
    var id = $(this).data("remove");
    var $li = $(this).closest("li");
    
    var index = $($li).index();

    var list = $('input[name="users"]').val();
    var list_array = list.split(",");
    list_array.splice(index,1);
    var newlist = list_array.join(",");
    $('input[name="users"]').val(newlist);
    $li.remove();
    return false;
  });
});
