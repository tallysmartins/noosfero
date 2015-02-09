(function(){
  var AJAX_URL = {
    get_field_data:
      url_with_subdirectory("/plugin/mpog_software/get_field_data")
  };


  function get_hidden_description_field(autocomplete_field, klass) {
    var field = jQuery(autocomplete_field);
    field = field.parent().parent().find(klass);
    return field;
  }

  function verify_autocomplete(field, klass) {
    var field = jQuery(field);
    var selected = get_hidden_description_field(field, klass);
    var message_error = jQuery(field).parent().find(".autocomplete_validation_message");

    if( field.length === 0 || selected.val().length === 0 ) {
      message_error.removeClass("hide-field");
      selected_value.val("");

      message_error.show();
    } else {
      field.val(selected.attr("data-label"));
      message_error.hide();
    }
  }

  function database_autocomplete() {
    enable_autocomplete("database", ".database_description_id", ".database_autocomplete");
  }


  function language_autocomplete() {
    enable_autocomplete("software_language", ".programming_language_id", ".language_autocomplete");
  }

  function enable_autocomplete(field_name, field_value_class, autocomplete_class) {
    jQuery(autocomplete_class).autocomplete({
      source : function(request, response){
        jQuery.ajax({
          type: "GET",
          url: AJAX_URL.get_field_data,
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
      }
    }).blur(function(){
      verify_autocomplete(this, field_value_class);
    }).click(function(){
      jQuery(this).autocomplete("search", "");
    });
  }

  function delete_dynamic_table() {
    var button = jQuery(".delete-dynamic-table");

    button.each(function(){
      var table = jQuery(this).parent().parent().parent().parent();
      var color = table.css("background-color");

      jQuery(this).click(function(){
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
    return (jQuery("."+table_class).length > 2); // One is always added by defaul and its hidden
  }

  function add_dynamic_table(element_id, content) {
    Element.insert(element_id, {bottom: content});
  }

  function get_license_link(){
    var selected_index = this.options.selectedIndex;
    var selected = this.options[selected_index];
    var link = jQuery("#version_" + this.value).val();

    if( selected.textContent == "Another" ) {
      jQuery("#another_license").removeClass("hide-field");
      jQuery("#version_link").addClass("hide-field");
    } else {
      jQuery("#another_license").addClass("hide-field");
      jQuery("#version_link").removeClass("hide-field");
    }

    jQuery("#version_link")
      .attr("href", link)
      .text(link);
  }

  function show_another_license_on_page_load() {
    jQuery("#license_info_id").trigger("change");
  }

  function hide_infos() {
    jQuery(".language-info").hide();
    jQuery(".database-info").hide();
    jQuery(".libraries-info").hide();
    jQuery(".operating-system-info").hide();
    jQuery(".language-button-hide").hide();
    jQuery(".database-button-hide").hide();
    jQuery(".libraries-button-hide").hide();
    jQuery(".operating-system-button-hide").hide();
  }

  function hide_show_public_software_fields() {
    if (jQuery("#software_public_software").prop("checked"))
      jQuery(".public-software-fields").show();
    else
      jQuery(".public-software-fields").hide();
  }

  function replace_software_creations_step() {
    var software_creation_step = jQuery("#software_creation_step").remove();

    if( software_creation_step.size() > 0 ) {
      jQuery("#profile-data").parent().prepend(software_creation_step);
    }
  }

  jQuery(document).ready(function(){
    var dynamic_tables = ["dynamic-databases", "dynamic-languages", "dynamic-libraries","dynamic-operating_systems"];

    delete_dynamic_table();
    database_autocomplete();
    language_autocomplete();

    jQuery(".new-dynamic-table").click(function(){
      var link = jQuery(this);

      dynamic_tables.each(function(value){
        if( link.hasClass(value) ) {
          var table_id = value.split("-")[1];

          var table_html = jQuery("#table_structure_"+table_id).html();
          add_dynamic_table(table_id, table_html);
        }
      });

      delete_dynamic_table();
      database_autocomplete();
      language_autocomplete();
      return false;
    });

    jQuery(".language-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".language-info").hide();
      jQuery(".language-button-show").show();
      jQuery(".language-button-hide").hide();
    });

    jQuery(".language-button-show").click(function(event){
      event.preventDefault();
      jQuery(".language-info").show();
      jQuery(".language-button-show").hide();
      jQuery(".language-button-hide").show();
    });

    jQuery(".operating-system-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".operating-system-info").hide();
      jQuery(".operating-system-button-show").show();
      jQuery(".operating-system-button-hide").hide();
    });

    jQuery(".operating-system-button-show").click(function(event){
      event.preventDefault();
      jQuery(".operating-system-info").show();
      jQuery(".operating-system-button-show").hide();
      jQuery(".operating-system-button-hide").show();
    });

    jQuery(".database-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".database-info").hide();
      jQuery(".database-button-show").show();
      jQuery(".database-button-hide").hide();
    });

    jQuery(".database-button-show").click(function(event){
      event.preventDefault();
      jQuery(".database-info").show();
      jQuery(".database-button-show").hide();
      jQuery(".database-button-hide").show();
    });

    jQuery(".libraries-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".libraries-info").hide();
      jQuery(".libraries-button-show").show();
      jQuery(".libraries-button-hide").hide();
    });

    jQuery(".libraries-button-show").click(function(event){
      event.preventDefault();
      jQuery(".libraries-info").show();
      jQuery(".libraries-button-show").hide();
      jQuery(".libraries-button-hide").show();
    });
    hide_show_public_software_fields();
    jQuery("#software_public_software").click(hide_show_public_software_fields);

    replace_software_creations_step();

    jQuery("#license_info_id").change(get_license_link);
    show_another_license_on_page_load();
  });
})();
