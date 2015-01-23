(function($){
  "use strict";

  var AJAX_URL = {
    software_infos:
      url_with_subdirectory("/search/software_infos")
  };


  function show_head_message() {
    if ($("#filter-categories-select-catalog").text().blank()){
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

    dispatch_search_ajax(update_search_page_on_ajax);
  }


  function selectCheckboxCategory() {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();

    dispatch_search_ajax(update_search_page_on_ajax);
  }


  function dispatch_search_ajax(callback) {
    var search_params = get_search_params();

    console.log(search_params);

    open_loading("Loading");

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


  function update_search_page_on_ajax(response) {
    close_loading();
    response = $(response);
    var search_list = $("#search-results");
    var selected_categories_field = $("#filter-categories-select-catalog");
    var pagination = $("#software-pagination");

    var result_list = response.find("#search-results").html();
    var result_categories = response.find("#filter-categories-select-catalog").html();
    var result_pagination = response.find("#software-pagination").html();

    search_list.html(result_list);
    selected_categories_field.html(result_categories);
    pagination.html(result_pagination);
    show_head_message();
  }


  function selectProjectSoftwareCheckbox() {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();

    dispatch_search_ajax(update_search_page_on_ajax);
    show_head_message();
  }

  function update_page_by_ajax_on_select_change() {
    dispatch_search_ajax(update_search_page_on_ajax);
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
  }


  $(document).ready(function(){
    set_events();
    show_head_message();
    $("#filter-categories-option").hide();
  });
})(jQuery);
