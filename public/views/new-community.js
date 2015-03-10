modulejs.define("NewCommunity", ['jquery'], function($){

  function replace_mandatory_message(){
    $(".required-field").first()
    .replaceWith("<span class='required-field'> Os campos em destaque<label class='pseudoformlabel'> (*)</label> são obrigatórios. </span>");
  }

  return {

    isCurrentPage: function() {
      return true;
    },

    init: function() {
      replace_mandatory_message();
    }
  }
})
