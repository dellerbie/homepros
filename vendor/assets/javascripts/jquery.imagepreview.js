/**
Copyright (c) 2012 Longhao Luo, http://www.kindsoft.net/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

(function($) {
	var basePath = (function() {
		var els = document.getElementsByTagName('script'), src;
		for (var i = 0, len = els.length; i < len; i++) {
			src = els[i].src || '';
			if (/jquery\.imagepreview\.js/.test(src)) {
				return src.substring(0, src.lastIndexOf('/') + 1);
			}
		}
		return '';
	})();
	$.imagepreview = function(options) {
		// default options
		var defaults = {
			file : null,
			img : null,
			okImg : basePath + 'images/upload-ok.png',
			maxWidth : 0,
			maxHeight : 0
		};
		options = $.extend(defaults, options);

		var file = $(options.file)[0],
			img = $(options.img)[0],
			preloadImg = $('<img style="position:absolute;top:-9999px;left:-9999px;visibility:hidden;" />').appendTo(document.body)[0],
			blankSrc = $.browser.msie && $.browser.version <= 7 ?
				basePath + 'images/blank.gif' :
				'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==';
		// show image
		function showImg(src, width, height) {
			var ratio = Math.min(1,
				Math.max(0, options.maxWidth) / width || 1,
				Math.max(0, options.maxHeight) / height || 1
			);
			img.style.width = Math.round(width * ratio) + 'px';
			img.style.height = Math.round(height * ratio) + 'px';
			img.src = src;
		}
		// get image size and show image
		function preload(src) {
			if ($.browser.msie && $.browser.version >= 7 && $.browser.version <= 8) {
				preloadImg.src = blankSrc;
				preloadImg.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='image',src=\"" + src + "\")";
				showImg(blankSrc, preloadImg.offsetWidth, preloadImg.offsetHeight);
				img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src=\"" + src + "\")";
			} else {
				preloadImg.onload = function() {
					showImg(src, this.width, this.height);
				};
				preloadImg.src = src;
			}
		}
		// get image data
		function getImgSrc(fn) {
			if ($.browser.msie) {
				if ($.browser.version <= 6) {
					fn(file.value);
					return;
				} else if ($.browser.version <= 8) {
					var src = '';
					file.select();
					try {
						src = document.selection.createRange().text;
					} finally {
						document.selection.empty();
					}
					src = src.replace(/[)'"%]/g, function(s){ return escape(escape(s)); });
					fn(src);
					return;
				}
			}
			if ($.browser.mozilla) {
				var oFile = file.files[0];
				if (oFile.getAsDataURL) {
					fn(oFile.getAsDataURL());
					return;
				}
			}
			try {
				var oFile = file.files[0];
				var oFReader = new FileReader();
				oFReader.onload = function (oFREvent) {
					fn(oFREvent.target.result);
				};
				oFReader.onerror = function(a) {
					fn(options.okImg);
				};
				oFReader.readAsDataURL(oFile);
			} catch(e) {
				fn(options.okImg);
			}
		}
		// preview
		function previewHandler() {
			getImgSrc(function(src) {
				preload(src);
			});
		}
		file.onchange = previewHandler;
	};
})(jQuery);
