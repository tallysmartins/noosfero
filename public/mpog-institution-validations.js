(function(){
  function open_create_institution_modal(evt) {
    evt.preventDefault();

    jQuery.get("/plugin/mpog_software/create_institution", function(response){
      jQuery("#institution_dialog").html(response);

      set_form_count_custom_data();
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
  }

  function show_private_institutions_fields() {
    jQuery(".public-institutions-fields").hide();

    jQuery("#institutions_governmental_power option").selected(0);
    jQuery("#institutions_governmental_sphere option").selected(0);
  }

  function get_post_data() {
    return {
        community : {
          name : jQuery("#community_name").val(),
          country : jQuery("#community_country").val(),
          state : jQuery("#community_state").val(),
          city : jQuery("#community_city").val()
        },
        institutions : {
          cnpj: jQuery("#institutions_cnpj").val(),
          type: jQuery("input[name='institutions[type]']:checked").val(),
          acronym : jQuery("#institutions_acronym").val(),
          governmental_power: jQuery("#institutions_governmental_power").selected().val(),
          governmental_sphere: jQuery("#institutions_governmental_sphere").selected().val(),
          juridical_nature: jQuery("#institutions_juridical_nature").selected().val(),
          corporate_name: jQuery("#institutions_corporate_name").val()
        },
    }
  }

  function success_ajax_response(response) {
    close_loading();
    if(response.success){
      var institution_name  = response.institution_data.name;
      var institution_id = response.institution_data.id;

      jQuery("#institution_dialog").html("<div class='errorExplanation'><h2>"+response.message+"</h2></div>");
      jQuery("#create_institution_errors").switchClass("show-field", "hide-field");

      jQuery(".institution_container").append(get_clone_institution_data(institution_id));
      add_selected_institution_to_list(institution_id, institution_name);

      jQuery(".remove-institution").click(remove_institution);
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

  function get_clone_institution_data(value) {
    var user_institutions = jQuery(".user_institutions").first().clone();
    user_institutions.val(value);

    return user_institutions;
  }

  function institution_autocomplete() {
    jQuery("#input_institution").autocomplete({
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
        jQuery("#institution_selected").val(selected.item.id).attr("data-name", selected.item.label);
      }
    });
  }

  function add_selected_institution_to_list(id, name) {
    var selected_institution = "<li data-institution='"+id+"'>"+name;
        selected_institution += "<a href='#' class='button without-text icon-remove remove-institution'></a></li>";

    jQuery(".institutions_added").append(selected_institution);
  }

  function add_new_institution(evt) {
    evt.preventDefault();
    var selected = jQuery("#institution_selected");
    var institution_already_added = jQuery(".institutions_added li[data-institution='"+selected.val()+"']").length;

    if(selected.val().length > 0 && institution_already_added == 0) {
      //field that send the institutions to the server
      jQuery(".institution_container").append(get_clone_institution_data(selected.val()));

      // Visualy add the selected institution to the list
      add_selected_institution_to_list(selected.val(), selected.attr("data-name"));

      // clean the institution flag
      selected.val("").attr("data-name", "");
      jQuery("#input_institution").val("");

      jQuery(".remove-institution").click(remove_institution);
    }
  }

  function remove_institution(evt) {
    evt.preventDefault();
    var code = jQuery(this).parent().attr("data-institution");

    jQuery(".user_institutions[value="+code+"]").remove();
    jQuery(this).parent().remove();
  }

  function add_mask_to_form_items() {
    jQuery(".intitution_cnpj_field").mask("99.999.999/9999-99");
  }

  function show_hide_cnpj_city(country) {
    var cnpj = jQuery("#institutions_cnpj").parent().parent();
    var city = jQuery("#community_city").parent().parent();
    var state = jQuery("#community_state").parent().parent();

    if( country == "-1" ) jQuery("#community_country").val("BR");

    if( country != "BR" ) {
      cnpj.hide();
      city.hide();
      state.hide();
    } else {
      cnpj.show();
      city.show();
      state.show();
    }
  }

  function institution_type_actions(type) {
    if( type == "PublicInstitution" )
      show_public_institutions_fields();
    else
      show_private_institutions_fields();
  }

  function set_form_count_custom_data() {
    var divisor_option = SelectElement.generateOption("-1", "--------------------------------");
    var default_option = SelectElement.generateOption("BR", "Brazil");

    var inst_type = jQuery("input[name='institutions[type]']:checked").val();
    var country = jQuery("#community_country").val();

    institution_type_actions(inst_type);
    show_hide_cnpj_city(country);

    if( jQuery('#community_country').find("option[value='']").length == 1 ) {
      jQuery('#community_country').find("option[value='']").remove();
      jQuery('#community_country').prepend(divisor_option);
      jQuery('#community_country').prepend(default_option);

      if(jQuery("#edit_institution_page").val() == "false"){
        jQuery('#community_country').val("BR");
        show_hide_cnpj_city(jQuery('#community_country').val());
      }
    }
  }

  function set_events() {
    jQuery("#create_institution_link").click(open_create_institution_modal);

    jQuery("input[name='institutions[type]']").click(function(){
      institution_type_actions(this.value);
    });

    jQuery('#save_institution_button').click(save_institution);

    jQuery("#community_name").keyup(institution_already_exists);

    jQuery("#add_new_institution").click(add_new_institution);

    jQuery(".remove-institution").click(remove_institution);

    jQuery("#community_country").change(function(){
      console.log(this.value)
      show_hide_cnpj_city(this.value);
    });

    add_mask_to_form_items();

    institution_autocomplete();
  }

  jQuery(document).ready(function(){
    set_form_count_custom_data();
    set_events();
  });
})();
