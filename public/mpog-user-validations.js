(function(){
  /*
  * "Class" that switch state field between input and select
  * If the Country if Brazil, set state to select field
  * else set it as a input field
  */
  function SelectFieldChoices() {
    // Get the initial state html
    var input_select = jQuery("#state_field").parent().html();
    var old_value = jQuery("#state_field").val();
    var city_parent_div = jQuery("#city_field").parent().parent().parent();

    function replace_with(html) {
      var parent_div = jQuery("#state_field").parent();
      parent_div.html(html);
    }

    function generate_select(state_list) {
      var html = "<select class='type-select valid' id='state_field' name='profile_data[state]'>";

      state_list.forEach(function(state){
        html += "<option value='"+state+"'>"+state+"</option>";
      });

      html += "</select>";
      return html;
    }

    function replace_state_with_select() {
      jQuery.get("/plugin/mpog_software/get_brazil_states", function(response){
        if( response.length > 0 ) {
          var select_html = generate_select(response);
          replace_with(select_html);

          if( old_value.length != 0 && response.include(old_value) ) {
            jQuery("#state_field").val(old_value);
          }
        }
      });
    }

    function hide_city(){
      city_parent_div.addClass("mpog_hidden_field");
    }

    function show_city(){
      city_parent_div.removeClass("mpog_hidden_field");
    }

    function replace_state_with_input() {
      replace_with(input_select);
    }

    return {
      actualFieldIsInput : function() {
        return jQuery("#state_field").attr("type") == "text";
      },

      setSelect : function() {
        replace_state_with_select();
      },

      setInput : function() {
        replace_state_with_input();
      },
      
      setHideCity : function(){
        hide_city();
      },

      setShowCity : function(){
        show_city();
      }
    }
  }

  function set_initial_form_custom_data(selectFieldChoices) {
    jQuery('#profile_data_country').val("BR");
    jQuery("#password-balloon").html(jQuery("#user_password_menssage").val());
    jQuery("#profile_data_email").parent().append(jQuery("#email_public_message").remove());

    selectFieldChoices.setSelect();
  }

  function check_reactivate_account(value, input_object){
    jQuery.ajax({
      url : "/plugin/mpog_software/check_reactivate_account",
      type: "GET",
      data: { "email": value },
      success: function(response) {
        if( jQuery("#forgot_link").length == 0 )
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

    check_reactivate_account(value, input_object)
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

  // Sorry, I know its ugly. But I cant get ([^\w\*\s*])|(^|\s)([a-z]|[0-9])
  // to ignore Brazilian not so much special chars in names
  function replace_some_special_chars(text) {
    return text.replace(/([áàâãéèêíïóôõöú])/g, function(value){
      if( ["á","à","â","ã"].indexOf(value) != -1 )
        return "a";
      else if( ["é","è","ê"].indexOf(value) != -1 )
        return "e";
      else if( ["í","ï"].indexOf(value) != -1 )
        return "i";
      else if ( ["ó","ô","õ","ö"].indexOf(value) != -1 )
        return "o";
      else if( ["ú"].indexOf(value) != -1 )
        return "u";
      else
        return value;
    });
  }

  function is_invalid_formated(text) {
    var full_validation = /([^\w\*\s*])|(^|\s)([a-z]|[0-9])/; // no special chars and do not initialize with no capital latter
    var partial_validation = /[^\w\*\s*]/; // no special chars
    text = replace_some_special_chars(text);
    var slices = text.split(" ");
    var invalid = false;

    for(var i = 0; i < slices.length; i++) {
      if( slices[i].length > 3 || text.length <= 3 ) {
        invalid = full_validation.test(slices[i]);
      } else {
        invalid = partial_validation.test(slices[i]);
      }

      if(invalid) break;
    }

    return invalid;
  }

  // Generic
  function show_plugin_error_message(field_id, hidden_message_id ) {
    var field = jQuery("#"+field_id);

    field.removeClass("validated").addClass("invalid");

    if(!jQuery("." + hidden_message_id)[0]) {
      var message = jQuery("#" + hidden_message_id).val();
      field.parent().append("<div class='" + hidden_message_id + " errorExplanation'>"+message+"</span>");
    } else {
      jQuery("." + hidden_message_id).show();
    }
  }

  function hide_plugin_error_message(field_id, hidden_message_id) {
    jQuery("#" + field_id).removeClass("invalid").addClass("validated");
    jQuery("." + hidden_message_id).hide();
  }
  function addBlurFields(field_id, hidden_message_id, validation_function) {
    jQuery("#" + field_id).blur(function(){
      jQuery(this).attr("class", "");

      if( this.value.length > 0 && validation_function(this.value) ) {
        show_plugin_error_message(field_id, hidden_message_id);
      } else {
        hide_plugin_error_message(field_id, hidden_message_id);
      }
    });
  }

  function invalid_email_validation(value) {
    var correct_format_regex = new RegExp(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/);

    return !correct_format_regex.test(value);
  }

  function invalid_site_validation(value) {
    var correct_format_regex = new RegExp(/(^|)(http[s]{0,1})\:\/\/(\w+[.])\w+/g);

    return !correct_format_regex.test(value);
  }

  //End generic


  jQuery(document).ready(function(){
    var selectFieldChoices = new SelectFieldChoices();
    set_initial_form_custom_data(selectFieldChoices);

    jQuery('#secondary_email_field').blur(
      validate_email_format
    );

    jQuery("#user_email").blur(put_brazil_based_on_email);

    jQuery('#secondary_email_field').focus(function() { jQuery('#secondary-email-balloon').fadeIn('slow'); });
    jQuery('#secondary_email_field').blur(function() { jQuery('#secondary-email-balloon').fadeOut('slow'); });

    jQuery("#user_pw").blur(verify_user_password_size);

    jQuery("#profile_data_country").blur(show_or_hide_phone_mask);

    // Event that calls the "Class" to siwtch state field types
    jQuery("#profile_data_country").change(function(){
      if( this.value == "BR" && selectFieldChoices.actualFieldIsInput() ) {
        selectFieldChoices.setSelect();
        selectFieldChoices.setShowCity();
      } else {
        selectFieldChoices.setInput();
        selectFieldChoices.setHideCity();
      }
    });

    show_or_hide_phone_mask();

    fix_phone_mask_format("#profile_data_cell_phone");
    fix_phone_mask_format("#profile_data_comercial_phone");
    fix_phone_mask_format("#profile_data_contact_phone");

    addBlurFields("profile_data_name", "full_name_error", is_invalid_formated);
    addBlurFields("profile_data_email", "email_error", invalid_email_validation);
    addBlurFields("user_secondary_email", "email_error", invalid_email_validation);
    addBlurFields("profile_data_personal_website", "site_error", invalid_site_validation);
    addBlurFields("profile_data_organization_website", "site_error", invalid_site_validation);
  });
})();
