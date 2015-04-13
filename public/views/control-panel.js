modulejs.define('ControlPanel', ['jquery'], function($) {
  'use strict';

  function add_software_on_control_panel(control_panel) {
    var software_link = $(".control-panel-software-link").remove();

    if( software_link.size() > 0 ) {
      control_panel.prepend(software_link);
    }
  }

  function add_itens_on_controla_panel() {
    var control_panel = $(".control-panel");

    if( control_panel.size() > 0 ) {
      add_software_on_control_panel(control_panel);
    }
  }


  return {
    isCurrentPage: function() {
      return $("#profile-editor-index").length === 1;
    },


    init: function() {
      add_itens_on_controla_panel();
    }
  }
});
