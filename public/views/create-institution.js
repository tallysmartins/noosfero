modulejs.define('CreateInstitution', ['jquery', 'NoosferoRoot', 'SelectElement'], function($, NoosferoRoot, SelectElement) {
  'use strict';

  var AJAX_URL = {
    create_institution_modal:
      NoosferoRoot.urlWithSubDirectory("/plugin/gov_user/create_institution"),
    new_institution:
      NoosferoRoot.urlWithSubDirectory("/plugin/gov_user/new_institution"),
    institution_already_exists:
      NoosferoRoot.urlWithSubDirectory("/plugin/gov_user/institution_already_exists"),
    get_institutions:
      NoosferoRoot.urlWithSubDirectory("/plugin/gov_user/get_institutions"),
    auto_complete_city:
      NoosferoRoot.urlWithSubDirectory("/account/search_cities")
  };


  function open_create_institution_modal(evt) {
    evt.preventDefault();

    $.get(AJAX_URL.create_institution_modal, function(response){
      $("#institution_dialog").html(response);

      set_form_count_custom_data();
      set_events();

      $("#institution_dialog").dialog({
        modal: true,
        width: 500,
        height: 530,
        position: 'center',
        close: function() {
          $("#institution_dialog").html("");
          $('#institution_empty_ajax_message').switchClass("show-field", "hide-field");
        }
      });
    });
  }


  function show_public_institutions_fields() {
    $(".public-institutions-fields").show();
  }


  function show_private_institutions_fields() {
    $(".public-institutions-fields").hide();
    $("#institutions_governmental_power option").selected(0);
    $("#institutions_governmental_sphere option").selected(0);
  }


  function get_comunity_post_data() {
    return {
      name : $("#community_name").val(),
      country : $("#community_country").val(),
      state : $("#community_state").val(),
      city : $("#community_city").val()
    };
  }


  function get_institution_post_data() {
    return {
      cnpj: $("#institutions_cnpj").val(),
      type: $("input[name='institutions[type]']:checked").val(),
      acronym : $("#institutions_acronym").val(),
      governmental_power: $("#institutions_governmental_power").selected().val(),
      governmental_sphere: $("#institutions_governmental_sphere").selected().val(),
      juridical_nature: $("#institutions_juridical_nature").selected().val(),
      corporate_name: $("#institutions_corporate_name").val()
    };
  }


  function get_post_data() {
    var post_data = {};

    post_data.community = get_comunity_post_data();
    post_data.institutions = get_institution_post_data();

    return post_data;
  }


  function success_ajax_response(response) {
    close_loading();

    if(response.success){
      var institution_name  = response.institution_data.name;
      var institution_id = response.institution_data.id;

      $("#institution_dialog").html("<div class='errorExplanation'><h2>"+response.message+"</h2></div>");
      $("#create_institution_errors").switchClass("show-field", "hide-field");

      $(".institution_container").append(get_clone_institution_data(institution_id));
      add_selected_institution_to_list(institution_id, institution_name);

      $(".remove-institution").click(remove_institution);
    } else {
      var errors = create_error_list(response);
      $("#create_institution_errors").switchClass("hide-field", "show-field").html("<h2>"+response.message+"</h2>"+errors);

      show_errors_in_each_field(response.errors);
    }
  }

  function create_error_list(response){
    var errors = "<ul>";
    var field_name;

    for(var error_key in response.errors) {
      field_name = adjust_error_key(error_key);

      if(response.errors[error_key].length > 0){
        errors += "<li><b>"+field_name+"</b>: "+response.errors[error_key]+"</li>";
      }
    }

    errors += "</ul>";
    return errors;
  }


  function show_errors_in_each_field(errors) {
    var error_keys = Object.keys(errors);

    // (field)|(field)|...
    var verify_error = new RegExp("(\\[" + error_keys.join("\\])|(\\[") + "\\])" );

    var fields_with_errors = $("#institution_dialog .formfield input").filter(function(index, field) {
      $(field).removeClass("highlight-error");
      return verify_error.test(field.getAttribute("name"));
    });

    var selects_with_errors = $("#institution_dialog .formfield select").filter(function(index, field) {
      $(field).removeClass("highlight-error");
      return verify_error.test(field.getAttribute("name"));
    });

    fields_with_errors.addClass("highlight-error");
    selects_with_errors.addClass("highlight-error");
  }


  function adjust_error_key(error_key) {
    var text = error_key.replace(/_/, " ");
    text = text.charAt(0).toUpperCase() + text.slice(1);

    return text;
  }


  function save_institution(evt) {
    evt.preventDefault();

    open_loading($("#loading_message").val());
    $.ajax({
      url: AJAX_URL.new_institution,
      data : get_post_data(),
      type: "POST",
      success: success_ajax_response,
      error: function() {
        close_loading();
        var error_message = $("#institution_error_message").val();
        $("#create_institution_errors").switchClass("hide-field", "show-field").html("<h2>"+error_message+"</h2>");
      }
    });
  }

  function cancel_institution(evt){
    evt.preventDefault();
    $('#institution_dialog').dialog('close');
  }


  function institution_already_exists(){
    if( this.value.length >= 3 ) {
      $.get(AJAX_URL.institution_already_exists, {name:this.value}, function(response){
        if( response === true ) {
          $("#already_exists_text").switchClass("hide-field", "show-field");
        } else {
          $("#already_exists_text").switchClass("show-field", "hide-field");
        }
      });
    }
  }


  function get_clone_institution_data(value) {
    var user_institutions = $(".user_institutions").first().clone();
    user_institutions.val(value);

    return user_institutions;
  }


  function institution_autocomplete() {
    $("#input_institution").autocomplete({
      source : function(request, response){
        $.ajax({
          type: "GET",
          url: AJAX_URL.get_institutions,
          data: {query: request.term},
          success: function(result){
            response(result);

            if( result.length === 0 ) {
              $('#institution_empty_ajax_message').switchClass("hide-field", "show-field");
            } else {
              $('#institution_empty_ajax_message').switchClass("show-field", "hide-field");
            }
          },
          error: function(ajax, stat, errorThrown) {
            console.log('Link not found : ' + errorThrown);
          }
        });
      },

      minLength: 2,

      select : function (event, selected) {
        $("#institution_selected").val(selected.item.id).attr("data-name", selected.item.label);
      }
    });
  }


  function add_selected_institution_to_list(id, name) {
    var selected_institution = "<li data-institution='"+id+"'>"+name;
        selected_institution += "<a href='#' class='button without-text icon-remove remove-institution'></a></li>";

    $(".institutions_added").append(selected_institution);
  }


  function add_new_institution(evt) {
    evt.preventDefault();
    var selected = $("#institution_selected");
    var institution_already_added = $(".institutions_added li[data-institution='"+selected.val()+"']").length;

    if(selected.val().length > 0 && institution_already_added === 0) {
      //field that send the institutions to the server
      $(".institution_container").append(get_clone_institution_data(selected.val()));

      // Visualy add the selected institution to the list
      add_selected_institution_to_list(selected.val(), selected.attr("data-name"));

      // clean the institution flag
      selected.val("").attr("data-name", "");
      $("#input_institution").val("");

      $(".remove-institution").click(remove_institution);
    }
  }


  function remove_institution(evt) {
    evt.preventDefault();
    var code = $(this).parent().attr("data-institution");

    $(".user_institutions[value="+code+"]").remove();
    $(this).parent().remove();
  }


  function add_mask_to_form_items() {
    if ($.mask) {
      $("#institutions_cnpj").mask("99.999.999/9999-99");
    }
  }


  function show_hide_cnpj_city(country) {
    var cnpj = $("#institutions_cnpj").parent().parent();
    var city = $("#community_city").parent().parent();
    var state = $("#community_state").parent().parent();
    var inst_type = $("input[name='institutions[type]']:checked").val();
    institution_type_actions(inst_type);

    if( country === "-1" ) $("#community_country").val("BR");

    if( country !== "BR" ) {
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
    var country = $("#community_country").val();
    if( type === "PublicInstitution" && country == "BR") {
      show_public_institutions_fields();
    } else {
      show_private_institutions_fields();
    }
  }


  function set_form_count_custom_data() {
    var divisor_option = SelectElement.generateOption("-1", "--------------------------------");
    var default_option = SelectElement.generateOption("BR", "Brazil");


    var inst_type = $("input[name='institutions[type]']:checked").val();
    var country = $("#community_country").val();

    institution_type_actions(inst_type);
    show_hide_cnpj_city(country);

    if( $('#community_country').find("option[value='']").length === 1 ) {
      $('#community_country').find("option[value='']").remove();
      $('#community_country').prepend(divisor_option);
      $('#community_country').prepend(default_option);

      if($("#edit_institution_page").val() === "false") {
        $('#community_country').val("BR");
        show_hide_cnpj_city($('#community_country').val());
      }
    }
  }

  function autoCompleteCity() {
    var country_selected = $('#community_country').val();

    if(country_selected == "BR") {
      $('#community_city').autocomplete({
        source : function(request, response){
          $.ajax({
            type: "GET",
            url: AJAX_URL.auto_complete_city,
            data: {city_name: request.term, state_name: $("#community_state").val()},
            success: function(result){
              response(result);

              // There are two autocompletes in this page, the last one is modal
              // autocomplete just put it above the modal
              $(".ui-autocomplete").last().css("z-index", 1000);
            },
            error: function(ajax, stat, errorThrown) {
              console.log('Link not found : ' + errorThrown);
            }
          });
        },

        minLength: 3
      });
    } else {
      if ($('#community_city').data('autocomplete')) {
        $('#community_city').autocomplete("destroy");
        $('#community_city').removeData('autocomplete');
      }
    }
  }

  function set_events() {
    $("#create_institution_link").click(open_create_institution_modal);

    $("input[name='institutions[type]']").click(function(){
      institution_type_actions(this.value);
    });

    $('#save_institution_button').click(save_institution);
    $('#cancel_institution_button').click(cancel_institution);

    $("#community_name").keyup(institution_already_exists);

    $("#add_new_institution").click(add_new_institution);

    $(".remove-institution").click(remove_institution);

    $("#community_country").change(function(){
      show_hide_cnpj_city(this.value);
    });

    add_mask_to_form_items();

    institution_autocomplete();

    autoCompleteCity();
    $('#community_country').change(function(){
      autoCompleteCity();
    });
  }


  return {
    isCurrentPage: function() {
      return $("#institution_form").length === 1;
    },


    init: function() {
      set_form_count_custom_data();
      set_events();
    },

    institution_autocomplete: function(){
      institution_autocomplete();
    }
  };
});
