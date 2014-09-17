(function(){
  function set_initial_form_custom_data() {
    jQuery('#profile_data_country').val("BR");

    jQuery("#password-balloon").html(jQuery("#user_password_menssage").val());
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

  jQuery(document).ready(function(){
    set_initial_form_custom_data();

    jQuery('#secondary_email_field').blur(
      validate_email_format
    );

    jQuery("#user_email").blur(put_brazil_based_on_email);

    jQuery('#secondary_email_field').focus(function() { jQuery('#secondary-email-balloon').fadeIn('slow'); });
    jQuery('#secondary_email_field').blur(function() { jQuery('#secondary-email-balloon').fadeOut('slow'); });

    jQuery("#user_pw").blur(verify_user_password_size);

    jQuery("#profile_data_country").blur(show_or_hide_phone_mask);
    show_or_hide_phone_mask();

    fix_phone_mask_format("#profile_data_cell_phone");
    fix_phone_mask_format("#profile_data_comercial_phone");
  });
})();