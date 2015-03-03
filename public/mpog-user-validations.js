(function(){
  var AJAX_URL = {
    check_reactivate_account:
      url_with_subdirectory("/plugin/software_communities/check_reactivate_account")
  };


  /*
  * "Class" that switch state field between input and select
  * If the Country if Brazil, set state to select field
  * else set it as a input field
  */
  var SelectFieldChoices = (function() {
    function SelectFieldChoices(state_id, city_id, state_url) {
      this.state_id = state_id;
      this.input_html = jQuery(state_id).parent().html();
      this.old_value = jQuery(state_id).val();
      this.city_parent_div = jQuery(city_id).parent().parent().parent();
      this.state_url = state_url;
    }

    SelectFieldChoices.prototype.getCurrentStateElement = function() {
      return jQuery(this.state_id);
    };

    SelectFieldChoices.prototype.replaceWith = function(html) {
      var parent_div = this.getCurrentStateElement().parent();
      parent_div.html(html);
    };

    SelectFieldChoices.prototype.generateSelect = function(state_list) {
      var select_element, option;

      select_element = new SelectElement();
      select_element.setAttr("name", "profile_data[state]");
      select_element.setAttr("id", "state_field");
      select_element.setAttr("class", "type-select valid");

      state_list.forEach(function(state) {
        option = SelectElement.generateOption(state, state);
        select_element.addOption(option);
      });

      return select_element.getSelect();
    };

    SelectFieldChoices.prototype.replaceStateWithSelectElement = function() {
      var klass = this;

      jQuery.get(this.state_url, function(response) {
        var select_html;

        if (response.length > 0) {
          select_html = klass.generateSelect(response);
          klass.replaceWith(select_html);

          if (klass.old_value.length !== 0 && response.include(klass.old_value)) {
            klass.getCurrentStateElement().val(klass.old_value);
          }
        }
      });
    };

    SelectFieldChoices.prototype.replaceStateWithInputElement = function() {
      this.replaceWith(this.input_html);
    };

    SelectFieldChoices.prototype.hideCity = function() {
      this.city_parent_div.addClass("mpog_hidden_field");
    };

    SelectFieldChoices.prototype.showCity = function() {
      this.city_parent_div.removeClass("mpog_hidden_field");
    };

    SelectFieldChoices.prototype.actualFieldIsInput = function() {
      return this.getCurrentStateElement().attr("type") === "text";
    };

    return SelectFieldChoices;
  })();

  function set_form_count_custom_data() {
    var divisor_option = SelectElement.generateOption("-1", "--------------------------------");
    var default_option = SelectElement.generateOption("BR", "Brazil");

    jQuery('#profile_data_country').find("option[value='']").remove();
    jQuery('#profile_data_country').prepend(divisor_option);
    jQuery('#profile_data_country').prepend(default_option);
    jQuery('#profile_data_country').val("BR");
  }

  function set_initial_form_custom_data(selectFieldChoices) {
    set_form_count_custom_data();

    jQuery("#password-balloon").html(jQuery("#user_password_menssage").val());
    jQuery("#profile_data_email").parent().append(jQuery("#email_public_message").remove());

    if( jQuery("#state_field").length !== 0 ) selectFieldChoices.replaceStateWithSelectElement();
  }

  function check_reactivate_account(value, input_object){
    jQuery.ajax({
      url : AJAX_URL.check_reactivate_account,
      type: "GET",
      data: { "email": value },
      success: function(response) {
        if( jQuery("#forgot_link").length === 0 )
          jQuery(input_object).parent().append(response);
        else
          jQuery("#forgot_link").html(response);
      },
      error: function(type, err, message) {
        console.log(type+" -- "+err+" -- "+message);
      }
    });
  }

  function put_brazil_based_on_email(){
    var suffixes = ['gov.br', 'jus.br', 'leg.br', 'mp.br'];
    var value = this.value;
    var input_object = this;
    var gov_suffix = false;

    suffixes.each(function(suffix){
      var has_suffix = new RegExp("(.*)"+suffix+"$", "i");

      if( has_suffix.test(value) ) {
        gov_suffix = true;
        jQuery("#profile_data_country").val("BR");
      }
    });

    jQuery("#profile_data_country").find(':not(:selected)').css('display', (gov_suffix?'none':'block'));

    check_reactivate_account(value, input_object);
  }

  function validate_email_format(){
    var correct_format_regex = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/;

    if( this.value.length > 0 ) {
      if(correct_format_regex.test(this.value))
        this.className = "validated";
      else
        this.className = "invalid";
    } else
      this.className = "";
  }

  function verify_user_password_size() {
    if( this.value.length < 6 ) {
      jQuery(this).switchClass("validated", "invalid");
    } else {
      jQuery(this).switchClass("invalid", "validated");
    }
  }

  function show_or_hide_phone_mask() {
    if(jQuery("#profile_data_country").val() == "BR") {
      if( (typeof jQuery("#profile_data_cell_phone").data("rawMaskFn") === 'undefined') ) {
        jQuery("#profile_data_cell_phone").mask("(99) 9999?9-9999");
        jQuery("#profile_data_comercial_phone").mask("(99) 9999?9-9999");
        jQuery("#profile_data_contact_phone").mask("(99) 9999?9-9999");
      }
    } else {
      jQuery("#profile_data_cell_phone").unmask();
      jQuery("#profile_data_comercial_phone").unmask();
      jQuery("#profile_data_contact_phone").unmask();
    }
  }

  function fix_phone_mask_format(id) {
    jQuery(id).blur(function() {
      var last = jQuery(this).val().substr( jQuery(this).val().indexOf("-") + 1 );

      if( last.length == 3 ) {
          var move = jQuery(this).val().substr( jQuery(this).val().indexOf("-") - 1, 1 );
          var lastfour = move + last;
          var first = jQuery(this).val().substr( 0, 9 );

          jQuery(this).val( first + '-' + lastfour );
      }
    });
  }

  // Generic
  function show_plugin_error_message(field_selector, hidden_message_id ) {
    var field = jQuery(field_selector);

    field.removeClass("validated").addClass("invalid");

    if(!jQuery("." + hidden_message_id)[0]) {
      var message = jQuery("#" + hidden_message_id).val();
      field.parent().append("<div class='" + hidden_message_id + " errorExplanation'>"+message+"</span>");
    } else {
      jQuery("." + hidden_message_id).show();
    }
  }

  function hide_plugin_error_message(field_selector, hidden_message_id) {
    jQuery(field_selector).removeClass("invalid").addClass("validated");
    jQuery("." + hidden_message_id).hide();
  }

  function addBlurFields(field_selector, hidden_message_id, validation_function, allow_blank) {
    jQuery(field_selector).blur(function(){
      jQuery(this).attr("class", "");

      if( validation_function(this.value, !!allow_blank) ) {
        show_plugin_error_message(field_selector, hidden_message_id);
      } else {
        hide_plugin_error_message(field_selector, hidden_message_id);
      }
    });
  }

  function invalid_email_validation(value, allow_blank) {
    if( allow_blank && value.trim().length === 0 ) {
      return false;
    }

    var correct_format_regex = new RegExp(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/);

    return !correct_format_regex.test(value);
  }

  function invalid_site_validation(value) {
    var correct_format_regex = new RegExp(/(^|)(http[s]{0,1})\:\/\/(\w+[.])\w+/g);

    return !correct_format_regex.test(value);
  }
  //End generic

  function get_privacy_selector_parent_div(field_id, actual) {
    if( actual === undefined ) actual = jQuery(field_id);

    if( actual.is("form") || actual.length === 0 ) return null; // Not allow recursion over form

    if( actual.hasClass("field-with-privacy-selector") ) {
      return actual;
    } else {
      return get_privacy_selector_parent_div(field_id, actual.parent());
    }
  }

  function try_to_remove(list, field) {
    try {
      list.push(field.remove());
    } catch(e) {
      console.log("Cound not remove field");
    }
  }

  function get_edit_fields_in_insertion_order() {
    var containers = [];

    try_to_remove(containers, jQuery("h2")[0]);
    try_to_remove(containers, jQuery(".pseudoformlabel").parent().parent());
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_name"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_email"));
    try_to_remove(containers, jQuery("#user_secondary_email").parent().parent());
    try_to_remove(containers, jQuery("#select_institution"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_cell_phone"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_contact_phone"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_comercial_phone"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_personal_website"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_organization_website"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_birth_date"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_country"));
    try_to_remove(containers, get_privacy_selector_parent_div("#state_field"));
    try_to_remove(containers, get_privacy_selector_parent_div("#city_field"));

    return containers;
  }

  function change_edit_fields_order() {
    var form = jQuery("#profile-data");
    if( form.length !== 0 ) {
      var containers = get_edit_fields_in_insertion_order();

      containers.reverse();

      containers.forEach(function(container){
        form.prepend(container);
      });
    }
  }

  jQuery(document).ready(function(){
    change_edit_fields_order(); // To change the fields order, it MUST be the first function executed

    var selectFieldChoices = new SelectFieldChoices("#state_field", "#city_field", "/plugin/software_communities/get_brazil_states");
    set_initial_form_custom_data(selectFieldChoices);

    jQuery('#secondary_email_field').blur(validate_email_format);

    jQuery("#user_email").blur(put_brazil_based_on_email);

    jQuery('#secondary_email_field').focus(function() { jQuery('#secondary-email-balloon').fadeIn('slow'); });
    jQuery('#secondary_email_field').blur(function() { jQuery('#secondary-email-balloon').fadeOut('slow'); });

    jQuery("#user_pw").blur(verify_user_password_size);

    jQuery("#profile_data_country").blur(show_or_hide_phone_mask);

    // Event that calls the "Class" to siwtch state field types
    jQuery("#profile_data_country").change(function(){
      if( this.value == "-1" ) jQuery(this).val("BR");

      if( this.value == "BR" && selectFieldChoices.actualFieldIsInput() ) {
        selectFieldChoices.replaceStateWithSelectElement();
        selectFieldChoices.showCity();
      } else if( this.value != "BR" && !selectFieldChoices.actualFieldIsInput() ) {
        selectFieldChoices.replaceStateWithInputElement();
        selectFieldChoices.hideCity();
      }
    });

    show_or_hide_phone_mask();
    jQuery("#profile_data_birth_date").mask("99/99/9999");

    fix_phone_mask_format("#profile_data_cell_phone");
    fix_phone_mask_format("#profile_data_comercial_phone");
    fix_phone_mask_format("#profile_data_contact_phone");

    addBlurFields("#profile_data_email", "email_error", invalid_email_validation);
    addBlurFields("#user_secondary_email", "email_error", invalid_email_validation, true);
    addBlurFields("#profile_data_personal_website", "site_error", invalid_site_validation);
    addBlurFields("#profile_data_organization_website", "site_error", invalid_site_validation);
  });
})();
