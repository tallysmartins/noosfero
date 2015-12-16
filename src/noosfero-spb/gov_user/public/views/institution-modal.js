/* globals modulejs */

modulejs.define('InstitutionModal',
    ['jquery', 'NoosferoRoot', 'CreateInstitution'],
    function($, NoosferoRoot, CreateInstitution)
{
  'use strict';

  var AJAX_URL = {
    create_institution_modal:
      NoosferoRoot.urlWithSubDirectory("/plugin/gov_user/create_institution"),
  };

  // Get the modal html code and prepare it
  function prepare_institution_modal() {
    $.get(AJAX_URL.create_institution_modal, function(response) {
      window.sessionStorage.setItem("InstitutionModalBody", response);
      $("#institution_modal_body").html(response);

      // Set all events on modal
      CreateInstitution.init();
    });
  }


  return {
    isCurrentPage: function() {
      return $("#institution_modal_container").length === 1;
    },


    init: function() {
      prepare_institution_modal();
    },
  };
});

