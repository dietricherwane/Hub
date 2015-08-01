$(document).on('ready page:load', function(){
  $(this).disableButtons("#qualify_icon");
});

$.fn.disableButtons = function(buttonId) {
  $(buttonId).click(function(){
    $(buttonId).hide();
  });
}
