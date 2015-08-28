modulejs.define('SoftwareCatalogComponent', ['jquery'], function($) {
  'use strict';

  var dispatch_ajax_function;

  function clearCatalogCheckbox() {
    $("#group-categories input:checked").each(function() {
      $(this).prop('checked', false);
    });

    dispatch_ajax_function(true);
  }


  function selectCheckboxCategory(dispatch_ajax) {
    dispatch_ajax_function(true);
  }


  function selectProjectSoftwareCheckbox() {
    dispatch_ajax_function(true);
  }


  function set_events() {
    $("#cleanup-filter-catalg").click(clearCatalogCheckbox);
    $(".categories-catalog").click(selectCheckboxCategory);
    $(".project-software").click(selectProjectSoftwareCheckbox);
  }

  return {
    init: function(dispatch_ajax) {
      dispatch_ajax_function = dispatch_ajax;
      set_events();
    },
  }
});

