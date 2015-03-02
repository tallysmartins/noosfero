modulejs.define('AutoComplete', ['jquery'], function($) {
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


  return {
    enable: enable_autocomplete
  }
});