(function() {
  var AJAX_URL = {
    hide_registration_incomplete_percentage:
      url_with_subdirectory("/plugin/mpog_software/hide_registration_incomplete_percentage")
  };


  function hide_incomplete_percentage(evt) {
    evt.preventDefault();

    jQuery.get(AJAX_URL.hide_registration_incomplete_percentage, {hide:true}, function(response){
      if( response == true )
        jQuery("#complete_registration").fadeOut();
    });
  }

  function show_complete_progressbar() {
    var percentage = jQuery("#complete_registration_message span").html();
    var canvas_tag = document.getElementById("complete_registration_percentage");

    if( canvas_tag != null ) {
      var context = canvas_tag.getContext("2d");

      percentage = canvas_tag.width*(percentage/100.0);

      context.beginPath();
      context.rect(0, 0, percentage, canvas_tag.height);
      context.fillStyle = '#00FF00';
      context.fill();
    }
  }

  jQuery(document).ready(function(){
    jQuery(".hide-incomplete-percentage").click(hide_incomplete_percentage);

    show_complete_progressbar();
  });
})();