modulejs.define("NewCommunity", ['jquery'], function($) {

  function replace_mandatory_message() {
    $(".required-field").first()
    .replaceWith("<span class='required-field'> Os campos em destaque<label class='pseudoformlabel'> (*)</label> são obrigatórios. </span>");
  }

  function remove_image_builder_text() {
    $("label:contains('Image builder')").hide();
  }

  return {

    isCurrentPage: function() {
      return true;
    },

    init: function() {
      replace_mandatory_message();
      remove_image_builder_text();
    }
  }
})
