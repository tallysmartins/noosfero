/* globals modulejs */

modulejs.define('InstitutionModal',
    ['jquery', 'NoosferoRoot', 'CreateInstitution', 'ModalObserver'],
    function($, NoosferoRoot, CreateInstitution, ModalObserver)
{
  'use strict';

  var AJAX_URL = {
    create_institution_modal:
      NoosferoRoot.urlWithSubDirectory("/plugin/gov_user/create_institution"),
  };

  // When the modal is closed, put the community name into the autocomplete
  function observer_action() {
    var community_name = $("#community_name").val();
    $("#input_institution").attr("value", community_name).autocomplete("search");

    // Clear error messages
    $("#create_institution_errors").html("");
  }

  // Observe when modal is closed
  function observe_modal() {
    var institution_modal = document.querySelector("#institution_modal");
    ModalObserver.init(institution_modal, observer_action);
  }


  function prepare_institution_modal() {
    $.get(AJAX_URL.create_institution_modal, function(response){
      window.sessionStorage.setItem("InstitutionModalBody", response);
      $("#institution_modal_body").html(response);

      // Set all events on modal
      CreateInstitution.init();
    });

    $("#create_institution_link").click(observe_modal);
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

