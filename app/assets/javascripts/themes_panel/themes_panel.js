$.cookie = function(name, value, options) {
    if (typeof value != 'undefined') {
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString();
        }
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else {
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};

function on_change_color(color){
	jQuery('body').css('background-color', color);
	jQuery('#color').attr('value', color);
	
	/*$(".ca-menu li").mouseover(function(){$(this).css('background-color', color);});	
	
	$(".ca-menu li").mouseout(function(){$(this).css('background-color', 'transparent', color);});
	
	$(".bluegrey").mouseover(function(){$(this).css('background-color', '#CCC', color);});
	$(".bluegrey").mouseout(function(){$(this).css('background-color', color);});*/
	
	$.cookie('bgcolor',color,{ expires: 0, path: '/'});
}


jQuery(function(){
	
	
	/* Fix for reset button color
	----------------------------------------------------------*/
	jQuery(".reset_btn").css('color', '#555');
	
	
	/* Minor fix for IE9 */
	/*-----------------------------------------------------------------------*/
	if ($.browser.msie && $.browser.version.substr(0,1)==9) {
		jQuery("#color").css('padding','3px 1px 2px 1px');
	}
	
	
	/* Show or hide themes panel
	----------------------------------------------------------*/
	themes_panel_width = jQuery('#themes_menu').outerWidth();
	ofset = 4;
	
	jQuery('#themes_panel').css('left', 0);
	jQuery('#themes_panel').animate({left: -themes_panel_width + ofset}, 400);
	
	jQuery('#toggle_button').click(function() {
		
		/* On hide turn off colorpicker wheel */
		if ($.browser.msie && $.browser.version.substr(0,1)<=8)
			jQuery('#colorpicker').hide();
		else
			jQuery('#colorpicker').fadeOut('fast');
		
		var themes_panel = jQuery(this).parent();
		themes_panel.animate({
		  left: parseInt(themes_panel.css('left'),10) == 0 ? -themes_panel_width + ofset : 0
		}, 400);
		
		return false;
	});
	
	
	/* If cookie exists, apply classes from cookie
	----------------------------------------------------------*/
	if ($.cookie('theme') != null)	{
		$.cookie('theme',$.cookie('theme'),{ expires: 0, path: '/'});
		jQuery('body').removeAttr('id').attr('id',$.cookie('theme'));
	}
	
	if ($.cookie('pattern') != null)	{
		$.cookie('pattern',$.cookie('pattern'),{ expires: 0, path: '/'});
		jQuery('body').removeClass('').addClass($.cookie('pattern'));
	}
	
	if ($.cookie('bgcolor') != null)	{
		$.cookie('bgcolor',$.cookie('bgcolor'),{ expires: 0, path: '/'});
		jQuery('body, #color').css('background-color', $.cookie('bgcolor'));
		jQuery('#color').attr('value', $.cookie('bgcolor'));
	}
	
	
	/* Farbtastic
	----------------------------------------------------------*/
	jQuery('#colorpicker').hide();
	var farbtastic = jQuery.farbtastic('#colorpicker');
	
	farbtastic.linkTo('#color');
	farbtastic.linkTo(on_change_color);
	
	jQuery('.farbtastic').append('<a class="close_colorpicker" href="#"></a>');
	
	
	/* Show or hide colorpicker
	----------------------------------------------------------*/
	jQuery('a.pick_color_btn, a.close_colorpicker').click(function() {
		var color_picker = jQuery('#colorpicker');
		
		if(color_picker.css('display') == 'none'){
			 jQuery('#colorpicker').fadeIn(300);
		} else {
			 if ($.browser.msie && $.browser.version.substr(0,1)<=8)
				jQuery('#colorpicker').hide();
			else
				jQuery('#colorpicker').fadeOut('fast');
		}
		return false;
	});
	
	
	/* Change theme colors on click and set cookie
	----------------------------------------------------------*/
	jQuery('#themes_panel ul.theme.buttons li a').click(function(){
		var theme_name = jQuery(this).attr('title');
		
		$.cookie('theme', theme_name, { expires: 0, path: '/'});
		jQuery('body').removeAttr('id').attr('id',theme_name);
		
	  	return false;
    });
	
	
	/* Change pattern on click and set cookie
	----------------------------------------------------------*/
	jQuery('#themes_panel ul.pattern.buttons li a').click(function(){
		var pattern_name = jQuery(this).attr('title');
		
		$.cookie('pattern', pattern_name, { expires: 0, path: '/'});
		jQuery('body').removeClass().addClass(pattern_name);
		
	  	return false;
    });
	
	
	/* Reset to Default
	----------------------------------------------------------*/
	jQuery('.reset_btn').click(function(){
		$.cookie('theme', null, { expires: 0, path: '/'});
		$.cookie('pattern', null, { expires: 0, path: '/'});
		$.cookie('bgcolor', '#F6F6F6', { expires: 0, path: '/'});
		location.reload();
	});
	
});