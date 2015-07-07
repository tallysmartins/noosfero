modulejs.define('CommentsSoftwareExtraFields', ['jquery'], function($) {
  'use strict';

  var DATA = {
    information_display_state: "hidden"
  }

  function set_show_aditional_information() {
    $(".comments-software-extra-fields span").on("click", function() {
      if (DATA.information_display_state === "hidden") {
        DATA.information_display_state = "show";
        $(this).parent().children("div").show();
      } else {
        DATA.information_display_state = "hidden";
        $(this).parent().children("div").hide();
      }
    });
  }

  return {
    isCurrentPage: function() {
      return $(".comments-software-extra-fields span").length === 1;
    },


    init: function() {
      set_show_aditional_information();
    }
  }
});
