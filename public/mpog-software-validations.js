(function($){
  var AJAX_URL = {
    get_field_data:
      url_with_subdirectory("/plugin/software_communities/get_field_data"),
    get_license_data:
      url_with_subdirectory("/plugin/software_communities/get_license_data")
  };


  function get_hidden_description_field(autocomplete_field, klass) {
    var field = $(autocomplete_field);
    field = field.parent().parent().find(klass);
    return field;
  }


  function verify_autocomplete(field, klass) {
    var field = $(field);
    var selected = get_hidden_description_field(field, klass);
    var message_error = $(field).parent().find(".autocomplete_validation_message");

    if( field.length === 0 || selected.val().length === 0 ) {
      message_error.removeClass("hide-field");
      selected.val("");

      message_error.show();
    } else {
      field.val(selected.attr("data-label"));
      message_error.hide();
    }
  }


  function database_autocomplete() {
    enable_autocomplete("database", ".database_description_id", ".database_autocomplete", AJAX_URL.get_field_data);
  }


  function language_autocomplete() {
    enable_autocomplete("software_language", ".programming_language_id", ".language_autocomplete", AJAX_URL.get_field_data);
  }


  function enable_autocomplete(field_name, field_value_class, autocomplete_class, ajax_url, select_callback) {
    $(autocomplete_class).autocomplete({
      source : function(request, response){
        $.ajax({
          type: "GET",
          url: ajax_url,
          data: {query: request.term, field: field_name},
          success: function(result){
            response(result);
          }
        });
      },

      minLength: 0,

      select : function (event, selected) {
        var description = get_hidden_description_field(this, field_value_class);
        description.val(selected.item.id);
        description.attr("data-label", selected.item.label);

        if( select_callback !== undefined ) {
          select_callback(selected);
        }
      }
    }).blur(function(){
      verify_autocomplete(this, field_value_class);
    }).click(function(){
      $(this).autocomplete("search", "");
    });
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
    Element.insert(element_id, {bottom: content});
  }


  function show_another_license_on_page_load() {
    $("#license_info_id").trigger("change");
  }


  function hide_infos() {
    $(".language-info").hide();
    $(".database-info").hide();
    $(".libraries-info").hide();
    $(".operating-system-info").hide();
    $(".language-button-hide").hide();
    $(".database-button-hide").hide();
    $(".libraries-button-hide").hide();
    $(".operating-system-button-hide").hide();
  }

  function hide_show_public_software_fields() {
    if ($("#software_public_software").prop("checked"))
      $(".public-software-fields").show();
    else
      $(".public-software-fields").hide();
  }


  function replace_software_creations_step() {
    var software_creation_step = $("#software_creation_step").remove();

    if( software_creation_step.size() > 0 ) {
      $("#profile-data").parent().prepend(software_creation_step);
    }
  }


  function display_another_license_fields(selected) {
    if( selected == "Another" ) {
      $("#another_license").removeClass("hide-field");
      $("#version_link").addClass("hide-field");
      console.log($("#version_link"));
    } else {
      $("#another_license").addClass("hide-field");
      $("#version_link").removeClass("hide-field");
    }
  }


  function display_license_link_on_autocomplete(selected) {
    var link = $("#version_" + selected.item.id).val();
    $("#version_link").attr("href", link);

    display_another_license_fields(selected.item.label);
  }


  function license_info_autocomplete() {
    enable_autocomplete(
      "license_info", ".license_info_id", ".license_info_version",
      AJAX_URL.get_license_data, display_license_link_on_autocomplete
    );
  }


  $(document).ready(function() {
    var dynamic_tables = ["dynamic-databases", "dynamic-languages", "dynamic-libraries","dynamic-operating_systems"];

    delete_dynamic_table();
    database_autocomplete();
    language_autocomplete();

    $(".new-dynamic-table").click(function(){
      var link = $(this);

      dynamic_tables.each(function(value){
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

    license_info_autocomplete();
  });
})(jQuery);
