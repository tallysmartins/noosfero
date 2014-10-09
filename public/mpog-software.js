jQuery(document).ready(function(){
  if(jQuery(".control-panel").size() > 0 && jQuery(".control-panel-edit-profile-group:contains('Software')").size() > 0 ) {
    jQuery(".control-panel")[0].innerHTML = jQuery(".control-panel-edit-profile-group:contains('Software')")[0].outerHTML + jQuery(".control-panel")[0].innerHTML
    jQuery(".control-panel-edit-profile-group:contains('Software')")[1].remove()
  }
});