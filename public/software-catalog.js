(function(){
  "use strict";

  var AJAX_URL = {
    get_categories:
      url_with_subdirectory("/plugin/mpog_software/get_categories")
  };

  function create_catalog_element(first, value, id) {
    var li_tag = document.createElement("li");

    li_tag.className = "category_box";
    li_tag.innerHTML = value + " <span class='catalog-remove-item' data-id='"+id+"'>x</span>";

    return li_tag;
  }

  function add_item_to_catalog(value, id) {
    var already_has = false;

    jQuery("#catalog-list ul li").each(function(i, li){
      var regex = new RegExp(value, "g");

      if( regex.test(li.innerHTML) ) {
        already_has = true;
      }
    });

    if( !already_has ) {
      var catalog_list = jQuery("#catalog-list ul li");
      var current_ids = jQuery("#filter").val();
      var first = catalog_list.length == 0;

      current_ids +=  first ? id : ","+id;

      jQuery("#filter").val(current_ids);

      jQuery("#catalog-list ul").append(create_catalog_element(first, value, id));
    }
  }

  function remote_catalog_item() {
    var current_id = this.getAttribute("data-id");
    var filter_ids = jQuery("#filter").val();
    var id_list = [];

    filter_ids.split(",").forEach(function(id){
      if( current_id != id ) {
        id_list.push(id);
      }
    });

    jQuery("#filter").val(id_list.join(","));

    jQuery(this).parent().remove();
  }

  function show_head_message() {
    if (jQuery("#filter-categories-select-catalog").text().blank()){
      jQuery("#filter-categories-select-catalog").hide();
      jQuery("#filter-option-catalog-software").show();
    }else{
      jQuery("#filter-categories-select-catalog").show();
      jQuery("#filter-option-catalog-software").hide();
    }
  }

  function slideDowsCategoriesOptionAndHideOptionCatalog() {
    jQuery("#filter-categories-option").slideDown();
    jQuery("#filter-option-catalog-software").hide();
  }

  function slideDownCategoriesOptionAndHideCategoriesSelect() {
    jQuery("#filter-categories-option").slideDown();
    jQuery("#filter-categories-select-catalog").hide();
  }

  function slideUpCategoriesAndShowHeadMessage() {
    jQuery("#filter-categories-option").slideUp();
    show_head_message();
  }

  function clearCatalogCheckbox(){
    jQuery("#filter-categories-option").slideUp();
    jQuery("#filter-option-catalog-software").show();
    jQuery("#group-categories input:checked").each(function() {
      jQuery(this).prop('checked', false);
    });
  }

  function selectCheckboxCategory() {
    jQuery("#filter-categories-option").slideUp();
    jQuery("#filter-categories-select-catalog").show();
    jQuery("#filter-option-catalog-software").hide();
  }

  function selectProjectSoftwareCheckbox() {
    jQuery("#filter-categories-option").slideUp();
    jQuery("#filter-categories-select-catalog").show();
    jQuery("#filter-option-catalog-software").hide();
  }

  function set_autocomplate() {
    jQuery("#software-catalog").autocomplete({
      source : function(request, response){
        jQuery.ajax({
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
    jQuery(".catalog-remove-item").click(remote_catalog_item);
    jQuery("#filter-option-catalog-software").click(slideDowsCategoriesOptionAndHideOptionCatalog);
    jQuery("#filter-categories-select-catalog").click(slideDownCategoriesOptionAndHideCategoriesSelect);
    jQuery("#close-filter-catalog").click(slideUpCategoriesAndShowHeadMessage);
    jQuery("#cleanup-filter-catalg").click(clearCatalogCheckbox);
    jQuery(".categories-catalog").click(selectCheckboxCategory);
    jQuery(".project-software").click(selectProjectSoftwareCheckbox);
  }


  jQuery(document).ready(function(){
    set_autocomplate();
    set_events();
    show_head_message();
    jQuery("#filter-categories-option").hide();
  });

})();
