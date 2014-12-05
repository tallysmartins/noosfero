(function($){
  "use strict";// Make javascript less intolerant to errors

  var TRANSITION_TIME = 250;// milliseconds


  function show_finality() {
    var finality = $(this).children(".software-block-finality");

    finality.stop().animate({"top" : "0%"}, TRANSITION_TIME);
  }

  function hide_finality() {
    var finality = $(this).children(".software-block-finality");

    finality.stop().animate({"top" : "100%"}, TRANSITION_TIME);
  }

  function set_events() {
    $(".software-block").mouseover(show_finality);
    $(".software-block").mouseout(hide_finality);
  }

  $(document).ready(function(){
    set_events();
  });
})(jQuery);