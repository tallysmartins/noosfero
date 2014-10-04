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
      }
    }
  }

  function set_initial_form_custom_data(selectFieldChoices) {
    jQuery('#profile_data_country').val("BR");
    jQuery("#password-balloon").html(jQuery("#user_password_menssage").val());

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
      }
    } else {
      jQuery("#profile_data_cell_phone").unmask();
      jQuery("#profile_data_comercial_phone").unmask();
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

  function set_full_name_validation() {
    function is_invalid_formated(text) {
      var reg_firsts_char = /(^|\s)([a-z]|[0-9])/g;
      var reg_special_char = /[^\w\*\s*]/g;
      var invalid = false;
      var slices = text.split(" ");

      for(var i = 0; i < slices.length; i++) {
        if( slices[i].length > 3 ) {
          invalid = reg_firsts_char.test(slices[i]) || reg_special_char.test(slices[i]);
        } else {
          invalid = reg_special_char.test(slices[i]);
        }
      }

      return invalid;
    }

    function show_full_name_error_message() {
      var field = jQuery("#profile_data_name");

      field.removeClass("validated").addClass("invalid");

      if(!jQuery(".full_name_error")[0]) {
        var message = jQuery("#full_name_error").val();
        field.parent().append("<span class='full_name_error'>"+message+"</span>");
      } else {
        jQuery(".full_name_error").show();
      }
    }

    function hide_full_name_error_message() {
      jQuery("#profile_data_name").removeClass("invalid").addClass("validated");
      jQuery(".full_name_error").hide();
    }

    jQuery("#profile_data_name").blur(function(){
      jQuery(this).attr("class", "");

      if( this.value.length > 0 && is_invalid_formated(this.value) ) {
        show_full_name_error_message();
      } else {
        hide_full_name_error_message();
      }
    });
  }

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
      } else {
        selectFieldChoices.setInput();
      }
    });

    show_or_hide_phone_mask();

    fix_phone_mask_format("#profile_data_cell_phone");
    fix_phone_mask_format("#profile_data_comercial_phone");

    window.setTimeout(function(){
      /*
      Noosfero application.js is one of the last loaded javascript files.
      Then, to override an application.js validation, this code waits for 2 seconds.
      Or else, application.js validation override this validation
      */
      set_full_name_validation();
    }, 2000);
  });
})();
