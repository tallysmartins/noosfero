/* globals modulejs */

modulejs.define('UserEditProfile', ['jquery', 'SelectElement', 'SelectFieldChoices', 'CreateInstitution'], function($, SelectElement, SelectFieldChoices, CreateInstitution) {
  'use strict';

  function set_form_count_custom_data() {
    var divisor_option = SelectElement.generateOption("-1", "--------------------------------");
    var default_option = SelectElement.generateOption("BR", "Brazil");

    $('#profile_data_country').find("option[value='']").remove();
    $('#profile_data_country').prepend(divisor_option);
    $('#profile_data_country').prepend(default_option);
    $('#profile_data_country').val("BR");
  }


  function set_initial_form_custom_data(selectFieldChoices) {
    set_form_count_custom_data();

    $("#password-balloon").html($("#user_password_menssage").val());
    $("#profile_data_email").parent().append($("#email_public_message").remove());

    if( $("#state_field").length !== 0 ) selectFieldChoices.replaceStateWithSelectElement();
  }


  function show_state_if_country_is_brazil() {
    var selectFieldChoices = new SelectFieldChoices("#state_field", "#city_field", "/plugin/gov_user/get_brazil_states");
    set_initial_form_custom_data(selectFieldChoices);

    $("#profile_data_country").change(function(){
      if( this.value === "-1" ) $(this).val("BR");

      if( this.value === "BR" && selectFieldChoices.actualFieldIsInput() ) {
        selectFieldChoices.replaceStateWithSelectElement();
        selectFieldChoices.showCity();
      } else if( this.value !== "BR" && !selectFieldChoices.actualFieldIsInput() ) {
        selectFieldChoices.replaceStateWithInputElement();
        selectFieldChoices.hideCity();
      }
    });
  }


  function show_or_hide_phone_mask() {
    if($("#profile_data_country").val() === "BR") {
      if( (typeof $("#profile_data_cell_phone").data("rawMaskFn") === 'undefined') ) {
        // $("#profile_data_cell_phone").mask("(99) 9999?9-9999");
        // $("#profile_data_comercial_phone").mask("(99) 9999?9-9999");
        // $("#profile_data_contact_phone").mask("(99) 9999?9-9999");
      }
    } else {
      // $("#profile_data_cell_phone").unmask();
      // $("#profile_data_comercial_phone").unmask();
      // $("#profile_data_contact_phone").unmask();
    }
  }


  function fix_phone_mask_format(id) {
    $(id).blur(function() {
      var last = $(this).val().substr( $(this).val().indexOf("-") + 1 );

      if( last.length === 3 ) {
        var move = $(this).val().substr( $(this).val().indexOf("-") - 1, 1 );
        var lastfour = move + last;
        var first = $(this).val().substr( 0, 9 );

        $(this).val( first + '-' + lastfour );
      }
    });
  }


  function show_plugin_error_message(field_selector, hidden_message_id ) {
    var field = $(field_selector);

    field.removeClass("validated").addClass("invalid");

    if(!$("." + hidden_message_id)[0]) {
      var message = $("#" + hidden_message_id).val();
      field.parent().append("<div class='" + hidden_message_id + " errorExplanation'>"+message+"</span>");
    } else {
      $("." + hidden_message_id).show();
    }
  }


  function hide_plugin_error_message(field_selector, hidden_message_id) {
    $(field_selector).removeClass("invalid").addClass("validated");
    $("." + hidden_message_id).hide();
  }


  function add_blur_fields(field_selector, hidden_message_id, validation_function, allow_blank) {
    $(field_selector).blur(function(){
      $(this).attr("class", "");

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


  function get_privacy_selector_parent_div(field_id, actual) {
    if( actual === undefined ) actual = $(field_id);

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

    try_to_remove(containers, get_privacy_selector_parent_div("#city_field"));
    try_to_remove(containers, get_privacy_selector_parent_div("#state_field"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_country"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_birth_date"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_organization_website"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_personal_website"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_comercial_phone"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_contact_phone"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_cell_phone"));
    try_to_remove(containers, $("#select_institution"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_email"));
    try_to_remove(containers, get_privacy_selector_parent_div("#profile_data_name"));
    try_to_remove(containers, $(".pseudoformlabel").parent().parent());
    try_to_remove(containers, $("h2")[0]);

    return containers;
  }


  function change_edit_fields_order() {
    var form = $("#profile-data");

    if( form.length !== 0 ) {
      var containers = get_edit_fields_in_insertion_order();

      containers.forEach(function(container){
        form.prepend(container);
      });
    }
  }


  function set_fields_validations() {
    $("#profile_data_country").blur(show_or_hide_phone_mask);

    // $("#profile_data_birth_date").mask("99/99/9999");

    fix_phone_mask_format("#profile_data_cell_phone");
    fix_phone_mask_format("#profile_data_comercial_phone");
    fix_phone_mask_format("#profile_data_contact_phone");

    add_blur_fields("#profile_data_email", "email_error", invalid_email_validation);
    add_blur_fields("#profile_data_personal_website", "site_error", invalid_site_validation);
    add_blur_fields("#profile_data_organization_website", "site_error", invalid_site_validation);
  }


  return {
    isCurrentPage: function() {
      return $('#profile_data_email').length === 1;
    },


    init: function() {
      change_edit_fields_order(); // To change the fields order, it MUST be the first function executed

      show_state_if_country_is_brazil();

      show_or_hide_phone_mask();

      set_fields_validations();

      CreateInstitution.init();
    }
  }
});
