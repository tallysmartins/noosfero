jQuery(document).ready(function(){
  jQuery(".control-panel")[0].innerHTML = jQuery(".control-panel-edit-profile-group:contains('Software')")[0].outerHTML + jQuery(".control-panel")[0].innerHTML
  jQuery(".control-panel-edit-profile-group:contains('Software')")[1].remove()
});