modulejs.define('CommentsSoftwareExtraFields', ['jquery'], function($) {
  'use strict';

  var DATA = {
    information_display_state: "hidden"
  }

  function set_show_additional_information() {
    $(".comments-display-fields").on("click", function() {
      if (DATA.information_display_state === "hidden") {
        DATA.information_display_state = "show";
        $(".comments-software-extra-fields div").show();
      } else {
        DATA.information_display_state = "hidden";
        $(".comments-software-extra-fields div").hide();
      }
    });
  }

  return {
    isCurrentPage: function() {
      return $(".star-rate-form").length === 1;
    },


    init: function() {
      set_show_additional_information();
    }
  }
});
