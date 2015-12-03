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
    var organization_rating_saved_value = $("#organization_rating_saved_value");
    var organization_rating_people_benefited = $("#organization_rating_people_benefited");
    var people_benefited_tmp = $("#people_benefited_tmp");
    var saved_value_tmp = $("#saved_value_tmp");

    saved_value_tmp.mask("#.##0,00", {reverse: true});
    people_benefited_tmp.mask("000.000.000", {reverse: true});

    organization_rating_saved_value.closest("form").submit(function( event ) {
        var unformated_saved_value = saved_value_tmp.val();
        unformated_saved_value = unformated_saved_value.split(".").join("");
        unformated_saved_value = unformated_saved_value.replace(",",".");
        organization_rating_saved_value.val(unformated_saved_value);

        var unformated_people_benefited = people_benefited_tmp.val();
        unformated_people_benefited = unformated_people_benefited.split(".").join("");
        organization_rating_people_benefited.val(unformated_people_benefited);
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
