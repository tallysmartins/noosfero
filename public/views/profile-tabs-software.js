modulejs.define("ProfileTabsSoftware", ["jquery"], function($) {
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


  function set_show_hide_dynamic_table_events() {
    $(".language-button-hide").click(function(event){
      event.preventDefault();
      $(".language-info").hide();
      $(".language-button-show").show();
      $(".language-button-hide").hide();
    });

    $(".language-button-show").click(function(event){
      event.preventDefault();
      $(".language-info").show();
      $(".language-button-show").hide();
      $(".language-button-hide").show();
    });

    $(".operating-system-button-hide").click(function(event){
      event.preventDefault();
      $(".operating-system-info").hide();
      $(".operating-system-button-show").show();
      $(".operating-system-button-hide").hide();
    });

    $(".operating-system-button-show").click(function(event){
      event.preventDefault();
      $(".operating-system-info").show();
      $(".operating-system-button-show").hide();
      $(".operating-system-button-hide").show();
    });

    $(".database-button-hide").click(function(event){
      event.preventDefault();
      $(".database-info").hide();
      $(".database-button-show").show();
      $(".database-button-hide").hide();
    });

    $(".database-button-show").click(function(event){
      event.preventDefault();
      $(".database-info").show();
      $(".database-button-show").hide();
      $(".database-button-hide").show();
    });

    $(".libraries-button-hide").click(function(event){
      event.preventDefault();
      $(".libraries-info").hide();
      $(".libraries-button-show").show();
      $(".libraries-button-hide").hide();
    });

    $(".libraries-button-show").click(function(event){
      event.preventDefault();
      $(".libraries-info").show();
      $(".libraries-button-show").hide();
      $(".libraries-button-hide").show();
    });
  }


  return {
    isCurrentPage: function() {
      return $("#software-fields").length === 1;
    },


    init: function() {
      hide_infos();
      set_show_hide_dynamic_table_events();
    }
  }
});
