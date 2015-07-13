modulejs.define("GovUserCommentsExtraFields", ['jquery','CreateInstitution'], function($,CreateInstitution) {

    function set_events() {
      CreateInstitution.institution_autocomplete();
    }


    function prepend_to_aditional_information() {
      var aditional_information = $(".comments-software-extra-fields");
      var institution_comments = $("#input_institution_comments");

      aditional_information.prepend(institution_comments.remove());
    }


    return {
      isCurrentPage: function() {
        return $(".star-rate-form").length === 1;
      },

      init: function() {
        prepend_to_aditional_information();
        set_events();
      }
    }

})
