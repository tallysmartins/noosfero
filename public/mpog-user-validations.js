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

  jQuery("#profile_data_country").prop('disabled', gov_suffix);

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


jQuery(document).ready(function(){
  jQuery('#secondary_email_field').blur(
    validate_email_format
  );

  jQuery('#profile_data_country').val("BR");

  jQuery("#user_email").blur(
    put_brazil_based_on_email
  );

  jQuery('#secondary_email_field').focus(function() { jQuery('#secondary-email-balloon').fadeIn('slow'); });
  jQuery('#secondary_email_field').blur(function() { jQuery('#secondary-email-balloon').fadeOut('slow'); });

  jQuery('#area_interest_field').focus(function() { jQuery('#area-interest-balloon').fadeIn('slow'); });
  jQuery('#area_interest_field').blur(function() { jQuery('#area-interest-balloon').fadeOut('slow'); });
});
