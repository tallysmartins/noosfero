modulejs.define('NewSoftware', ['jquery', 'NoosferoRoot', 'AutoComplete', 'NewCommunity'], function($, NoosferoRoot, AutoComplete, Community) {
  'use strict';

  var AJAX_URL = {
    get_license_data:
      NoosferoRoot.urlWithSubDirectory("/plugin/software_communities/get_license_data")
  };

  function replace_domain_and_repository_link(){
    var community_name = $("#community_name_id").val();
    var domain =  'https://';
    domain = domain.concat($("#software-hostname").text());

    var slug_name = community_name.replace(/\s+/g, '-').toLowerCase();

    var custom_domain = domain.concat('<your-repository>');
    custom_domain = custom_domain.concat('/');
    custom_domain = custom_domain.concat(slug_name);

    $("#community-identifier").val(slug_name);
    $("#software-info-repository-link").val(custom_domain);
  }

  function show_another_license_on_page_load() {
    $("#license_info_id").trigger("change");
  }


  function display_another_license_fields(selected) {
    if( selected === "Another" ) {
      $("#another_license").removeClass("hide-field");
      $("#version_link").addClass("hide-field");
    } else {
      $("#another_license").addClass("hide-field");
      $("#version_link").removeClass("hide-field");
    }
  }


  function display_license_link_on_autocomplete(selected) {
    var link = $("#version_" + selected.item.id).val();
    $("#version_link").attr("href", link);

    display_another_license_fields(selected.item.label);
  }


  function license_info_autocomplete() {
    AutoComplete.enable(
      "license_info", ".license_info_id", ".license_info_version",
      AJAX_URL.get_license_data, display_license_link_on_autocomplete
    );
  }


  return {
    isCurrentPage: function() {
      return $('#new-software-page').length === 1;
    },


    init: function() {
      license_info_autocomplete();
      Community.init();

      $("#community_name_id").blur(replace_domain_and_repository_link);
    }
  }
});
