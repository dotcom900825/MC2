$(function() {
    $(".actions .close").click(function(){
        $("body").animate({opacity:0})
    })
  var editor = KindEditor.create('.new-comment-content',{
    resizeType: 0,
    width: '100%',
    height: '250px',
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
});
