modulejs.define("NewCommunity", ['jquery'], function($) {

  function remove_image_builder_text() {
    $("label:contains('Image builder')").hide();
  }
  
  function hide_organization_template_fields(){
    $('#template-options').hide();
  }

  return {

    isCurrentPage: function() {
      return true;
    },

    init: function() {
      remove_image_builder_text();
      hide_organization_template_fields();
    }
  }
})
