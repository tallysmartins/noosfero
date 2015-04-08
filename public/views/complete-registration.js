modulejs.define('CompleteRegistration', ['jquery', 'NoosferoRoot'], function($, NoosferoRoot) {
  'use strict';


  var AJAX_URL = {
    hide_registration_incomplete_percentage:
    NoosferoRoot.urlWithSubDirectory("/plugin/software_communities/hide_registration_incomplete_percentage")
  };


  function hide_incomplete_percentage(evt) {
    evt.preventDefault();

    jQuery.get(AJAX_URL.hide_registration_incomplete_percentage, {hide:true}, function(response){
      if( response === true ) {
        jQuery("#complete_registration").fadeOut();
      }
    });
  }


  function show_complete_progressbar() {
    var percentage = jQuery("#complete_registration_message span").html();
    var canvas_tag = document.getElementById("complete_registration_percentage");

    if( canvas_tag !== null ) {
      var context = canvas_tag.getContext("2d");

      percentage = canvas_tag.width*(percentage/100.0);

      context.beginPath();
      context.rect(0, 0, percentage, canvas_tag.height);
      context.fillStyle = '#00FF00';
      context.fill();
    }
  }


  function repositioning_bar_percentage() {
    var complete_message = $("#complete_registration").remove();

    $(".profile-info-options").before(complete_message);
  }


  return {
    isCurrentPage: function() {
      return $("#complete_registration").length === 1;
    },


    init: function() {
      repositioning_bar_percentage();

      jQuery(".hide-incomplete-percentage").click(hide_incomplete_percentage);

      show_complete_progressbar();
    }
  }
});
