(function(){
  function database_autocomplete() {
    jQuery(".database_autocomplete").autocomplete({
      source : function(request, response){
        jQuery.ajax({
          type: "GET",
          url: "/plugin/mpog_software/get_databases",
          data: {query: request.term},
          success: function(result){
            response(result);

            /*if( result.length == 0 ) {
              jQuery('#institution_empty_ajax_message').switchClass("hide-field", "show-field");
            } else {
              jQuery('#institution_empty_ajax_message').switchClass("show-field", "hide-field");
            }*/
          },
          error: function(ajax, stat, errorThrown) {
            console.log('Link not found : ' + errorThrown);
          }
        });
      },

      minLength: 1,

      select : function (event, selected) {
        jQuery(this)
          .parent().parent()
            .find(".database_description_id")
              .val(selected.item.id);
      }
    });
  }


  function delete_dynamic_table() {
    var button = jQuery(".delete-dynamic-table");

    button.each(function(){
      var table = jQuery(this).parent().parent().parent().parent();
      var color = table.css("background-color");

      jQuery(this).click(function(){
        table.remove();
        return false;
      }).mouseover(function(){
        table.css("background-color", "#eee");
      }).mouseout(function(){
        table.css("background-color", color);
      });
    });
  }

  function has_more_than_one(table_class) {
    return (jQuery("."+table_class).length > 2); // One is always added by defaul and its hidden
  }

  function add_dynamic_table(element_id, content) {
    Element.insert(element_id, {bottom: content});
  }

  function get_license_link(select_id){
    var selected = jQuery('#'+select_id).selected().val();
    var link = jQuery("#version_" + selected).val();

    jQuery("#version_link")
      .attr("href", link)
      .text(link);
  }

  function hide_infos(){
    jQuery(".language-info").hide();
    jQuery(".database-info").hide();
    jQuery(".libraries-info").hide();
    jQuery(".operating-system-info").hide();
    jQuery(".language-button-hide").hide();
    jQuery(".database-button-hide").hide();
    jQuery(".libraries-button-hide").hide();
    jQuery(".operating-system-button-hide").hide();
  }

  jQuery(document).ready(function(){
    var dynamic_tables = ["dynamic-databases", "dynamic-languages", "dynamic-libraries","dynamic-operating_systems"];

    delete_dynamic_table();
    database_autocomplete();

    jQuery(".new-dynamic-table").click(function(){
      var link = jQuery(this);

      dynamic_tables.each(function(value){
        if( link.hasClass(value) ) {
          var table_id = value.split("-")[1];

          var table_html = jQuery("#table_structure_"+table_id).html();
          add_dynamic_table(table_id, table_html);
        }
      });

      delete_dynamic_table();
      database_autocomplete();
      return false;
    });

    jQuery(".language-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".language-info").hide();
      jQuery(".language-button-show").show();
      jQuery(".language-button-hide").hide();
    });

    jQuery(".language-button-show").click(function(event){
      event.preventDefault();
      jQuery(".language-info").show();
      jQuery(".language-button-show").hide();
      jQuery(".language-button-hide").show();
    });

    jQuery(".operating-system-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".operating-system-info").hide();
      jQuery(".operating-system-button-show").show();
      jQuery(".operating-system-button-hide").hide();
    });

    jQuery(".operating-system-button-show").click(function(event){
      event.preventDefault();
      jQuery(".operating-system-info").show();
      jQuery(".operating-system-button-show").hide();
      jQuery(".operating-system-button-hide").show();
    });

    jQuery(".database-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".database-info").hide();
      jQuery(".database-button-show").show();
      jQuery(".database-button-hide").hide();
    });

    jQuery(".database-button-show").click(function(event){
      event.preventDefault();
      jQuery(".database-info").show();
      jQuery(".database-button-show").hide();
      jQuery(".database-button-hide").show();
    });

    jQuery(".libraries-button-hide").click(function(event){
      event.preventDefault();
      jQuery(".libraries-info").hide();
      jQuery(".libraries-button-show").show();
      jQuery(".libraries-button-hide").hide();
    });

    jQuery(".libraries-button-show").click(function(event){
      event.preventDefault();
      jQuery(".libraries-info").show();
      jQuery(".libraries-button-show").hide();
      jQuery(".libraries-button-hide").show();
    });
  });
})();
