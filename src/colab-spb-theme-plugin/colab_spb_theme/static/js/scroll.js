var colab = (function( $ ){
  var $window = $(window);

  var sidebar, offset, maxMarginTop, reference,

  sidebarScroll = function() {

    if($window.scrollTop() > offset.top) {
      var marginTop = $window.scrollTop() - offset.top;
      marginTop = marginTop > maxMarginTop ? maxMarginTop : marginTop;

      sidebar.stop().animate({
        marginTop: marginTop
      });
    } else {
      sidebar.stop().animate({
        marginTop: 0
      });
    }
  },

  init = function(sidebarSelector, referenceSelector) {
    sidebar = $(sidebarSelector);
    reference = $(referenceSelector);
    offset = sidebar.offset();
    maxMarginTop = reference.height() - sidebar.height();

    $window.scroll(function() {
      sidebarScroll();
    });
  };


  return {
    init: init
  };
})( jQuery );
