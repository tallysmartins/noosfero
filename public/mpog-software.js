(function(){
  function hide_infos(){
    jQuery(".language-info").hide();
    jQuery(".database-info").hide();
    jQuery(".libraries-info").hide();
    jQuery(".operating-system-info").hide();
    jQuery(".language-button-hide").hide();
    jQuery(".database-button-hide").hide();
    jQuery(".libraries-button-hide").hide();
    jQuery(".operating-system-button-hide").hide();
  }

  function add_software_on_control_panel() {
    if(jQuery(".control-panel").size() > 0 && jQuery(".control-panel-edit-profile-group:contains('Software')").size() > 0 ) {
      jQuery(".control-panel")[0].innerHTML = jQuery(".control-panel-edit-profile-group:contains('Software')")[0].outerHTML + jQuery(".control-panel")[0].innerHTML
      jQuery(".control-panel-edit-profile-group:contains('Software')")[1].remove();
    }
  }

  jQuery(document).ready(function(){
    add_software_on_control_panel();
    hide_infos();
  });
})();