modulejs.define("ProfileTabsSoftware", ["jquery", "EditSoftware"], function($, EditSoftware) {
  "use strict";

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


  return {
    isCurrentPage: function() {
      return $("#software-fields").length === 1;
    },


    init: function() {
      hide_infos();

      EditSoftware.init();
    }
  }
});
