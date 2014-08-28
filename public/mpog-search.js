(function(){

  function show_institutions_fields() {
    jQuery(".institution_fields").show();
    jQuery(".software_fields").hide();
    jQuery(".community_fields").hide();
  }

  function show_software_fields() {
    jQuery(".institution_fields").hide();
    jQuery(".software_fields").show();
    jQuery(".community_fields").hide();
  }

  function show_community_fields() {
    jQuery(".institution_fields").hide();
    jQuery(".software_fields").hide();
    jQuery(".community_fields").show();
  }

  function display_search_fields_on_page_load() {
    var active_search = jQuery(".search_type input[checked='checked']").val();

    switch(active_search) {
      case "Community": show_community_fields(); break;
      case "Software": show_software_fields(); break;
      case "Institution": show_institutions_fields(); break;

      default: show_community_fields();
    }
  }

  function set_events() {
    display_search_fields_on_page_load();

    jQuery("#type_Community").click(show_community_fields);

    jQuery("#type_Software").click(show_software_fields);

    jQuery("#type_Institution").click(show_institutions_fields);
  }

  jQuery(document).ready(set_events);
})();
