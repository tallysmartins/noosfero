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

  function set_events() {
    show_community_fields();

    jQuery("#type_Community").click(show_community_fields);

    jQuery("#type_Software").click(show_software_fields);

    jQuery("#type_Institution").click(show_institutions_fields);
  }

  jQuery(document).ready(set_events);
})();
