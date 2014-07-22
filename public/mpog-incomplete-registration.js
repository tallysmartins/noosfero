function hide_incomplete_percentage(evt) {
  evt.preventDefault();

  jQuery.get("/plugin/mpog_software/hide_registration_incomplete_percentage", {hide:true}, function(response){
    if( response == true )
      jQuery("#incomplete_registration").fadeOut();
  });
}


jQuery(document).ready(function(){
  jQuery(".hide-incomplete-percentage").click(hide_incomplete_percentage);
});
