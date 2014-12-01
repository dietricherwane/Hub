// PROTEUS responsive Theme Copyright © 2013
// www.creativusmouse.com

// --------- JS SCRIPTS ---------

// -- 1. SUPERFISH MENU OPACITY
// -- 2. FORM VALIDATION
// -- 3. TABS
// -- 4. ACCORDIONS
// -- 5. TOGGLES
// -- 6. SCROLL TO TOP
// -- 7. MOBILE MENU
// -- 8. INFIELD LABELS
// -- 9. TITAN LIGHTBOX


/*----------------------------------------------------------
     1.   S U P E R F I S H    O P A C I T Y
-----------------------------------------------------------*/
$(document).ready(function(){
$(".sf-menu li a").fadeTo("slow", 1.0); // This sets the opacity of the thumbs to fade down to 100% when the page loads

	$(".accordion-style-2 .acc_trigger span, .toggle-style-2 .tgg-trigger span,  .full_width_home a img, .FilterableItem img").hover(function(){
		$(this).fadeTo("slow", 0.6); // This should set the opacity to 60% on hover
	},function(){
   		$(this).fadeTo("slow", 1.0); // This should set the opacity back to 100% on mouseout
	});


/*-----------------------------------------------
	  2.   F O R M   V A L I D A T I O N
------------------------------------------------*/
$('form#contact_form').submit(function() {
	$('form#contact_form .error').remove();
	var hasError = false;
	$('.requiredField').each(function() {
		if(jQuery.trim($(this).val()) == '') {
			var labelText = $(this).prev('label').text();
			$(this).parent().append('<span class="error">Required</span>');
			$(this).addClass('inputError');
			hasError = true;
		} else if($(this).hasClass('email')) {
			var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
			if(!emailReg.test(jQuery.trim($(this).val()))) {
				var labelText = $(this).prev('label').text();
				$(this).parent().append('<span class="error">Invalid.</span>');
				$(this).addClass('inputError');
				hasError = true;
			}
		}
	});
	if(!hasError) {
		$('form#contact_form input.submit').fadeOut('normal', function() {
			$(this).parent().append('');
		});
		var formInput = $(this).serialize();
		$.post($(this).attr('action'),formInput, function(data){
			$('form#contact_form').slideUp("fast", function() {
				$(this).before('<p class="success">Thanks! Your email was successfully sent. We will contact you as soon as possible.</p>');
			});
		});
	}

	return false;

	});


//process the contact form
	$('#submit-form').click(function(){
		var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
		var names  = $('#contact-form [name="contact-names"]').val();
		var email_address = $('#contact-form [name="contact-email"]').val();
		var subject_address = $('#contact-form [name="contact-subject"]').val();
		var comment  = $.trim($('#contact-form #message').val());
		var data_html ='' ;

		if(names == ""){
			$('.name-required').html('Please enter your name.');
		}else{
			$('.name-required').html('');
		}
		if(email_address == ""){
			$('.email-required').html('Your email is required.');
		}else if(reg.test(email_address) == false){
			$('.email-required').html('Invalid Email Address.');
		}else{
			$('.email-required').html('');
		}

		if(comment == ""){
			$('.comment-required').html('Comment is required.');
		}else{
			$('.comment-required').html('');
		}

		if(comment != "" && names != "" && reg.test(email_address) != false) {
			data_html = "names="+ names + "&comment=" + comment + "&email_address="+ email_address;
			//alert(data_html);
			$.ajax({
				type: 'POST',
				url: 'php-includes/contact_send.php',
				data: data_html,
				success: function(msg){
					if (msg == 'sent'){
						$('#success').html('<div class="success">Message sent!</div>')  ;
						$('#contact-form [name="contact-names"]').val('');
						$('#contact-form [name="contact-email"]').val('');
						$('#contact-form [name="contact-subject"]').val('');
						$('#contact-form #message').val('');
					}else{
						$('#success').html('<div class="error">Mail Error. Please Try Again!</div>')  ;
					}
				}
			});

		}
		return false;
	});



/*-----------------------------------------------
				3.   T A B S
------------------------------------------------*/
$("#simple-tabs .tab_content").hide(); //Hide all content
$("#simple-tabs ul.tabs li:first").addClass("active").show(); //Activate first tab
$("#simple-tabs .tab_content:first").show(); //Show first tab content

//On Click Event
$("#simple-tabs ul.tabs li").click(function(e) {
	$("#simple-tabs ul.tabs li").removeClass("active"); //Remove any "active" class
	$(this).addClass("active"); //Add "active" class to selected tab
	$("#simple-tabs .tab_content").hide(); //Hide all tab content
	var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
	$(activeTab).fadeIn(); //Fade in the active content
	e.preventDefault();
});


/*-----------------------------------------------
			4.   A C C O R D I O N S
------------------------------------------------*/
$('.acc_container').hide(); //Hide/close all containers

// if you want to show the first div uncomment the line below  <-- read this
//Add "active" class to first trigger, then show/open the immediate next container
//$('.acc_trigger:first').addClass('active').next().show();

// Remove every previously attached event
$(".acc_trigger").off("click");

$('.acc_trigger').click(function(e){
	if( $(this).next().is(':hidden') ) { //If immediate next container is closed...
		$('.acc_trigger').removeClass('active').next().slideUp(); //Remove all "active" state and slide up the immediate next container
		$(this).toggleClass('active').next().slideDown(); //Add "active" state to clicked trigger and slide down the immediate next container
	} else {
		$('.acc_trigger').removeClass('active').next().slideUp(); //Remove all "active" state and slide up the immediate next container
	}
	e.preventDefault(); //Prevent the browser jump to the link anchor
});



/*-----------------------------------------------
			5.   T O G G L E S
------------------------------------------------*/
//Hide (Collapse) the toggle containers on load
$(".toggle_container").hide();

// Remove every previously attached event
$(".tgg-trigger").off("click");

//Switch the "Open" and "Close" state per click then slide up/down (depending on open/close state)
$(".tgg-trigger").click(function(){
	$(this).toggleClass("active").next().slideToggle("slow");
	return false; //Prevent the browser jump to the link anchor
});



/*------------------------------------------------
		 6.   S C R O L L   T O   T O P
-------------------------------------------------*/
var scrolltotop={
	//startline: Integer. Number of pixels from top of doc scrollbar is scrolled before showing control
	//scrollto: Keyword (Integer, or "Scroll_to_Element_ID"). How far to scroll document up when control is clicked on (0=top).
	setting: {startline:120, scrollto: 0, scrollduration:1000, fadeduration:[500, 100]},
	controlHTML: '<img src="/assets/totop-arrow.png" style="width:30px; height:30px; z-index:9999;" />', //HTML for control, which is auto wrapped in DIV w/ ID="topcontrol"
	controlattrs: {offsetx:20, offsety:10}, //offset of control relative to right/ bottom of window corner
	anchorkeyword: '#top', //Enter href value of HTML anchors on the page that should also act as "Scroll Up" links

	state: {isvisible:false, shouldvisible:false},

	scrollup:function(){
		if (!this.cssfixedsupport) //if control is positioned using JavaScript
			this.$control.css({opacity:0}) //hide control immediately after clicking it
		var dest=isNaN(this.setting.scrollto)? this.setting.scrollto : parseInt(this.setting.scrollto)
		if (typeof dest=="string" && jQuery('#'+dest).length==1) //check element set by string exists
			dest=jQuery('#'+dest).offset().top
		else
			dest=0
		this.$body.animate({scrollTop: dest}, this.setting.scrollduration);
	},

	keepfixed:function(){
		var $window=jQuery(window)
		var controlx=$window.scrollLeft() + $window.width() - this.$control.width() - this.controlattrs.offsetx
		var controly=$window.scrollTop() + $window.height() - this.$control.height() - this.controlattrs.offsety
		this.$control.css({left:controlx+'px', top:controly+'px'})
	},

	togglecontrol:function(){
		var scrolltop=jQuery(window).scrollTop()
		if (!this.cssfixedsupport)
			this.keepfixed()
		this.state.shouldvisible=(scrolltop>=this.setting.startline)? true : false
		if (this.state.shouldvisible && !this.state.isvisible){
			this.$control.stop().animate({opacity:1}, this.setting.fadeduration[0])
			this.state.isvisible=true
		}
		else if (this.state.shouldvisible==false && this.state.isvisible){
			this.$control.stop().animate({opacity:0}, this.setting.fadeduration[1])
			this.state.isvisible=false
		}
	},

	init:function(){
		jQuery(document).ready(function($){
			var mainobj=scrolltotop
			var iebrws=document.all
			mainobj.cssfixedsupport=!iebrws || iebrws && document.compatMode=="CSS1Compat" && window.XMLHttpRequest //not IE or IE7+ browsers in standards mode
			mainobj.$body=(window.opera)? (document.compatMode=="CSS1Compat"? $('html') : $('body')) : $('html,body')
			mainobj.$control=$('<div id="topcontrol">'+mainobj.controlHTML+'</div>')
				.css({position:mainobj.cssfixedsupport? 'fixed' : 'absolute', bottom:mainobj.controlattrs.offsety, right:mainobj.controlattrs.offsetx, opacity:0, cursor:'pointer'})
				.attr({title:'Scroll Back to Top'})
				.click(function(){mainobj.scrollup(); return false})
				.appendTo('body')
			if (document.all && !window.XMLHttpRequest && mainobj.$control.text()!='') //loose check for IE6 and below, plus whether control contains any text
				mainobj.$control.css({width:mainobj.$control.width()}) //IE6- seems to require an explicit width on a DIV containing text
			mainobj.togglecontrol()
			$('a[href="' + mainobj.anchorkeyword +'"]').click(function(){
				mainobj.scrollup()
				return false
			})
			$(window).bind('scroll resize', function(e){
				mainobj.togglecontrol()
			})
		})
	}
}

scrolltotop.init()


/*------------------------------------------------
		 7.   M O B I L E   M E N U
------------------------------------------------*/
$('#mobile-menu').change(function() {
  window.location = $(this).val();
});


/*--------------------------------------------------------
	       8.   I N F I E L D   L A B E L S
---------------------------------------------------------*/
$(document).ready(function(){
$(".infield label").inFieldLabels();
});



/*-------------------------------------------------------
 9.  T I T A N   L I G H T B O X
--------------------------------------------------------*/
$(document).ready(function($) {
		$('.titan-lb').lightbox({
			'scrolling': 'auto',
			theme: 'default'
		});
		 prettyPrint();
	});
});

// Overlay

    $(document).ready(function(){
    $(".image-overlay .overlay-icon").fadeTo("fast", 0); // This sets the opacity of the thumbs to fade down to 60% when the page loads

    $(".image-overlay .overlay-icon").hover(function(){
    $(this).fadeTo("fast", 0.8); // This should set the opacity to 100% on hover
    },function(){
    $(this).fadeTo("fast", 0); // This should set the opacity back to 60% on mouseout
    });
    });
