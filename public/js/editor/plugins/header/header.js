KindEditor.plugin('header', function(K) {
    var editor = this, name = 'header';
    // 点击图标时执行
    editor.clickToolbar(name, function() {
    	var html = editor.selectedHtml();
    	if (html) {
    		var html = '<h3>'+ editor.selectedHtml()+'</h3>';
        	editor.insertHtml(html);
    	}
   		
    });
});