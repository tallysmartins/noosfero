(function($){
  "use strict";

  var AJAX_URL = {
    get_categories:
      url_with_subdirectory("/plugin/mpog_software/get_categories"),
    get_search_result:
      url_with_subdirectory("/search/get_search_result")
  };

  function create_catalog_element(first, value, id) {
    var li_tag = document.createElement("li");

    li_tag.className = "category_box";
    li_tag.innerHTML = value + " <span class='catalog-remove-item' data-id='"+id+"'>x</span>";

    return li_tag;
  }

  function add_item_to_catalog(value, id) {
    var already_has = false;

    $("#catalog-list ul li").each(function(i, li){
      var regex = new RegExp(value, "g");

      if( regex.test(li.innerHTML) ) {
        already_has = true;
      }
    });

    if( !already_has ) {
      var catalog_list = $("#catalog-list ul li");
      var current_ids = $("#filter").val();
      var first = catalog_list.length == 0;

      current_ids +=  first ? id : ","+id;

      $("#filter").val(current_ids);

      $("#catalog-list ul").append(create_catalog_element(first, value, id));
    }
  }

  function remote_catalog_item() {
    var current_id = this.getAttribute("data-id");
    var filter_ids = $("#filter").val();
    var id_list = [];

    filter_ids.split(",").forEach(function(id){
      if( current_id != id ) {
        id_list.push(id);
      }
    });

    $("#filter").val(id_list.join(","));

    $(this).parent().remove();
  }

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
  }

  function dispatch_search_ajax(callback) {
    var query_text = $("#search-input").val();
    var selected_categories_ids = [];

    $(".categories-catalog:checked").each(function(index, element) {
      selected_categories_ids.push(element.value);
    });


    $.ajax({
      url: AJAX_URL.get_search_result,
      type: "GET",
      data: {
        query: query_text,
        categories_ids: selected_categories_ids
      },
      success: function(response) {
        console.log(response);
        callback(response);
      }
    });
  }

  function update_page_list() {

  }

  function selectCheckboxCategory() {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();

    dispatch_search_ajax(update_page_list);
  }

  function selectProjectSoftwareCheckbox() {
    $("#filter-categories-option").slideUp();
    $("#filter-categories-select-catalog").show();
    $("#filter-option-catalog-software").hide();
  }

  function set_autocomplate() {
    $("#software-catalog").autocomplete({
      source : function(request, response){
        $.ajax({
          type: "GET",
          url: AJAX_URL.get_categories,
          data: {query: request.term},
          success: function(result){
            response(result);
          }
        })
      },

      select : function (event, selected) {
        var value = selected.item.value;
        var id = selected.item.id;

        this.value = "";

        add_item_to_catalog(value, id);
        set_events();

        return false;
      }
    });
  }

  function set_events() {
    $(".catalog-remove-item").click(remote_catalog_item);
    $("#filter-option-catalog-software").click(slideDowsCategoriesOptionAndHideOptionCatalog);
    $("#filter-categories-select-catalog").click(slideDownCategoriesOptionAndHideCategoriesSelect);
    $("#close-filter-catalog").click(slideUpCategoriesAndShowHeadMessage);
    $("#cleanup-filter-catalg").click(clearCatalogCheckbox);
    $(".categories-catalog").click(selectCheckboxCategory);
    $(".project-software").click(selectProjectSoftwareCheckbox);
  }


  $(document).ready(function(){
    set_autocomplate();
    set_events();
    show_head_message();
    $("#filter-categories-option").hide();
  });

})(jQuery);
