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

  function add_software_on_control_panel(control_panel) {
    var software_link = jQuery(".control-panel-software-link").remove();

    if( software_link.size() > 0 ) {
      control_panel.prepend(software_link);
    }
  }

  function add_institution_on_control_panel(control_panel) {
    var institution_link = jQuery(".control-panel-instituton-link").remove();

    if( institution_link.size() > 0 ) {
      control_panel.prepend(institution_link);
    }
  }

  function add_itens_on_controla_panel() {
    var control_panel = jQuery(".control-panel");

    if( control_panel.size() > 0 ) {
      add_software_on_control_panel(control_panel);
      add_institution_on_control_panel(control_panel);
    }
  }

  jQuery(document).ready(function(){
    add_itens_on_controla_panel();
    hide_infos();
  });
})();