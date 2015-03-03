modulejs.define('SearchSoftwareCatalog', ['jquery', 'NoosferoRoot'], function($, NoosferoRoot) {
  'use strict';

  var AJAX_URL = {
    software_infos:
      NoosferoRoot.urlWithSubDirectory("/search/software_infos")
  };


  function show_head_message() {
    if ($("#filter-categories-select-catalog").text()){
      $("#filter-categories-select-catalog").hide();
      $("#filter-option-catalog-software").show();
    }else{
      $("#filter-categories-select-catalog").show();
      $("#filter-option-catalog-software").hide();
    }
  }


  function slideDowsCategoriesOptionAndHideOptionCatalog() {
    $("#filter-categories-option").slideDown();
    $("#filter-option-catalog-software").hide();
  }


  function slideDownCategoriesOptionAndHideCategoriesSelect() {
    $("#filter-categories-option").slideDown();
    $("#filter-categories-select-catalog").hide();
  }


  function slideUpCategoriesAndShowHeadMessage() {
    $("#filter-categories-option").slideUp();
    show_head_message();
  }


  function clearCatalogCheckbox(){
    $("#filter-categories-option").slideUp();
    $("#filter-option-catalog-software").show();
    $("#group-categories input:checked").each(function() {
      $(this).prop('checked', false);
    });

    dispatch_search_ajax(update_search_page_on_ajax, true);
  }


  function selectCheckboxCategory() {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();

    dispatch_search_ajax(update_search_page_on_ajax, true);
  }


  function dispatch_search_ajax(callback, enable_load) {
    var search_params = get_search_params();

    if(enable_load) {
      open_loading("Loading");
    }

    $.ajax({
      url: AJAX_URL.software_infos,
      type: "GET",
      data: search_params,
      success: callback,
      error: function(){
        close_loading();
      }
    });
  }


  function get_search_params() {
    var params = {};

    params.query = $("#search-input").val();
    params.selected_categories = [];

    $(".categories-catalog:checked").each(function(index, element) {
      params.selected_categories.push(element.value);
    });

    params.software_display = $("#software_display").val();
    params.sort = $("#sort").val();

    params.include_non_public = $("#include_non_public").is(":checked");

    return params;
  }


  function get_result_div_core(message){
    var div_result = $(".search-results-type-empty");
    var html = '<div class="search-results-innerbox search-results-type-empty"> <div>'+message+' </div></div>'

    div_result.replaceWith('<div class="search-results-innerbox search-results-type-empty"> <div>Nenhum software encontrado</div> '+message+'</div>')
  }


  function catalog_message(){
    var result_list = $("#search-results").find('.search-results-empty');
    var selected_categories_field = $("#filter-categories-select-catalog");

    if(result_list.length > 1 && selected_categories_field.html().length < 1){
      get_result_div_core("Tente filtros mais abrangentes");
    }else if (result_list.length > 1 && selected_categories_field.html().length >= 1) {
      get_result_div_core("Tente filtros mais abrangentes ou confira os softwares das categorias individualmente");
    }
  }


  function update_search_page_on_ajax(response) {
    response = $(response);
    var search_list = $("#search-results");
    var selected_categories_field = $("#filter-categories-select-catalog");
    var pagination = $("#software-pagination");
    var software_count = $("#software-count");

    var result_list = response.find("#search-results").html();
    var result_categories = response.find("#filter-categories-select-catalog").html();
    var result_pagination = response.find("#software-pagination").html();
    var result_software_count = response.find("#software-count").html();

    catalog_message()

    search_list.html(result_list);
    selected_categories_field.html(result_categories);
    pagination.html(result_pagination);
    software_count.html(result_software_count);
    show_head_message();
    highlight_searched_terms();

    hide_load_after_ajax();
  }


  function hide_load_after_ajax() {
    if ($("#overlay_loading_modal").is(":visible")) {
      close_loading();
      setTimeout(hide_load_after_ajax, 1000);
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


  function selectProjectSoftwareCheckbox() {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();

    dispatch_search_ajax(update_search_page_on_ajax, true);
    show_head_message();
  }


  function update_page_by_ajax_on_select_change() {
    dispatch_search_ajax(update_search_page_on_ajax, true);
  }

  function update_page_by_text_filter() {
    var text = this.value;
    dispatch_search_ajax(update_search_page_on_ajax, false);
  }


  function search_input_keyup() {
    var timer = null;

    $("#search-input").keyup(function() {
        timer = setTimeout(update_page_by_text_filter, 400);
    }).keydown(function() {
        clearTimeout(timer);
    });
  }


  function set_events() {
    $("#filter-option-catalog-software").click(slideDowsCategoriesOptionAndHideOptionCatalog);
    $("#filter-categories-select-catalog").click(slideDownCategoriesOptionAndHideCategoriesSelect);
    $("#close-filter-catalog").click(slideUpCategoriesAndShowHeadMessage);
    $("#cleanup-filter-catalg").click(clearCatalogCheckbox);
    $(".categories-catalog").click(selectCheckboxCategory);
    $(".project-software").click(selectProjectSoftwareCheckbox);
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
      show_head_message();

      $("#filter-categories-option").hide();
    }
  }
});