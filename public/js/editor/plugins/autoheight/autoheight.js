/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/

KindEditor.plugin('autoheight', function(K) {
	var self = this;

	if (!self.autoHeightMode) {
		return;
	}

	var edit = self.edit;
	var body = edit.doc.body;console.log(body);
	var minHeight = K.removeUnit(self.height);
	// var preHeight;

	edit.iframe[0].scroll = 'no';
	body.style.overflowY = 'hidden';
	// body.style.height = 'auto';

	edit.afterChange(function() {
		// var bodyHeight = K.removeUnit(body.style.height);
		self.resize(null, Math.max((K.IE ? body.scrollHeight : body.offsetHeight) + 49, minHeight));
		// console.log("change", (K.IE ? body.scrollHeight : body.offsetHeight));
		// console.log(body.offsetHeight);
		// preHeight = K.IE ? body.scrollHeight : body.offsetHeight;
	});
});
