(function(){
	"use strict";
	var AJAX_URL = {
    get_categories:
      url_with_subdirectory("/plugin/mpog_software/get_categories")
  };

	function create_catalog_element(html_list, value, id) {
		var li_tag = document.createElement("li");
		var first = html_list.length == 0;

		if( first )
			li_tag.innerHTML = value + " <span class='catalog-remove-item'>x</span>";
		else
			li_tag.innerHTML = ", " + value + " <span class='catalog-remove-item'>x</span>";

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
  		jQuery("#catalog-list ul").append(create_catalog_element(jQuery("#catalog-list ul li"), value, id));
  	}
  }

  function remote_catalog_item() {
  	jQuery(this).parent().remove();
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
	}

	jQuery(document).ready(function(){
		set_autocomplate();
		set_events();
	});
})();
