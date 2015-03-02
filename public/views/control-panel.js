modulejs.define('ControlPanel', ['jquery'], function($) {
  function hide_infos(){
    $(".language-info").hide();
    $(".database-info").hide();
    $(".libraries-info").hide();
    $(".operating-system-info").hide();
    $(".language-button-hide").hide();
    $(".database-button-hide").hide();
    $(".libraries-button-hide").hide();
    $(".operating-system-button-hide").hide();
  }


  function add_software_on_control_panel(control_panel) {
    var software_link = $(".control-panel-software-link").remove();

    if( software_link.size() > 0 ) {
      control_panel.prepend(software_link);
    }
  }


  function add_institution_on_control_panel(control_panel) {
    var institution_link = $(".control-panel-instituton-link").remove();

    if( institution_link.size() > 0 ) {
      control_panel.prepend(institution_link);
    }
  }


  function add_itens_on_controla_panel() {
    var control_panel = $(".control-panel");

    if( control_panel.size() > 0 ) {
      add_software_on_control_panel(control_panel);
      add_institution_on_control_panel(control_panel);
    }
  }


  return {
    isControlPanel: function() {
      return $("#profile-editor-index").length === 1;
    },


    init: function() {
      add_itens_on_controla_panel();
      hide_infos();
    }
  }
});
