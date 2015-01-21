jQuery(function(){
  function show_head_message() {
    if (jQuery("#filter-categories-select-catalog").text().blank()){
      jQuery("#filter-categories-select-catalog").hide();
      jQuery("#filter-option-catalog-software").show();
    }else{
      jQuery("#filter-categories-select-catalog").show();
      jQuery("#filter-option-catalog-software").hide();
    }
  }

  show_head_message();

  jQuery("#filter-categories-option").hide();
  jQuery("#filter-option-catalog-software").click(function(){
    jQuery("#filter-categories-option").slideDown();
    jQuery("#filter-option-catalog-software").hide();
  });

  jQuery("#filter-categories-option").hide();
  jQuery("#filter-categories-select-catalog").click(function(){
    jQuery("#filter-categories-option").slideDown();
    jQuery("#filter-categories-select-catalog").hide();
  });

  jQuery("#close-filter-catalog").click(function(){
    jQuery("#filter-categories-option").slideUp();
    show_head_message();
  });

  jQuery("#cleanup-filter-catalg").click(function(){
    jQuery("#filter-categories-option").slideUp();
    jQuery("#filter-option-catalog-software").show();
    jQuery("#group-categories input:checked").each(function() {
      jQuery(this).prop('checked', false);
    });
  });

  jQuery(".categories-catalog").click(function(){
    jQuery("#filter-categories-option").slideUp();
    jQuery("#filter-categories-select-catalog").show();
    jQuery("#filter-option-catalog-software").hide();
  });

  jQuery(".project-software").click(function(){
    jQuery("#filter-categories-option").slideUp();
    jQuery("#filter-categories-select-catalog").show();
    jQuery("#filter-option-catalog-software").hide();
  });

  function clear_categories_filter(e) {
    e.preventDefault();
    jQuery("#categories-filter input:checked").each(function() {
      jQuery(this).prop('checked', false);
    });
  }
});


