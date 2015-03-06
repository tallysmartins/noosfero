modulejs.define('SoftwareCatalogComponent', ['jquery'], function($) {
  'use strict';

  var dispatch_ajax_function;


  function show_head_message() {
    if ($("#filter-categories-select-catalog").text().length === 0){
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


  function clearCatalogCheckbox() {
    $("#filter-categories-option").slideUp();
    $("#filter-option-catalog-software").show();
    $("#group-categories input:checked").each(function() {
      $(this).prop('checked', false);
    });

    dispatch_ajax_function(true);
  }


  function selectCheckboxCategory(dispatch_ajax) {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();

    dispatch_ajax_function(true);
  }


  function selectProjectSoftwareCheckbox() {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();

    dispatch_ajax_function(true);
    show_head_message();
  }


  function set_events() {
    $("#filter-option-catalog-software").click(slideDowsCategoriesOptionAndHideOptionCatalog);
    $("#filter-categories-select-catalog").click(slideDownCategoriesOptionAndHideCategoriesSelect);
    $("#close-filter-catalog").click(slideUpCategoriesAndShowHeadMessage);
    $("#cleanup-filter-catalg").click(clearCatalogCheckbox);
    $(".categories-catalog").click(selectCheckboxCategory);
    $(".project-software").click(selectProjectSoftwareCheckbox);
  }


  return {
    init: function(dispatch_ajax) {
      dispatch_ajax_function = dispatch_ajax;
      set_events();
      show_head_message();
    },
  }
});
