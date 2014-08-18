(function(){
  function open_create_institution_modal(evt) {
    evt.preventDefault();

    jQuery.get("/plugin/mpog_software/create_institution", function(response){
      jQuery("#institution_dialog").html(response);
      set_events();

      jQuery("#institution_dialog").dialog({
        modal: true,
        width: 500,
        height: 530,
        position: 'center',
        close: function() {
          jQuery("#institution_dialog").html("");
          jQuery('#institution_empty_ajax_message').switchClass("show-field", "hide-field");
        }
      });
    });
  }

  function show_public_institutions_fields() {
    jQuery(".public-institutions-fields").show();
    jQuery("label[for='institutions_acronym']").html(jQuery("#acronym_translate").val());
  }

  function show_private_institutions_fields() {
    jQuery(".public-institutions-fields").hide();
    jQuery("label[for='institutions_acronym']").html(jQuery("#fantasy_name_translate").val());

    jQuery("#institutions_governmental_power option").selected(0);
    jQuery("#institutions_governmental_sphere option").selected(0);
  }

  function get_selected_institution_type() {
    var radio_buttons = jQuery("input[type='radio'][name='type']");
    var type = "";

    for( var i = 0; i < radio_buttons.length; i++ ) {
      if( radio_buttons[i].checked ) {
        type = radio_buttons[i].value;
        break;
      }
    }

    return type;
  }

  function get_post_data() {
    return {
        community : { name : jQuery("#community_name").val()},
        governmental : {
          power : jQuery("#institutions_governmental_power").selected().val(),
          sphere : jQuery("#institutions_governmental_sphere").selected().val()
        } ,
        institution : {
          cnpj: jQuery("#institutions_cnpj").val(),
          type: get_selected_institution_type(),
          acronym : jQuery("#institutions_acronym").val()
        },
        authenticity_token : jQuery("input[name='authenticity_token']").val(),
        recaptcha_response_field : jQuery('#recaptcha_response_field').val(),
        recaptcha_challenge_field : jQuery('#recaptcha_challenge_field').val()
    }
  }

  function success_ajax_response(response) {
    close_loading();
    if(response.success){
      jQuery("#institution_dialog").html("<div class='errorExplanation'><h2>"+response.message+"</h2></div>");
      jQuery("#input_institution").val(response.institution_data.name);
      jQuery("#user_institution_id").val(response.institution_data.id);
      jQuery("#create_institution_errors").switchClass("show-field", "hide-field");
    } else {
      var errors = "<ul>";

      for(var i = 0; i < response.errors.length; i++) {
        errors += "<li>"+response.errors[i]+"</li>";
      }
      errors += "</ul>";

      jQuery("#create_institution_errors").switchClass("hide-field", "show-field").html("<h2>"+response.message+"</h2>"+errors);
    }
  }

  function save_institution(evt) {
    evt.preventDefault();
    var form_data = jQuery("#institution_form").serialize();

    open_loading(jQuery("#loading_message").val());
    jQuery.ajax({
      url: "/plugin/mpog_software/new_institution",
      data : get_post_data(),
      type: "POST",
      success: success_ajax_response,
      error: function() {
        close_loading();
        var error_message = jQuery("#institution_error_message").val();
        jQuery("#create_institution_errors").switchClass("hide-field", "show-field").html("<h2>"+error_message+"</h2>");
      }
    });
  }

  function institution_already_exists(){
      if( this.value.length >= 3 ) {
        jQuery.get("/plugin/mpog_software/institution_already_exists", {name:this.value}, function(response){
          if( response == true ) {
            jQuery("#already_exists_text").switchClass("hide-field", "show-field");
          } else {
            jQuery("#already_exists_text").switchClass("show-field", "hide-field");
          }
        });
      }
    }


  function institution_autocomplete() {
    jQuery(".input_institution").autocomplete({
      source : function(request, response){
        jQuery.ajax({
          type: "GET",
          url: "/plugin/mpog_software/get_institutions",
          data: {query: request.term},
          success: function(result){
            response(result);

            if( result.length == 0 ) {
              jQuery('#institution_empty_ajax_message').switchClass("hide-field", "show-field");
            } else {
              jQuery('#institution_empty_ajax_message').switchClass("show-field", "hide-field");
            }
          },
          error: function(ajax, stat, errorThrown) {
            console.log('Link not found : ' + errorThrown);
          }
        });
      },

      minLength: 2,

      select : function (event, selected) {
        var user_institutions = jQuery(".user_institutions").first().clone();
        user_institutions.val(selected.item.id);

        jQuery(".institution_container").append(user_institutions);
      }
    });
  }

  function add_new_institution(evt) {
    evt.preventDefault();
    var institution_input_field = jQuery(".institution_container .input_institution").first().clone();

    institution_input_field.val("");

    jQuery(".institution_container").append(institution_input_field);
    institution_autocomplete();
  }

  function set_events() {
    jQuery("#create_institution_link").click(open_create_institution_modal);

    jQuery("#type_PrivateInstitution").click(show_private_institutions_fields);

    jQuery("#type_PublicInstitution").click(show_public_institutions_fields);

    jQuery('#save_institution_button').click(save_institution);

    jQuery("#community_name").keyup(institution_already_exists);

    jQuery(".add_new_institution").click(add_new_institution);

    institution_autocomplete();

    jQuery(".input_institution").blur(function(){
      if( this.value == "" )
        jQuery("#user_institution_id").val("");
    });
  }

  jQuery(document).ready(set_events);
})();
