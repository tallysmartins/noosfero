modulejs.define("GovUserCommentsExtraFields", ['jquery','CreateInstitution'], function($,CreateInstitution) {

    function set_events() {
      CreateInstitution.institution_autocomplete();
    }


    function prepend_to_additional_information() {
      var additional_information = $("#comments-additional-information");
      var institution_comments = $("#input_institution_comments").remove();

      institution_comments.insertAfter(additional_information);
    }


    return {
      isCurrentPage: function() {
        return $(".star-rate-form").length === 1;
      },

      init: function() {
        prepend_to_additional_information();
        set_events();
      }
    }

})
