modulejs.define('EditSoftware', ['jquery', 'NoosferoRoot', 'AutoComplete', 'NewSoftware'], function($, NoosferoRoot, AutoComplete, NewSoftware) {
  'use strict';

  var AJAX_URL = {
    get_field_data:
      NoosferoRoot.urlWithSubDirectory("/plugin/software_communities/get_field_data")
  };


  function database_autocomplete() {
    AutoComplete.enable("database", ".database_description_id", ".database_autocomplete", AJAX_URL.get_field_data);
  }


  function language_autocomplete() {
    AutoComplete.enable("software_language", ".programming_language_id", ".language_autocomplete", AJAX_URL.get_field_data);
  }


  function delete_dynamic_table() {
    var button = $(".delete-dynamic-table");

    button.each(function(){
      var table = $(this).parent().parent().parent().parent();
      var color = table.css("background-color");

      $(this).click(function(){
        table.remove();
        return false;
      }).mouseover(function(){
        table.css("background-color", "#eee");
      }).mouseout(function(){
        table.css("background-color", color);
      });
    });
  }


  function has_more_than_one(table_class) {
    return ($("."+table_class).length > 2); // One is always added by defaul and its hidden
  }


  function add_dynamic_table(element_id, content) {
    $("#"+element_id).append(content);
  }


  function hide_show_public_software_fields() {
    if ($("#software_public_software").is(":checked")) {
      $(".public-software-fields").show();
    } else {
      $(".public-software-fields").hide();
    }
  }


  function replace_software_creations_step() {
    var software_creation_step = $("#software_creation_step").remove();

    if( software_creation_step.size() > 0 ) {
      $("#profile-data").parent().prepend(software_creation_step);
    }
  }


  return {
    isEditSoftware: function() {
      return $("#especific-info").length === 1;
    },


    init: function() {
      var dynamic_tables = ["dynamic-databases", "dynamic-languages", "dynamic-libraries","dynamic-operating_systems"];

      delete_dynamic_table();
      database_autocomplete();
      language_autocomplete();

      $(".new-dynamic-table").click(function(){
        var link = $(this);

        dynamic_tables.forEach(function(value){
          if( link.hasClass(value) ) {
            var table_id = value.split("-")[1];

            var table_html = $("#table_structure_"+table_id).html();

            add_dynamic_table(table_id, table_html);
          }
        });

        delete_dynamic_table();
        database_autocomplete();
        language_autocomplete();

        return false;
      });


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

      hide_show_public_software_fields();
      $("#software_public_software").click(hide_show_public_software_fields);

      replace_software_creations_step();

      NewSoftware.init();
    }
  }
});
