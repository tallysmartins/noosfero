modulejs.define('SearchSoftwareCatalog', ['jquery', 'NoosferoRoot', 'SoftwareCatalogComponent'], function($, NoosferoRoot, SoftwareCatalogComponent) {
  'use strict';

  var AJAX_URL = {
    software_infos:
      NoosferoRoot.urlWithSubDirectory("/search/software_infos")
  };


  function dispatch_search_ajax(enable_load) {
    var search_params = get_search_params();

    if(enable_load) {
      open_loading("Loading");
    }

    $.ajax({
      url: AJAX_URL.software_infos,
      type: "GET",
      data: search_params,
      success: update_search_page_on_ajax,
      error: function(){
        close_loading();
      }
    });
  }


  function get_search_params() {
    var params = {};

    params.query = $("#search-input").val();
    params.selected_categories_id = [];

    $(".categories-catalog:checked").each(function(index, element) {
      params.selected_categories_id.push(element.value);
    });

    params.software_display = $("#software_display").val();
    params.sort = $("#sort").val();

    params.include_non_public = $("#include_non_public").is(":checked");

    return params;
  }


  function get_result_div_core(message) {
    $("#search-results-empty").html(message);
  }


  function catalog_message() {
    var empty_result = $('#empty_result').val() === 'true';
    var user_selected_categories = $('.categories-catalog:checked').length !== 0;

    if(empty_result && !user_selected_categories) {
      get_result_div_core($('#message-no-catalog-selected').val());
    } else if (empty_result && user_selected_categories) {
      get_result_div_core($('#message-catalog-selected').val());
    }
  }


  function update_search_page_on_ajax(response) {
    response = $(response);

    var search_list = $("#search-results");
    var selected_categories_field = $("#filter-categories-select-catalog");
    var pagination = $("#software-pagination");
    var software_count = $("#software-count");
    var individually_category = $("#individually-category");

    var result_list = response.find("#search-results").html();
    var result_categories = response.find("#filter-categories-select-catalog").html();
    var result_pagination = response.find("#software-pagination").html();
    var result_software_count = response.find("#software-count").html();
    var result_individually_category = response.find("#individually-category").html();

    search_list.html(result_list);
    selected_categories_field.html(result_categories);
    pagination.html(result_pagination);
    software_count.html(result_software_count);
    individually_category.html(result_individually_category);

    highlight_searched_terms();
    catalog_message();

    hide_load_after_ajax();
  }


  function hide_load_after_ajax() {
    if ($("#overlay_loading_modal").is(":visible")) {
      close_loading();
      setTimeout(hide_load_after_ajax, 1500);
    }
  }


  function highlight_searched_terms() {
    var searched_terms = $("#search-input").val();

    if( searched_terms.length === 0 ) {
      return undefined;
    }

    var content_result = $(".search-content-result");
    var regex = new RegExp("("+searched_terms.replace(/\s/g, "|")+")", "gi");

    content_result.each(function(i, e){
      var element = $(e);

      var new_text = element.text().replace(regex, function(text) {
        return "<strong>"+text+"</strong>";
      });

      element.html(new_text);
    });
  }


  function update_page_by_ajax_on_select_change() {
    dispatch_search_ajax(true);
  }

  function update_page_by_text_filter() {
    var text = this.value;
    dispatch_search_ajax(false);
  }


  function search_input_keyup() {
    var timer = null;

    $("#search-input").keyup(function() {
        // Only start the search(with ajax) after 3 characters
        if(this.value.length >= 3) {
          timer = setTimeout(update_page_by_text_filter, 400);
        }
    }).keydown(function() {
        clearTimeout(timer);
    });
  }


  function set_events() {
    $("#software_display").change(update_page_by_ajax_on_select_change);
    $("#sort").change(update_page_by_ajax_on_select_change);

    search_input_keyup();
  }


  return {
    isCurrentPage: function() {
      return $('#software-search-container').length === 1;
    },


    init: function() {
      set_events();
      catalog_message();
      SoftwareCatalogComponent.init(dispatch_search_ajax);
    }
  }
});

